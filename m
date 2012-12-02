Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:32804 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2LBLx0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Dec 2012 06:53:26 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so789679eaa.19
        for <linux-media@vger.kernel.org>; Sun, 02 Dec 2012 03:53:25 -0800 (PST)
Message-ID: <50BB413C.9010606@googlemail.com>
Date: Sun, 02 Dec 2012 12:53:32 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: mkrufky@linuxtv.org, linux-media@vger.kernel.org
Subject: LGDT3305 configuration questions
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

I'm currently working on adding support for the "MSI Digivox ATSC"
(EM2874B + TDA18271HDC2 + LGDT3305) to the em28xx driver and I'm trying
to find the right setup for the LGDT3305.
Maybe you can answer some questions about the LGDT3305 configuration:

1) When should deny_i2c_rptr in struct lgdt3305_config be set ?
I can see what the code does, but I'm unsure which value to use.
What's the i2c repeater / i2c gate ctrl and how does it work ?

2) User defined IF frequencies (fields vsb_if_khz and qam_if_khz in
struct lgdt3305_config):
What happens if no user defined values are selected ? The corresponding
registers seem to be 0x00000000 in this case (for the LGDT3305).
Which IF is used in this case ?
The USB log of the stick shows that the registers are set to 4a 3d 70 a3
(for QAM; don't have a log for VSB).
According to the code in lgdt3305_set_if() this corresponds to a value
of .qam_if_khz = 4000.
In the em28xx driver we have another device with the LGDT3304 which sets
this value to 4000, too.
OTOH, these fields claim to hold the value in kHz, so this would be 4MHz
only. But AFAIK intermediate frequencies are usually about 10 times
higher !? ATSC seems to use 44MHz.

Thanks for your help ! :)

Regards,
Frank
