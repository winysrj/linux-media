Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm15-vm1.bullet.mail.ne1.yahoo.com ([98.138.90.254]:31093 "EHLO
	nm15-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538Ab3ERVRK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 May 2013 17:17:10 -0400
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com> <519791E2.4080804@googlemail.com> <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com> <5197B34A.8010700@googlemail.com>
Message-ID: <1368911510.2095.YahooMailNeo@web120302.mail.ne1.yahoo.com>
Date: Sat, 18 May 2013 14:11:50 -0700 (PDT)
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
>     calls em28xx_ir_handle_key()
>         - calls ir->get_key() which is em2874_polling_getkey() in case of your device
>         - reports the detected key via rc_keydown() through the RC core

Confirmed: em28xx is failing to set the protocol to RC5, which means that em2874_polling_getkey() is using the "default" (UNKNOWN) case to interpret the scan codes.

Forcing em2874_polling_getkey() to use RC5 fixes the remote control for this device.

Cheers,
Chris

