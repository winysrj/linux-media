Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:51903 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3ACSAt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 13:00:49 -0500
Received: by mail-la0-f53.google.com with SMTP id fn20so8276643lab.40
        for <linux-media@vger.kernel.org>; Thu, 03 Jan 2013 10:00:48 -0800 (PST)
Message-ID: <50E5C768.6060707@googlemail.com>
Date: Thu, 03 Jan 2013 19:01:12 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: remy.blank@pobox.com
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Sommer <saschasommer@freenet.de>
Subject: Re: Bug 14126 (em28xx, Terratec Cinergy 200/250 USB)
References: <50CA162A.8080108@googlemail.com> <20121213184300.13c92fb0@redhat.com>
In-Reply-To: <20121213184300.13c92fb0@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.12.2012 21:43, schrieb Mauro Carvalho Chehab:
> Hi Frank,
>
> Em Thu, 13 Dec 2012 18:53:46 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Hi Mauro,
>>
>> could you please take a look at kernel bug 14126
>> (https://bugzilla.kernel.org/show_bug.cgi?id=14126) ?
>> The bug reporter posted a patch 3 years ago (!), which seems to be valid.
>>
>> As mentioned in an earlier post, I've got a Cinergy 200 USB recently and
>> tried to figure out the difference between both devices:
>>
>> Common:
>> - handbook / product description from Terratec seems to be completely
>> identical (except that the number 200 is replaced with 250)
>> - both devices are looking identical
>> - Empia bridge
>> - saa7113
>> - tda9887
>> - remote control with external i2c IR IC
>> - physical connectors*: antenna, line-in and line-out (stereo jack), SVIDEO
>>
>> (*: some pictures show an additional connector on the side, but at least
>> Remys' and my device don't have it).
> Likely, some device variant. The driver should keep support for it, to avoid
> breaking support for those variants.
>> Cinergy 200 USB (my device):
>> - generic USB ID: eb1a:2800
>> - em2800
>> - no eeprom
>> - no AC97 IC
>> - LG TALN (tuner 66)
>> - audio over USB doesn't work
>> - audio line-in is shortcut with line-out
>>
>> Cinergy 250 USB (Remy's device):
>> - unique USB ID: 0ccd:0036
>> - em2820
>> - eeprom
>> - Empia 202 AC97
>> - LG TAPC (tuner 37)
>> - audio over USB works (from both, tuner and line-in)
>>
>>
>>
>> In the em28xx driver, we currently have the following board definitions:
>>
>>     [EM2800_BOARD_TERRATEC_CINERGY_200] = {
>>         .name         = "Terratec Cinergy 200 USB",
>>         .is_em2800    = 1,
>>         .has_ir_i2c   = 1,
>>         .tuner_type   = TUNER_LG_TALN,
>>         .tda9887_conf = TDA9887_PRESENT,
>>         .decoder      = EM28XX_SAA711X,
>>         .input        = { {
>>             .type     = EM28XX_VMUX_TELEVISION,
>>             .vmux     = SAA7115_COMPOSITE2,
>>             .amux     = EM28XX_AMUX_VIDEO,
>>         }, {
>>             .type     = EM28XX_VMUX_COMPOSITE1,
>>             .vmux     = SAA7115_COMPOSITE0,
>>             .amux     = EM28XX_AMUX_LINE_IN,
>>         }, {
>>             .type     = EM28XX_VMUX_SVIDEO,
>>             .vmux     = SAA7115_SVIDEO3,
>>             .amux     = EM28XX_AMUX_LINE_IN,
>>         } },
>>     },
>>
>>
>>     [EM2820_BOARD_TERRATEC_CINERGY_250] = {
>>         .name         = "Terratec Cinergy 250 USB",
>>         .tuner_type   = TUNER_LG_PAL_NEW_TAPC,
>>         .has_ir_i2c   = 1,
>>         .tda9887_conf = TDA9887_PRESENT,
>>         .decoder      = EM28XX_SAA711X,
>>         .input        = { {
>>             .type     = EM28XX_VMUX_TELEVISION,
>>             .vmux     = SAA7115_COMPOSITE2,
>>             .amux     = EM28XX_AMUX_LINE_IN,
>>         }, {
>>             .type     = EM28XX_VMUX_COMPOSITE1,
>>             .vmux     = SAA7115_COMPOSITE0,
>>             .amux     = EM28XX_AMUX_LINE_IN,
>>         }, {
>>             .type     = EM28XX_VMUX_SVIDEO,
>>             .vmux     = SAA7115_SVIDEO3,
>>             .amux     = EM28XX_AMUX_LINE_IN,
>>         } },
>>     },
>>
>>
>> Remy wants to change .amux for TV input from EM28XX_AMUX_LINE_IN to
>> EM28XX_AMUX_VIDEO, which makes sense for the device he has.
>> For my Cinergy 200, neither EM28XX_AMUX_VIDEO nor EM28XX_AMUX_LINE_IN
>> works, because it misses an AC97 IC.
> The only developer I know with em2800 hardware is Sascha Sommer. He may
> help if you're noticing any issues with Cinergy 200. He is the one who
> started writing this driver.
>
>> Another question is, if we should remove the COMPOSITE input. At least
>> Remys' and my device use a COMPOSITE to SVIDEO adapter cable.
> If there are devices with it, the answer is no.
>
>> The big question is now, if we can be sure that there are no other
>> device variants, for which the current board definitions are right.
> Very doubtful. Those are very old hardware. I bet that even Terratec
> doesn't have any samples of it anymore.
>
>> Especially because of the pictures with the additional connector on the
>> side...
>> But these pictures are all product pictures from Terratec, no one knows
>> if they have ever been sold...
>>
>> So I'll leave it up to you to decide, which changes to make. :D
>> But it's definitely time to close this old bug report. ;)
> With regards to Cinergy 250, the better is to see if anyone at the ML
> has a device using EM28XX_AMUX_LINE_IN for TV. If not, we can apply
> the patch.
>
> In that case, Remy should submit it, with his SOB, to the mailing list.
>
> Regards,
> Mauro

Remy, your patch needs to be rebased against the linux-media tree.
Is it ok for you when I create a new patch including the composite input
fix and submit it ?
Of course I will give you the proper credits.

Regards,
Frank



