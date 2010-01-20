Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:4876 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab0ATVvl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 16:51:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Theunis Potgieter <theunis.potgieter@gmail.com>
Subject: Re: SoC Realtek RTD 12xx devices
Date: Wed, 20 Jan 2010 22:52:58 +0100
Cc: linux-media@vger.kernel.org
References: <23582ca1001140301v282b61f1nf2f10b37fe8337a7@mail.gmail.com>
In-Reply-To: <23582ca1001140301v282b61f1nf2f10b37fe8337a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001202252.58858.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 14 January 2010 12:01:23 Theunis Potgieter wrote:
> Hi, is there anyone that has started to work on Realtek RTD 1261
> (http://rtd1261.wikidot.com/internals), 1283 etc type systems?
> 
> Here is the kernel of RTD 1283
> http://gator884.hostgator.com/~xtreamer/Xtreamer_GPL/xtr_kernel.tar.bz2
> 
> I would like to know if what they gave is enough to use
> encoder/decoder/osd capabilities. Or would this be the wrong mailing
> list to ask, if so please direct me to where I should ask.

I looked at this for a bit and it seems that it has drivers for a framebuffer
and for the dvb tuner. I didn't see anything related to JPEG and MPEG decoding
or encoding though, or analog TV input or output (i.e. video4linux drivers).

Regards,

	Hans

> 
> Thanks,
> Theunis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
