Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp27.orange.fr ([80.12.242.95]:6906 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbZIJIi4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 04:38:56 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2713.orange.fr (SMTP Server) with ESMTP id C56A61C000AE
	for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 10:38:58 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2713.orange.fr (SMTP Server) with ESMTP id B97FF1C000B3
	for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 10:38:58 +0200 (CEST)
Received: from [192.168.1.11] (ANantes-551-1-42-204.w86-214.abo.wanadoo.fr [86.214.145.204])
	by mwinf2713.orange.fr (SMTP Server) with ESMTP id EA7AD1C000AE
	for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 10:38:57 +0200 (CEST)
Message-ID: <4AA8BB20.4040701@gmail.com>
Date: Thu, 10 Sep 2009 10:38:56 +0200
From: Morvan Le Meut <mlemeut@gmail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: (Saa7134) Re: ADS-Tech Instant TV PCI, no remote support
References: <4AA53C05.10203@gmail.com> <4AA61508.9040506@gmail.com> <op.uzxmzlj86dn9rq@crni> <4AA62C38.3050208@gmail.com> <4AA63434.1010709@gmail.com> <4AA683BD.6070601@gmail.com> <4AA695EE.70800@gmail.com> <4AA767F2.50702@gmail.com> <op.uzzfgyvj3xmt7q@crni> <4AA77240.2040504@gmail.com> <4AA77683.7010201@gmail.com> <4AA7C266.3000509@gmail.com> <op.uzzz96se6dn9rq@crni> <4AA7E166.7030906@gmail.com> <4AA81785.5000806@gmail.com>
In-Reply-To: <4AA81785.5000806@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Still rambling about it :)
i was just comparing the  instant TV dvb-t pci keymap with what i got 
for the instant tv pci :
    dvb-t
    { 0x4d, KEY_0 },
    { 0x57, KEY_1 },
    { 0x4f, KEY_2 },
    { 0x53, KEY_3 },
    { 0x56, KEY_4 },
    { 0x4e, KEY_5 },
    { 0x5e, KEY_6 },
    { 0x54, KEY_7 },
    { 0x4c, KEY_8 },
    { 0x5c, KEY_9 },
    pci
    { 0xd, KEY_0 },
    { 0x17, KEY_1 },
    { 0xf, KEY_2 },
    { 0x13, KEY_3 },
    { 0x16, KEY_4 },
    { 0xe, KEY_5 },
    { 0x1e, KEY_6 },
    { 0x14, KEY_7 },
    { 0xc, KEY_8 },
    { 0x1c, KEY_9 },
if manufacturers are half as lazy as i am, and since the remote is the 
same ( or at least looks the same ), it looks like i am indeed missing 
part of the gpio. ( no mark, got the output with ir_debug=1 )
now for the rest of the keys :
dvb-t
{ 0x5b, KEY_POWER },
    { 0x5f, KEY_MUTE },
    { 0x55, KEY_GOTO },
    { 0x5d, KEY_SEARCH },
    { 0x17, KEY_EPG },        /* Guide */
    { 0x1f, KEY_MENU },
    { 0x0f, KEY_UP },
    { 0x46, KEY_DOWN },
    { 0x16, KEY_LEFT },
    { 0x1e, KEY_RIGHT },
    { 0x0e, KEY_SELECT },        /* Enter */
    { 0x5a, KEY_INFO },
    { 0x52, KEY_EXIT },
    { 0x59, KEY_PREVIOUS },
    { 0x51, KEY_NEXT },
    { 0x58, KEY_REWIND },
    { 0x50, KEY_FORWARD },
    { 0x44, KEY_PLAYPAUSE },
    { 0x07, KEY_STOP },
    { 0x1b, KEY_RECORD },
    { 0x13, KEY_TUNER },        /* Live */
    { 0x0a, KEY_A },
    { 0x12, KEY_B },
    { 0x03, KEY_PROG1 },        /* 1 */
    { 0x01, KEY_PROG2 },        /* 2 */
    { 0x00, KEY_PROG3 },        /* 3 */
    { 0x06, KEY_DVD },
    { 0x48, KEY_AUX },        /* Photo */
    { 0x40, KEY_VIDEO },
    { 0x19, KEY_AUDIO },        /* Music */
    { 0x0b, KEY_CHANNELUP },
    { 0x08, KEY_CHANNELDOWN },
    { 0x15, KEY_VOLUMEUP },
    { 0x1c, KEY_VOLUMEDOWN },
pci
    { 0x1b, KEY_POWER },
    { 0x1f, KEY_MUTE },
    { 0x15, KEY_GOTO },
    { 0x1d, KEY_SEARCH },
    { 0x17, KEY_EPG },        /* Guide */
    { 0x1f, KEY_MENU },
    { 0x0f, KEY_UP },
    { 0x6, KEY_DOWN },
    { 0x16, KEY_LEFT },
    { 0x1e, KEY_RIGHT },
    { 0x0e, KEY_SELECT },        /* Enter */
    { 0x1a, KEY_INFO },
    { 0x12, KEY_EXIT },
    { 0x19, KEY_PREVIOUS },
    { 0x11, KEY_NEXT },
    { 0x18, KEY_REWIND },
    { 0x10, KEY_FORWARD },
    { 0x4, KEY_PLAYPAUSE },
    { 0x07, KEY_STOP },
    { 0x1b, KEY_RECORD },
    { 0x13, KEY_TUNER },        /* Live */
    { 0x0a, KEY_A },
    { 0x12, KEY_B },
    { 0x03, KEY_PROG1 },        /* 1 */
    { 0x01, KEY_PROG2 },        /* 2 */
    { 0x00, KEY_PROG3 },        /* 3 */
    { 0x06, KEY_DVD },
    { 0x8, KEY_AUX },        /* Photo */
    { 0x0, KEY_VIDEO },
    { 0x19, KEY_AUDIO },        /* Music */
    { 0x0b, KEY_CHANNELUP },
    { 0x08, KEY_CHANNELDOWN },
    { 0x15, KEY_VOLUMEUP },
    { 0x1c, KEY_VOLUMEDOWN },

as you can see, for most of the keycodes, i am missing 0x40, which mean 
i am missing one bit.

And i don't even know where i should start looking to solve that problem.

thanks for any help/solution.

Morvan Le Meut a écrit :
> I don't know if i mentioned it before but something i find strange is 
> " saa7134 IR (ADS Tech Instant TV: unknown key: key=0x00 raw=0x00 
> down=1" as soon as the module is loaded.



