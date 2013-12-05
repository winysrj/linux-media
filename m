Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1516 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3LELzN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Dec 2013 06:55:13 -0500
Message-ID: <52A0693C.7060704@xs4all.nl>
Date: Thu, 05 Dec 2013 12:53:32 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Andrea Venturi <a.venturi@avalpa.com>
CC: linux-media@vger.kernel.org
Subject: Re: advice on Easycap dongles and VBI interface..
References: <52A058EF.9000701@avalpa.com>
In-Reply-To: <52A058EF.9000701@avalpa.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrea,

On 12/05/13 11:43, Andrea Venturi wrote:
> i'm working on a project for legacy support of a teletext server with
> composite output interface.
> 
> i supposed to "ingest" teletext using the /dev/vbi support on linux
> so i've got an Easycap dongle
> 
> Bus 001 Device 008: ID 05e1:0408 Syntek Semiconductor Co., Ltd
> STK1160 Video Capture Device
> 
> AFAIK (i didn't open) it's using a video decoder SC7113 supposed to
> be a clone of SAA7113.
> 
> this device is supposed to work on an Ubuntu 12.04 with old kernel
> 3.2 so i had to blacklist the stock "RE" kernel module easycap and
> install the "retrofit" from here:
> 
> https://github.com/ezequielgarcia/stk1160-standalone
> 
> i see the saa7115 is loaded and i can also see audio and video
> through mplayer..
> 
> $ lsmod Module                  Size  Used by saa7115
> 18447  1 stk1160                27732  0 videobuf2_core         28148
> 1 stk1160 snd_ac97_codec        110213  1 stk1160 ....
> 
> but in the dev fs there's no sign of /dev/vbi interface..
> 
> so my questions are:
> 
> - are these SAA7113 clones really copycat with all the features
> supported?

I believe so, yes.

> - has the SAA711x driver ever been used for /dev/vbi feature? i used
> to work with Bt878 cards for that feature.

It's been tested for saa7114 and saa7115, but I'm not sure if it was ever
tested for saa7113. The chip can do it, and the saa7115 driver should as well,
but the combination of saa7113 + VBI is very rare.

> - is the stock 3.x mainline kernel of the stk1160 really
> improved/different/VBI enabled?

No, it doesn't have VBI support.

> - is there a way to extract VBI lines on /dev/video0?

No.

> - is there an easy way to enable or at least test (directly on the
> USB interface) the VBI interface?

No.

> - finally which approach do you suggest for supporting this ancient
> feature, if feasibiliy tests are ok: - a libusb quick hack? - an
> implementation of the bindings between user level /dev/vbi and
> underlying SAA711x routines?

The problem is that I don't believe we have any stk1160 documentation.
And I wonder if the device can support VBI at all.

You are better off choosing devices that already have VBI support: the
em28xx supports it, so do bt8xx, cx18 and ivtv.

Regards,

	Hans
