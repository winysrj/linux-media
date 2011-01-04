Return-path: <mchehab@gaivota>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35657 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1ADN3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jan 2011 08:29:14 -0500
Received: by ewy5 with SMTP id 5so6443694ewy.19
        for <linux-media@vger.kernel.org>; Tue, 04 Jan 2011 05:29:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=uTj5TNuMK4_V5o0PJ8hhgJ5sPJe_qZa3HYzYe@mail.gmail.com>
References: <AANLkTi=uTj5TNuMK4_V5o0PJ8hhgJ5sPJe_qZa3HYzYe@mail.gmail.com>
Date: Tue, 4 Jan 2011 10:29:10 -0300
Message-ID: <AANLkTik1venaY6hUZymzrA73F=NLiG1OZhqDnuNTTHLk@mail.gmail.com>
Subject: Fwd: Pinnacle PCTV USB2 working with PAL-Nc
From: Adrian Pardini <pardo.bsso@gmail.com>
To: linux-media@vger.kernel.org
Cc: "Gonzalo A. de la Vega" <gadelavega@gmail.com>
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Gonzalo the other list is deprecated, I'm forwarding your mail.

---------- Forwarded message ----------
From: "Gonzalo A. de la Vega" <gadelavega@gmail.com>
Date: Tue, 4 Jan 2011 09:40:18 -0300
Subject: Pinnacle PCTV USB2 working with PAL-Nc
To: video4linux-list@redhat.com

Hi all,
I live in Argentina and I have a Pinnacle PCTV USB2. We use PAL-Nc (no
other country does AFAIK) and I couldn't get the device to show a
colored image. Actually there was no image when PAL-Nc was selected
and BW only with PAL. It turns that this device uses (just to remind
you) a TDA9887 tuner (IF-PLL demodulator), an SAA7113 input processor
and a EM2820 capture device.

The problem was that the TDA9887 is being set incorrectly. I'm not
quiet sure what the justification is, but I started from the point
that I should at least see the same B&W image I saw with PAL, so I
just went with trial and error (two trials, one error).

The whole diff would be:
------------cut here----------------------------------
178c178
< 			   cVideoIF_45_75 ),
---
> 			   cVideoIF_38_90 ),
------------cut here----------------------------------

I only have the Pinnalce PCTV, so probably someone else (from
Argentina) could try with another device using the TDA9887 before
submitting a patch.

Cheers,

Gonzalo

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list



-- 
Adrian.
http://ovejafm.com
http://elesquinazotango.com.ar
