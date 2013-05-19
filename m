Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm19-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.179]:46359 "EHLO
	nm19-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753755Ab3ESWgT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 May 2013 18:36:19 -0400
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com> <519791E2.4080804@googlemail.com> <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com> <5197B34A.8010700@googlemail.com> <1368910949.59547.YahooMailNeo@web120304.mail.ne1.yahoo.com> <5198D669.6030007@googlemail.com> <1368972692.46197.YahooMailNeo@web120301.mail.ne1.yahoo.com> <51990B63.5090402@googlemail.com> <1368993591.43913.YahooMailNeo@web120305.mail.ne1.yahoo.com> <51993DDE.4070800@googlemail.com>
Message-ID: <1369002977.37692.YahooMailNeo@web120303.mail.ne1.yahoo.com>
Date: Sun, 19 May 2013 15:36:17 -0700 (PDT)
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

>> And this seems to reset the protocol back to "unknown". (But I need to use this other remote control to use VDR - the PCTV one just doesn't have enough buttons).

> Ok, then it seems to be no em28xx issue.
> What happens with kernel 3.8 ? Does ir-keytable trigger an
> em28xx_ir_change_protocol() call there, too, but with type=8 ? Or is this call missing ?

Possibly the significant difference between 3.8 and 3.9 is that the em2874_polling_getkey() function in 3.8 can only do one thing, whereas in 3.9 its behaviour switches on ir->rc_type.

The 3.9 version of em28xx_ir_change_protocol() also sets ir->rc_type to *rc_type before it exits, which means that the RC framework will "unconfigure" the em28xx remote control if it were to send RC_BIT_UNKNOWN for any reason.

And "yes", the 3.8 kernel does seem to call em28xx_ir_change_protocol() with *rc_type = RC_BIT_UNKNOWN occasionally too. It's just that under 3.8, the em28xx neither noticed nor cared.

Cheers,
Chris
