Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm31-vm7.bullet.mail.ne1.yahoo.com ([98.138.229.47]:33784 "EHLO
	nm31-vm7.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753806Ab3ESXEV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 May 2013 19:04:21 -0400
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com> <519791E2.4080804@googlemail.com> <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com> <5197B34A.8010700@googlemail.com> <1368910949.59547.YahooMailNeo@web120304.mail.ne1.yahoo.com> <5198D669.6030007@googlemail.com> <1368972692.46197.YahooMailNeo@web120301.mail.ne1.yahoo.com> <51990B63.5090402@googlemail.com> <1368993591.43913.YahooMailNeo@web120305.mail.ne1.yahoo.com> <51993DDE.4070800@googlemail.com>
Message-ID: <1369004659.18393.YahooMailNeo@web120305.mail.ne1.yahoo.com>
Date: Sun, 19 May 2013 16:04:19 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
To: =?iso-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <51993DDE.4070800@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

----- Original Message -----

> What happens with kernel 3.8 ? Does ir-keytable trigger an
> em28xx_ir_change_protocol() call there, too, but with type=8 ? Or is this call missing ?

This is the dmesg output from 3.8, with an extra ex28xx_info() call at the start of em28xx_ir_change_protocol():

[ 2149.668729] Em28xx: Initialized (Em28xx dvb Extension) extension
[ 2149.674447] em28xx #0: Changing protocol: rc_type=1
[ 2149.700087] Registered IR keymap rc-pinnacle-pctv-hd
[ 2149.700444] input: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1d.7/usb5/5-1/rc/rc0/input15
[ 2149.700655] rc0: em28xx IR (em28xx #0) as /devices/pci0000:00/0000:00:1d.7/usb5/5-1/rc/rc0
[ 2149.700660] em28xx #0: Changing protocol: rc_type=8
[ 2149.702337] Em28xx: Initialized (Em28xx Input Extension) extension
[ 2149.704204] em28xx #0: Changing protocol: rc_type=1

And this is me calling ir-keytable:

[ 2183.812407] em28xx #0: Changing protocol: rc_type=1

The point is that 3.8 ignores rc_type=1, whereas 3.9 uses it to update a new ir->rc_type field - which in turn controls how em2874_polling_getkey() encodes its scancode.

Cheers,
Chris

