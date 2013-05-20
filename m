Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:43832 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab3ETMgo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 08:36:44 -0400
Received: by mail-ea0-f182.google.com with SMTP id r16so3932044ead.41
        for <linux-media@vger.kernel.org>; Mon, 20 May 2013 05:36:43 -0700 (PDT)
Message-ID: <519A1939.6030907@googlemail.com>
Date: Mon, 20 May 2013 14:38:17 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com> <519791E2.4080804@googlemail.com> <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com> <5197B34A.8010700@googlemail.com> <1368910949.59547.YahooMailNeo@web120304.mail.ne1.yahoo.com> <5198D669.6030007@googlemail.com> <1368972692.46197.YahooMailNeo@web120301.mail.ne1.yahoo.com> <51990B63.5090402@googlemail.com> <1368993591.43913.YahooMailNeo@web120305.mail.ne1.yahoo.com> <51993DDE.4070800@googlemail.com> <1369004659.18393.YahooMailNeo@web120305.mail.ne1.yahoo.com>
In-Reply-To: <1369004659.18393.YahooMailNeo@web120305.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 20.05.2013 01:04, schrieb Chris Rankin:
> ----- Original Message -----
>
>> What happens with kernel 3.8 ? Does ir-keytable trigger an
>> em28xx_ir_change_protocol() call there, too, but with type=8 ? Or is this call missing ?
> This is the dmesg output from 3.8, with an extra ex28xx_info() call at the start of em28xx_ir_change_protocol():
>
> [ 2149.668729] Em28xx: Initialized (Em28xx dvb Extension) extension
> [ 2149.674447] em28xx #0: Changing protocol: rc_type=1
> [ 2149.700087] Registered IR keymap rc-pinnacle-pctv-hd
> [ 2149.700444] input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1d.7/usb5/5-1/rc/rc0/input15
> [ 2149.700655] rc0: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1d.7/usb5/5-1/rc/rc0
> [ 2149.700660] em28xx #0: Changing protocol: rc_type=8
> [ 2149.702337] Em28xx: Initialized (Em28xx Input Extension) extension
> [ 2149.704204] em28xx #0: Changing protocol: rc_type=1
>
> And this is me calling ir-keytable:
>
> [ 2183.812407] em28xx #0: Changing protocol: rc_type=1

So with 3.8 the same happens as with 3.9.

Well, if ir-keycode / the RC core requests RC_BIT_UNKNOWN, they get
RC_BIT_UNKNOWN. ;)
If you expect the device to be configured for another protocol (RC5 ?),
you need to find out what's going wrong in the RC core and/or ir-keycode.

> The point is that 3.8 ignores rc_type=1, whereas 3.9 uses it to update a new ir->rc_type field - which in turn controls how em2874_polling_getkey() encodes its scancode.

Indeed, since 3.9
1.) em2874_polling_getkey() cares about the rc_type
2.) the new rc_type is saved back to ir->rc_type

AFAICS both changes are correct.

But there was a third change:
3.) the scancode passed to the RC core with rc_keypress() in case of
RC_BIT_UNKNOWN changed from a 16 bit value to 32 bit value (e.g.: old:
00 00 ab cd => new: ab cd xx xx).

Hmm... isn't this an ABI break !?

Regards,
Frank

