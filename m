Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm39-vm5.bullet.mail.ne1.yahoo.com ([98.138.229.165]:32615 "EHLO
	nm39-vm5.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752831Ab3ESOLd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 May 2013 10:11:33 -0400
References: <1368885450.24433.YahooMailNeo@web120306.mail.ne1.yahoo.com> <519791E2.4080804@googlemail.com> <1368890230.26016.YahooMailNeo@web120301.mail.ne1.yahoo.com> <5197B34A.8010700@googlemail.com> <1368910949.59547.YahooMailNeo@web120304.mail.ne1.yahoo.com> <5198D669.6030007@googlemail.com>
Message-ID: <1368972692.46197.YahooMailNeo@web120301.mail.ne1.yahoo.com>
Date: Sun, 19 May 2013 07:11:32 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 3.9.2 kernel - IR / em28xx_rc broken?
To: =?iso-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <5198D669.6030007@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

----- Original Message -----

> em28xx_ir_change_protocol() should be called at least twice:
> First from em28xx_ir_init() with RC_BIT_UNKNOWN (initial configuration) 
> and later from the RC core with RC_BIT_RC5.
> Can you confirm that ?

Yes, it does appear to be called twice: first with *rc_type=1 and then later with *rc_type=8. But that still doesn't seem to stop ir->rc_type being RC_BIT_UNKNOWN in em2874_polling_getkey().

Cheers,
Chris

