Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab2FZVIJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 17:08:09 -0400
Message-ID: <4FEA24AD.6060305@redhat.com>
Date: Tue, 26 Jun 2012 18:07:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@redhat.com>
CC: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 3/4] em28xx: Workaround for new udev versions
References: <4FE9169D.5020300@redhat.com> <1340739262-13747-1-git-send-email-mchehab@redhat.com> <1340739262-13747-4-git-send-email-mchehab@redhat.com> <20120626204002.GB3885@kroah.com>
In-Reply-To: <20120626204002.GB3885@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 26-06-2012 17:40, Greg KH escreveu:
> On Tue, Jun 26, 2012 at 04:34:21PM -0300, Mauro Carvalho Chehab wrote:
>> New udev-182 seems to be buggy: even when usermode is enabled, it
>> insists on needing that probe would defer any firmware requests.
>> So, drivers with firmware need to defer probe for the first
>> driver's core request, otherwise an useless penalty of 30 seconds
>> happens, as udev will refuse to load any firmware.
> 
> Shouldn't you fix udev, if it really is a problem here?  Papering over
> userspace bugs in the kernel isn't usually a good thing to do, as odds
> are, it will hit some other driver sometime, right?

That's my opinion too, but Kay seems to think otherwise. On his opinion,
waiting for firmware during module_init() is something that were never
allowed at the device model.

Regards,
Mauro
