Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33678 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbbCYOM5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 10:12:57 -0400
Received: by wixw10 with SMTP id w10so75526751wix.0
        for <linux-media@vger.kernel.org>; Wed, 25 Mar 2015 07:12:56 -0700 (PDT)
MIME-Version: 1.0
Reply-To: whittenburg@gmail.com
In-Reply-To: <20150324235148.GC18321@valkosipuli.retiisi.org.uk>
References: <CABcw_Okm1ZVob1s_JxZaRk_oFP2efh38qEyDeok4K2066dcMvQ@mail.gmail.com>
	<20150324235148.GC18321@valkosipuli.retiisi.org.uk>
Date: Wed, 25 Mar 2015 09:12:56 -0500
Message-ID: <CABcw_O=Gv3xvnRU9LvVUaCKEEkLFFrhpqLZ9FZ89XRAp0_RR5Q@mail.gmail.com>
Subject: Re: OMAP3 ISP previewer Y10 to UYVY conversion
From: Chris Whittenburg <whittenburg@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the reply.

On Tue, Mar 24, 2015 at 6:51 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Do you know if the sensor has black level correction enabled? It appears to
> have one, but I'm not completely sure what it does there. I'd check that it
> is indeed enabled.

The ar0130cs does have black level correction enabled by default.

My thought is that since the 12-bit data from the CCDC looked ok, that
it was something outside the sensor itself.

>> I've captured the 12-bit data from the CCDC, downconverted it to Y8,
>> and verified it looks ok, and is not washed out, so I'm suspecting the
>> isp previewer is doing something wrong in the simple Y10 to UYVY
>> conversion.
>
> Not necessarily wrong, the black level correction might be enabled by
> default, with the default configuration which works for most sensors (64 for
> 10-bit data, 16 for 8-bit etc.).

Ok, I will check this.  You are referring to the "Camera ISP VPBE
Preview Black Adjustment" which is controlled by PRV_BLKADJOFF
register?

I also found that there are contrast and brightness settings in the
previewer which can be adjusted.  I'm not changing them from defaults,
so I thought the "Y" values would just get truncated to 8 bits and
mapped into the UYVY without being significantly altered.

Would your thought be the black level is more likely the issue rather
than brightness/contrast?

Is there anywhere else I should look?

Thanks,
Chris
