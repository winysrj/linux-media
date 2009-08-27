Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50913 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbZH0Tc3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 15:32:29 -0400
Date: Thu, 27 Aug 2009 16:32:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Peter Brouwer <pb.maillists@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Input <linux-input@vger.kernel.org>
Subject: Re: [RFC] Infrared Keycode standardization
Message-ID: <20090827163224.445e5610@pedra.chehab.org>
In-Reply-To: <829197380908271017x4247a550t44155a46c7e23c79@mail.gmail.com>
References: <20090827045710.2d8a7010@pedra.chehab.org>
	<4A96BD05.1080205@googlemail.com>
	<829197380908271017x4247a550t44155a46c7e23c79@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 27 Aug 2009 13:17:57 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> On Thu, Aug 27, 2009 at 1:06 PM, Peter
> Brouwer<pb.maillists@googlemail.com> wrote:
> > Mauro Carvalho Chehab wrote:
> >
> > Hi Mauro, All
> >
> > Would it be an alternative to let lirc do the mapping and just let the
> > driver pass the codes of the remote to the event port.

For most devices, this is already allowed, via the standard
EVIOCGKEYCODE/EVIOCSKEYCODE ioctl. 

There's a small application showing how to change the keycodes. It is called
"keytable", and it is avalable at v4l2-apps/util directory at our development
tree:
	http://linuxtv.org/hg/v4l-dvb

Yet, there are some DVB-only devices that use a different way to support event
interface that doesn't allow userspace to replace the IR tables. I've looked on
the dvb-usb code recently. While a patch for it is not trivial, it shouldn't be
that hard to change it to support the key GET/SET ioctls, but a patch for it
requires some care, since it will touch on several different places and drivers.

I'll probably try to address this later.

Cheers,
Mauro
