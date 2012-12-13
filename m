Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49692 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab2LMRxf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Dec 2012 12:53:35 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so1255078bkw.19
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2012 09:53:34 -0800 (PST)
Message-ID: <50CA162A.8080108@googlemail.com>
Date: Thu, 13 Dec 2012 18:53:46 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: remy.blank@pobox.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Bug 14126 (em28xx, Terratec Cinergy 200/250 USB)
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

could you please take a look at kernel bug 14126
(https://bugzilla.kernel.org/show_bug.cgi?id=14126) ?
The bug reporter posted a patch 3 years ago (!), which seems to be valid.

As mentioned in an earlier post, I've got a Cinergy 200 USB recently and
tried to figure out the difference between both devices:

Common:
- handbook / product description from Terratec seems to be completely
identical (except that the number 200 is replaced with 250)
- both devices are looking identical
- Empia bridge
- saa7113
- tda9887
- remote control with external i2c IR IC
- physical connectors*: antenna, line-in and line-out (stereo jack), SVIDEO

(*: some pictures show an additional connector on the side, but at least
Remys' and my device don't have it).

Cinergy 200 USB (my device):
- generic USB ID: eb1a:2800
- em2800
- no eeprom
- no AC97 IC
- LG TALN (tuner 66)
- audio over USB doesn't work
- audio line-in is shortcut with line-out

Cinergy 250 USB (Remy's device):
- unique USB ID: 0ccd:0036
- em2820
- eeprom
- Empia 202 AC97
- LG TAPC (tuner 37)
- audio over USB works (from both, tuner and line-in)



In the em28xx driver, we currently have the following board definitions:

    [EM2800_BOARD_TERRATEC_CINERGY_200] = {
        .name         = "Terratec Cinergy 200 USB",
        .is_em2800    = 1,
        .has_ir_i2c   = 1,
        .tuner_type   = TUNER_LG_TALN,
        .tda9887_conf = TDA9887_PRESENT,
        .decoder      = EM28XX_SAA711X,
        .input        = { {
            .type     = EM28XX_VMUX_TELEVISION,
            .vmux     = SAA7115_COMPOSITE2,
            .amux     = EM28XX_AMUX_VIDEO,
        }, {
            .type     = EM28XX_VMUX_COMPOSITE1,
            .vmux     = SAA7115_COMPOSITE0,
            .amux     = EM28XX_AMUX_LINE_IN,
        }, {
            .type     = EM28XX_VMUX_SVIDEO,
            .vmux     = SAA7115_SVIDEO3,
            .amux     = EM28XX_AMUX_LINE_IN,
        } },
    },


    [EM2820_BOARD_TERRATEC_CINERGY_250] = {
        .name         = "Terratec Cinergy 250 USB",
        .tuner_type   = TUNER_LG_PAL_NEW_TAPC,
        .has_ir_i2c   = 1,
        .tda9887_conf = TDA9887_PRESENT,
        .decoder      = EM28XX_SAA711X,
        .input        = { {
            .type     = EM28XX_VMUX_TELEVISION,
            .vmux     = SAA7115_COMPOSITE2,
            .amux     = EM28XX_AMUX_LINE_IN,
        }, {
            .type     = EM28XX_VMUX_COMPOSITE1,
            .vmux     = SAA7115_COMPOSITE0,
            .amux     = EM28XX_AMUX_LINE_IN,
        }, {
            .type     = EM28XX_VMUX_SVIDEO,
            .vmux     = SAA7115_SVIDEO3,
            .amux     = EM28XX_AMUX_LINE_IN,
        } },
    },


Remy wants to change .amux for TV input from EM28XX_AMUX_LINE_IN to
EM28XX_AMUX_VIDEO, which makes sense for the device he has.
For my Cinergy 200, neither EM28XX_AMUX_VIDEO nor EM28XX_AMUX_LINE_IN
works, because it misses an AC97 IC.
Another question is, if we should remove the COMPOSITE input. At least
Remys' and my device use a COMPOSITE to SVIDEO adapter cable.

The big question is now, if we can be sure that there are no other
device variants, for which the current board definitions are right.
Especially because of the pictures with the additional connector on the
side...
But these pictures are all product pictures from Terratec, no one knows
if they have ever been sold...

So I'll leave it up to you to decide, which changes to make. :D
But it's definitely time to close this old bug report. ;)

Regards,
Frank

