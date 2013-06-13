Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945Ab3FMKum (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 06:50:42 -0400
Date: Thu, 13 Jun 2013 07:50:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Chris Rankin <rankincj@yahoo.com>
Cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
Message-ID: <20130613075037.0da24c13@redhat.com>
In-Reply-To: <1369054869.78400.YahooMailNeo@web120305.mail.ne1.yahoo.com>
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com>
	<519791E2.4080804@googlemail.com>
	<1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com>
	<5197B34A.8010700@googlemail.com>
	<1368910949.59547.YahooMailNeo@web120304.mail.ne1.yahoo.com>
	<5198D669.6030007@googlemail.com>
	<1368972692.46197.YahooMailNeo@web120301.mail.ne1.yahoo.com>
	<51990B63.5090402@googlemail.com>
	<1368993591.43913.YahooMailNeo@web120305.mail.ne1.yahoo.com>
	<51993DDE.4070800@googlemail.com>
	<1369004659.18393.YahooMailNeo@web120305.mail.ne1.yahoo.com>
	<519A1939.6030907@googlemail.com>
	<1369054869.78400.YahooMailNeo@web120305.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 20 May 2013 06:01:09 -0700 (PDT)
Chris Rankin <rankincj@yahoo.com> escreveu:

> ----- Original Message -----
> 
> >> And this is me calling ir-keytable:
> >>
> >> [ 2183.812407] em28xx #0: Changing protocol: rc_type=1
> 
> > So with 3.8 the same happens as with 3.9.
> 
> Yes, that does appear to be part of the RC core ABI.
> 
> > Well, if ir-keycode / the RC core requests RC_BIT_UNKNOWN, they get RC_BIT_UNKNOWN. ;)
> > If you expect the device to be configured for another protocol (RC5 ?),
> > you need to find out what's going wrong in the RC core and/or ir-keycode.
> 
> Are other RCs affected by this? I have difficulty blaming RC core when its behaviour hasn't changed.
> 
> > The point is that 3.8 ignores rc_type=1, whereas 3.9 uses it to update a new ir->rc_type field - which in turn controls how em2874_polling_getkey() encodes its scancode.

There's something broken at either the tool or at the table, as
the it shouldn't be passing rc_type=1.

Ah, I know what's happening... thare are actually two hauppauge tables:

$ grep haupp rc_maps.cfg 
# cx8800	*				./keycodes/rc5_hauppauge_new
# *		*				./keycodes/rc5_hauppauge_new
*	rc-hauppauge             hauppauge
# *	*			 haupp                # found in nova-t-usb2.c

The proper one is the "hauppauge" one. The "haupp" table is an
alternative (broken) one for a driver that was not properly
converted to the RC core yet. On that driver, the table is coded
directly inside the driver. It shouldn't be hard to fix it there,
but that requires someone with that hardware, in order to test it,
and convert it to use dvb-usb-v2.

If you're using that table, it will try to set the protocol to unknown,
with is wrong, and have an unpredictable result, as, on some boards,
the em28xx will be working with NEC protocol, while, on others, with
RC5.

You should, instead, use this table:

$ more keytable/rc_keymaps/hauppauge
# table hauppauge, type: RC5
0x1e3b KEY_SELECT
0x1e3d KEY_POWER2
0x1e1c KEY_TV
0x1e18 KEY_VIDEO
0x1e19 KEY_AUDIO
0x1e1a KEY_CAMERA
0x1e1b KEY_EPG
0x1e0c KEY_RADIO
0x1e14 KEY_UP
0x1e15 KEY_DOWN
0x1e16 KEY_LEFT
0x1e17 KEY_RIGHT
0x1e25 KEY_OK
...

There, the protocol there seems to be properly identified as RC5, and
the ir-keytable will use RC5 type when setting it.

Regards,
Mauro
