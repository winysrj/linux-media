Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34577 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbbCRT4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 15:56:37 -0400
Received: by wibg7 with SMTP id g7so69542807wib.1
        for <linux-media@vger.kernel.org>; Wed, 18 Mar 2015 12:56:36 -0700 (PDT)
MIME-Version: 1.0
Reply-To: whittenburg@gmail.com
Date: Wed, 18 Mar 2015 14:56:36 -0500
Message-ID: <CABcw_Okm1ZVob1s_JxZaRk_oFP2efh38qEyDeok4K2066dcMvQ@mail.gmail.com>
Subject: OMAP3 ISP previewer Y10 to UYVY conversion
From: Chris Whittenburg <whittenburg@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We're working on a DM3730 platform running a 3.5.7 kernel, using the
pipeline below to take a 12-bit monochrome sensor (Aptina AR0130) and
convert it to UYVY format for use with the TI codecs.

In general, this works, but the images end up looking washed out.
Running them thru a "normalize" function makes them look good again.
Looking at the levels histogram in gimp, I seem to be missing the high
end and low end values.

I've captured the 12-bit data from the CCDC, downconverted it to Y8,
and verified it looks ok, and is not washed out, so I'm suspecting the
isp previewer is doing something wrong in the simple Y10 to UYVY
conversion.

Does someone with experience on this topic have a recommendation on
what component might be causing the problem, or the best way to go
about isolating the issue?

media-ctl -r
media-ctl -v -l '"ar0130 3-0010":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
CCDC":2->"OMAP3 ISP preview":0[1], "OMAP3 ISP preview":1->"OMAP3 ISP
resizer":0[1], "OMAP3 ISP resizer":1->"OMAP3 ISP resizer output":0[1]'
media-ctl -v -V '"ar0130 3-0010":0['Y12' '640'x'480'], "OMAP3 ISP
CCDC":2['Y10' '640'x'480'], "OMAP3 ISP preview":1[UYVY '640'x'480'],
"OMAP3 ISP resizer":1[UYVY '640'x'480']'

Thanks,
Chris
