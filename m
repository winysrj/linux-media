Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:61386 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2LIQXP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2012 11:23:15 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so800945eaa.19
        for <linux-media@vger.kernel.org>; Sun, 09 Dec 2012 08:23:13 -0800 (PST)
Message-ID: <50C4BAFB.60304@googlemail.com>
Date: Sun, 09 Dec 2012 17:23:23 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Matthew Gyurgyik <matthew@pyther.net>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
References: <50B5779A.9090807@pyther.net> <50B80FBB.5030208@pyther.net> <50BB3F2C.5080107@googlemail.com> <50BB6451.7080601@iki.fi> <50BB8D72.8050803@googlemail.com> <50BCEC60.4040206@googlemail.com> <50BD5CC3.1030100@pyther.net> <CAGoCfiyNrHS9TpmOk8FKhzzViNCxazKqAOmG0S+DMRr3AQ8Gbg@mail.gmail.com> <50BD6310.8000808@pyther.net> <CAGoCfiwr88F3TW9Q_Pk7B_jTf=N9=Zn6rcERSJ4tV75sKyyRMw@mail.gmail.com> <50BE65F0.8020303@googlemail.com> <50BEC253.4080006@pyther.net> <50BF3F9A.3020803@iki.fi> <50BFBE39.90901@pyther.net> <50BFC445.6020305@iki.fi> <50BFCBBB.5090407@pyther.net> <50BFECEA.9060808@iki.fi> <50BFFFF6.1000204@pyther.net> <50C11301.10205@googlemail.com> <50C12302.80603@pyther.net> <50C34628.5030407@googlemail.com> <50C34A50.6000207@pyther.net> <50C35AD1.3040000@googlemail.com> <50C48891.2050903@googlemail.com> <50C4A520.6020908@pyther.net> <CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com> <50C4BA20.8060003@googlemail.com>
In-Reply-To: <50C4BA20.8060003@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 09.12.2012 17:19, schrieb Frank Schäfer:
> Am 09.12.2012 16:46, schrieb Devin Heitmueller:
>> On Sun, Dec 9, 2012 at 9:50 AM, Matthew Gyurgyik <matthew@pyther.net> wrote:
>>> Just to make sure I'm not misunderstanding, the messages should get logged
>>> to dmesg, correct?
>> I wrote the original IR support for the em2874, but it seems to have
>> changed a bit since I submitted it.  One thing that jumps out at me is
>> if you specify a remote control of the wrong *type* (e.g. the driver
>> is configured for RC5 but the actual remote is configured for NEC),
>> then you're likely to get no events from the device.
>>
>> You may wish to lookup what type of remote RC_MAP_KWORLD_315U is, and
>> try a remote that is of the other protocol type (e.g. if
>> RC_MAP_KWORLD_315U is RC5 then try a remote which is NEC).  Then see
>> if you get events.  If so, then you know you have the correct RC
>> protocol and just need to adjust the RC profile specified.
>>
>> Also, it's possible the remote control is an RC6 remote, which I never
>> got around to adding em2874 driver support for.  Take a look at the
>> windows trace and see what register R50 is being set to.  In
>> particular, bits [3-2] will tell you what RC protocol the Windows
>> driver expects the remote to be.  I'm pretty sure I put the definition
>> for the relevant bits in em28xx-reg.h.
> According to the USB log, register 0x50 is set to 0x01.
>
> em28xx-reg.h says:
>
> /* em2874 IR config register (0x50) */
> #define EM2874_IR_NEC           0x00
> #define EM2874_IR_RC5           0x04
> #define EM2874_IR_RC6_MODE_0    0x08
> #define EM2874_IR_RC6_MODE_6A   0x0b
>
> Any idea what 0x01 is ?
>
> It also seems that em28xx_ir_change_protocol() always sets reg 0x05 to
> EM2874_IR_RC5...

Sorry, I was wrong. Of course it sets 0x05 to EM2874_IR_RC5 or
EM2874_IR_NEC depending on field .xclk in the board struct.

Frank

>
> Regards,
> Frank
>
>> Devin
>>
>> --
>> Devin J. Heitmueller - Kernel Labs
>> http://www.kernellabs.com

