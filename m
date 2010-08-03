Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49892 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab0HCK0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 06:26:11 -0400
Received: by fxm14 with SMTP id 14so1923918fxm.19
        for <linux-media@vger.kernel.org>; Tue, 03 Aug 2010 03:26:09 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 3 Aug 2010 12:26:09 +0200
Message-ID: <AANLkTim3ptCeHqt0aiFpmKYg7hOpqjHyDxJyjjZRgTCw@mail.gmail.com>
Subject: TerraTec Cinergy T USB XXS Remote Control
From: Jan Wagemakers <jan.wagemakers@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have a TerraTec Cinergy T USB XXS. To get this device working I have
followed the instructions at
<http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_T_USB_XXS>.

This works fine, except for the remote control.

I have found that I can get the remote control working by changing the Key
Codes in "/usr/src/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c".

If I change

        /* Key codes for the Terratec Cinergy DT XS Diversity, similar
to cinergyT2.c */
        { 0xeb01, KEY_POWER },
        { 0xeb02, KEY_1 },
        { 0xeb03, KEY_2 },
        { 0xeb04, KEY_3 },
        { 0xeb05, KEY_4 },
        { 0xeb06, KEY_5 },
        { 0xeb07, KEY_6 },
        { 0xeb08, KEY_7 },
        { 0xeb09, KEY_8 },
        { 0xeb0a, KEY_9 },
        { 0xeb0b, KEY_VIDEO },
        { 0xeb0c, KEY_0 },
        { 0xeb0d, KEY_REFRESH },
        { 0xeb0f, KEY_EPG },
        { 0xeb10, KEY_UP },
        { 0xeb11, KEY_LEFT },
        { 0xeb12, KEY_OK },
        { 0xeb13, KEY_RIGHT },
        { 0xeb14, KEY_DOWN },
        { 0xeb16, KEY_INFO },
        { 0xeb17, KEY_RED },
        { 0xeb18, KEY_GREEN },
        { 0xeb19, KEY_YELLOW },
        { 0xeb1a, KEY_BLUE },
        { 0xeb1b, KEY_CHANNELUP },
        { 0xeb1c, KEY_VOLUMEUP },
        { 0xeb1d, KEY_MUTE },
        { 0xeb1e, KEY_VOLUMEDOWN },
        { 0xeb1f, KEY_CHANNELDOWN },
        { 0xeb40, KEY_PAUSE },
        { 0xeb41, KEY_HOME },
        { 0xeb42, KEY_MENU }, /* DVD Menu */
        { 0xeb43, KEY_SUBTITLE },
        { 0xeb44, KEY_TEXT }, /* Teletext */
        { 0xeb45, KEY_DELETE },
        { 0xeb46, KEY_TV },
        { 0xeb47, KEY_DVD },
        { 0xeb48, KEY_STOP },
        { 0xeb49, KEY_VIDEO },
        { 0xeb4a, KEY_AUDIO }, /* Music */
        { 0xeb4b, KEY_SCREEN }, /* Pic */
        { 0xeb4c, KEY_PLAY },
        { 0xeb4d, KEY_BACK },
        { 0xeb4e, KEY_REWIND },
        { 0xeb4f, KEY_FASTFORWARD },
        { 0xeb54, KEY_PREVIOUS },
        { 0xeb58, KEY_RECORD },
        { 0xeb5c, KEY_NEXT },

to (eb -> 14)

       /* Key codes for the Terratec Cinergy DT XS Diversity, similar
to cinergyT2.c */
        { 0x1401, KEY_POWER },
        { 0x1402, KEY_1 },
        { 0x1403, KEY_2 },
        { 0x1404, KEY_3 },
        { 0x1405, KEY_4 },
        { 0x1406, KEY_5 },
        { 0x1407, KEY_6 },
        { 0x1408, KEY_7 },
        { 0x1409, KEY_8 },
        { 0x140a, KEY_9 },
        { 0x140b, KEY_VIDEO },
        { 0x140c, KEY_0 },
        { 0x140d, KEY_REFRESH },
        { 0x140f, KEY_EPG },
        { 0x1410, KEY_UP },
        { 0x1411, KEY_LEFT },
        { 0x1412, KEY_OK },
        { 0x1413, KEY_RIGHT },
        { 0x1414, KEY_DOWN },
        { 0x1416, KEY_INFO },
        { 0x1417, KEY_RED },
        { 0x1418, KEY_GREEN },
        { 0x1419, KEY_YELLOW },
        { 0x141a, KEY_BLUE },
        { 0x141b, KEY_CHANNELUP },
        { 0x141c, KEY_VOLUMEUP },
        { 0x141d, KEY_MUTE },
        { 0x141e, KEY_VOLUMEDOWN },
        { 0x141f, KEY_CHANNELDOWN },
        { 0x1440, KEY_PAUSE },
        { 0x1441, KEY_HOME },
        { 0x1442, KEY_MENU }, /* DVD Menu */
        { 0x1443, KEY_SUBTITLE },
        { 0x1444, KEY_TEXT }, /* Teletext */
        { 0x1445, KEY_DELETE },
        { 0x1446, KEY_TV },
        { 0x1447, KEY_DVD },
        { 0x1448, KEY_STOP },
        { 0x1449, KEY_VIDEO },
        { 0x144a, KEY_AUDIO }, /* Music */
        { 0x144b, KEY_SCREEN }, /* Pic */
        { 0x144c, KEY_PLAY },
        { 0x144d, KEY_BACK },
        { 0x144e, KEY_REWIND },
        { 0x144f, KEY_FASTFORWARD },
        { 0x1454, KEY_PREVIOUS },
        { 0x1458, KEY_RECORD },
        { 0x145c, KEY_NEXT },

everything works fine.

More info at
<http://www.janw.dommel.be/nanoblogger/archives/2010/06/index.html#e2010-06-06T08_40_19.txt>

-- 
Met vriendelijke groetjes         - Jan Wagemakers -

... Fidonet : 2:292/100.19
