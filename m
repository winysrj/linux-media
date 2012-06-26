Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179Ab2FZV5B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 17:57:01 -0400
Message-ID: <1340747800.1170.16.camel@mop>
Subject: Re: [PATCH RFC 3/4] em28xx: Workaround for new udev versions
From: Kay Sievers <kay@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Tue, 26 Jun 2012 23:56:40 +0200
In-Reply-To: <4FEA24AD.6060305@redhat.com>
References: <4FE9169D.5020300@redhat.com>
	 <1340739262-13747-1-git-send-email-mchehab@redhat.com>
	 <1340739262-13747-4-git-send-email-mchehab@redhat.com>
	 <20120626204002.GB3885@kroah.com> <4FEA24AD.6060305@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2012-06-26 at 18:07 -0300, Mauro Carvalho Chehab wrote:
> Em 26-06-2012 17:40, Greg KH escreveu:
> > On Tue, Jun 26, 2012 at 04:34:21PM -0300, Mauro Carvalho Chehab wrote:
> >> New udev-182 seems to be buggy: even when usermode is enabled, it
> >> insists on needing that probe would defer any firmware requests.
> >> So, drivers with firmware need to defer probe for the first
> >> driver's core request, otherwise an useless penalty of 30 seconds
> >> happens, as udev will refuse to load any firmware.
> > 
> > Shouldn't you fix udev, if it really is a problem here?  Papering over
> > userspace bugs in the kernel isn't usually a good thing to do, as odds
> > are, it will hit some other driver sometime, right?
> 
> That's my opinion too, but Kay seems to think otherwise. On his opinion,
> waiting for firmware during module_init() is something that were never
> allowed at the device model.

No, that's not at all an udev *bug*, the changelog in this patch is just
plain wrong. It's just udev making noise about a broken driver behavior.
And it's the messenger, not the problem.

Kernel modules must not block in module_init() in a userspace
transaction (fw load) that can take an unpredictable amount of time. It
results in broken suspend/resume paths, or broken compiled-in module
behaviour, and a modprobe processes which hangs uninterruptible until
the firmware timeout happens.

Uevents have dependencies, if a parent device event calls modprobe, the
child device it creates will waits for the parent event to finish, but
if the parent blocks in modprobe, it will not finish and we run into the
deadlock udev complains about.

Udev used to work around that, that workaround we turned into the logged
error we see now. Again, uninterruptible blocking of module_init() in a
in-kernel callout-to-userspace is not proper driver behavior, and needs
to be changed. 

Thanks,
Kay

