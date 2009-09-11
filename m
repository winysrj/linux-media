Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36207 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbZIKM73 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 08:59:29 -0400
Date: Fri, 11 Sep 2009 09:59:00 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: RFCv2: Media controller proposal
Message-ID: <20090911095900.1cec886d@caramujo.chehab.org>
In-Reply-To: <829197380909101327s6d14332ft6435f817f2f6862@mail.gmail.com>
References: <200909100913.09065.hverkuil@xs4all.nl>
	<20090910172013.55825d2e@caramujo.chehab.org>
	<829197380909101327s6d14332ft6435f817f2f6862@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 10 Sep 2009 16:27:20 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> On Thu, Sep 10, 2009 at 4:20 PM, Mauro Carvalho
> Chehab<mchehab@infradead.org> wrote:
> > In fact, this can already be done by using the sysfs interface. the current
> > version of v4l2-sysfs-path.c already enumerates the associated nodes to
> > a /dev/video device, by just navigating at the already existing device
> > description nodes at sysfs. I hadn't tried yet, but I bet that a similar kind
> > of topology can be obtained from a dvb device (probably, we need to do some
> > adjustments).
> 
> For the audio case, I did some digging into this a bit and It's worth
> noting that this behavior varies by driver (at least on USB).  In some
> cases, the parent points to the USB device, in other cases it points
> to the USB interface.  My original thought was to pick one or the
> other and make the various drivers consistent, but even that is a
> challenge since in some cases the audio device was provided by
> snd-usb-audio (which has no knowledge of the v4l subsystem).

We may consider adding a quick at snd-usb-audio for em28xx devices, in order
to create the proper sysfs nodes.

Cheers,
Mauro
