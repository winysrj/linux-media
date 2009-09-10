Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:51904 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092AbZIJU1R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 16:27:17 -0400
Received: by fxm17 with SMTP id 17so387731fxm.37
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 13:27:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090910172013.55825d2e@caramujo.chehab.org>
References: <200909100913.09065.hverkuil@xs4all.nl>
	 <20090910172013.55825d2e@caramujo.chehab.org>
Date: Thu, 10 Sep 2009 16:27:20 -0400
Message-ID: <829197380909101327s6d14332ft6435f817f2f6862@mail.gmail.com>
Subject: Re: RFCv2: Media controller proposal
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 10, 2009 at 4:20 PM, Mauro Carvalho
Chehab<mchehab@infradead.org> wrote:
> In fact, this can already be done by using the sysfs interface. the current
> version of v4l2-sysfs-path.c already enumerates the associated nodes to
> a /dev/video device, by just navigating at the already existing device
> description nodes at sysfs. I hadn't tried yet, but I bet that a similar kind
> of topology can be obtained from a dvb device (probably, we need to do some
> adjustments).

For the audio case, I did some digging into this a bit and It's worth
noting that this behavior varies by driver (at least on USB).  In some
cases, the parent points to the USB device, in other cases it points
to the USB interface.  My original thought was to pick one or the
other and make the various drivers consistent, but even that is a
challenge since in some cases the audio device was provided by
snd-usb-audio (which has no knowledge of the v4l subsystem).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
