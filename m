Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm28-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.22]:27866 "EHLO
	nm28-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538Ab3ERVCa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 May 2013 17:02:30 -0400
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com> <519791E2.4080804@googlemail.com> <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com> <5197B34A.8010700@googlemail.com>
Message-ID: <1368910949.59547.YahooMailNeo@web120304.mail.ne1.yahoo.com>
Date: Sat, 18 May 2013 14:02:29 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
To: =?iso-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <5197B34A.8010700@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

----- Original Message -----

> For the em28xx driver: em28xx-input.c:
> em28xx_ir_work() is called every 100ms
>    calls em28xx_ir_handle_key()
>        - calls ir->get_key() which is em2874_polling_getkey() in case of your device
>        - reports the detected key via rc_keydown() through the RC core

By the looks of things, it's not recognising the protocol: em2874_ir_change_protocol() is setting ir->rc_type to RC_BIT_UNKNOWN. Shouldn't it be using RC5 instead?

Cheers,
Chris
