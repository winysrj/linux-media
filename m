Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm20-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.45]:38407 "EHLO
	nm20-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755331Ab3ETMsK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 08:48:10 -0400
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com> <519791E2.4080804@googlemail.com> <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com> <5197B34A.8010700@googlemail.com> <1368910949.59547.YahooMailNeo@web120304.mail.ne1.yahoo.com> <5198D669.6030007@googlemail.com> <1368972692.46197.YahooMailNeo@web120301.mail.ne1.yahoo.com> <51990B63.5090402@googlemail.com> <1368993591.43913.YahooMailNeo@web120305.mail.ne1.yahoo.com> <51993DDE.4070800@googlemail.com> <1369010702.23562.YahooMailNeo@web120304.mail.ne1.yahoo.com> <519A19CF.5020605@googlemail.com>
Message-ID: <1369054084.54858.YahooMailNeo@web120306.mail.ne1.yahoo.com>
Date: Mon, 20 May 2013 05:48:04 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
To: =?iso-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <519A19CF.5020605@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

----- Original Message -----

> This patch seems to "do the right thing"... I doubt it will apply cleanly because of TAB/space issues, but you should get the idea :-).
>
> --- linux-3.9/drivers/media/usb/em28xx/em28xx-input.c.orig    2013-05-19 21:18:39.000000000 +0100
> +++ linux-3.9/drivers/media/usb/em28xx/em28xx-input.c    2013-05-20 01:36:51.000000000 +0100
> @@ -417,6 +417,7 @@
>          *rc_type = RC_BIT_RC6_0;
>      } else if (*rc_type & RC_BIT_UNKNOWN) {
>          *rc_type = RC_BIT_UNKNOWN;
> +                return 0;
>      } else {
>          *rc_type = ir->rc_type;
>          return -EINVAL;
>
> This is against 3.9.3.
>
> Signed-off-by: Chris Rankin <rankincj@yahoo.com>

> No, this patch is wrong.
> Updating ir->rc_type with the new value of *rc_type is correct.

Well, it restores 3.8 behaviour, i.e. em28xx not clobbering its "RC5" configuration when RC core subsequently calls ir_change_protocol() with *rc_type=RC_BIT_UNKNOWN. The ir->rc_type parameter is new to 3.9, by the looks of things.

Cheers,
Chris

