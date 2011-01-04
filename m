Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p04CeVLZ024314
	for <video4linux-list@redhat.com>; Tue, 4 Jan 2011 07:40:32 -0500
Received: from mail-fx0-f46.google.com (mail-fx0-f46.google.com
	[209.85.161.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p04CeIO3032086
	for <video4linux-list@redhat.com>; Tue, 4 Jan 2011 07:40:19 -0500
Received: by fxm20 with SMTP id 20so13209613fxm.33
	for <video4linux-list@redhat.com>; Tue, 04 Jan 2011 04:40:18 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 4 Jan 2011 09:40:18 -0300
Message-ID: <AANLkTi=uTj5TNuMK4_V5o0PJ8hhgJ5sPJe_qZa3HYzYe@mail.gmail.com>
Subject: Pinnacle PCTV USB2 working with PAL-Nc
From: "Gonzalo A. de la Vega" <gadelavega@gmail.com>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: Mauro Carvalho Chehab <mchehab@gaivota>
List-ID: <video4linux-list@redhat.com>

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
