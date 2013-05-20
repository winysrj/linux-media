Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm24-vm2.bullet.mail.ne1.yahoo.com ([98.138.91.212]:44901 "EHLO
	nm24-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754898Ab3ETApE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 May 2013 20:45:04 -0400
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com> <519791E2.4080804@googlemail.com> <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com> <5197B34A.8010700@googlemail.com> <1368910949.59547.YahooMailNeo@web120304.mail.ne1.yahoo.com> <5198D669.6030007@googlemail.com> <1368972692.46197.YahooMailNeo@web120301.mail.ne1.yahoo.com> <51990B63.5090402@googlemail.com> <1368993591.43913.YahooMailNeo@web120305.mail.ne1.yahoo.com> <51993DDE.4070800@googlemail.com>
Message-ID: <1369010702.23562.YahooMailNeo@web120304.mail.ne1.yahoo.com>
Date: Sun, 19 May 2013 17:45:02 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
To: =?iso-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <51993DDE.4070800@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

----- Original Message -----

> I'm not familar with ir-keytable and the RC core.
> Mauro ? Can you take over ? ;)

This patch seems to "do the right thing"... I doubt it will apply cleanly because of TAB/space issues, but you should get the idea :-).

--- linux-3.9/drivers/media/usb/em28xx/em28xx-input.c.orig    2013-05-19 21:18:39.000000000 +0100
+++ linux-3.9/drivers/media/usb/em28xx/em28xx-input.c    2013-05-20 01:36:51.000000000 +0100
@@ -417,6 +417,7 @@
         *rc_type = RC_BIT_RC6_0;
     } else if (*rc_type & RC_BIT_UNKNOWN) {
         *rc_type = RC_BIT_UNKNOWN;
+                return 0;
     } else {
         *rc_type = ir->rc_type;
         return -EINVAL;

This is against 3.9.3.

Signed-off-by: Chris Rankin <rankincj@yahoo.com>
