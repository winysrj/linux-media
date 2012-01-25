Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab2AYM1s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 07:27:48 -0500
Message-ID: <4F1FF53F.6090603@redhat.com>
Date: Wed, 25 Jan 2012 10:27:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-930C
References: <4F1FF046.9050401@southpole.se>
In-Reply-To: <4F1FF046.9050401@southpole.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-01-2012 10:06, Benjamin Larsson escreveu:
> I tried a daily snapshot (2011-01-24) with this stick. And I'm getting these kind of errors in the log:
> 
> [43665.769571] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
> [43665.769857] drxk: 02 00 00 00 10 00 07 00 03 02                    ..........
> [43686.121576] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
> [43686.121861] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........
> [43706.465578] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
> [43706.465861] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........
> [43709.669571] drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
> [43709.669850] drxk: 02 00 00 00 10 00 05 00 03 02                    ..........

This is just due to firmware differences. Yeah, a cleanup on these is needed.

> 
> First I tried the driver with the firmware that is downloaded with the get_firmware script. 
> The adapter and frontends was registered properly but I did not get any TS from the stick. 
> I then renamed the firmware file and the driver complained about missing firmware but stick 
> started working anyway. So the drxk in my version of the card has a rom with microcode in it.

This is not uncommon. The uploaded firmware should be, in thesis, better than
the one already on it.

Are you testing it with DVB-C or DVB-T (or with both)? Here, DVB-C works properly
on HVR-930C.

> So things that would be nice to have is:
> 
> A log output that the drxk actually loaded the firmware file. Right now there is only log output when there is no firmware file detected.
> Maybe add a log that the card might work without the drxk firmware.
> Silence the SCU_RESULT_INVPAR debug output by default or find out what is causing the error messages.

Feel free to submit a patch for drxk_hard.c.

Regards,
Mauro

> 
> MvH
> Benjamin Larsson
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

