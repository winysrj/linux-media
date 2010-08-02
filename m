Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35378 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0HBHaT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 03:30:19 -0400
Received: by bwz1 with SMTP id 1so1300416bwz.19
        for <linux-media@vger.kernel.org>; Mon, 02 Aug 2010 00:30:18 -0700 (PDT)
Date: Mon, 2 Aug 2010 09:27:11 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, udia@siano-ms.com
Subject: Re: [PATCH 3/6] V4L/DVB: smsusb: enable IR port for Hauppauge
	WinTV MiniStick
Message-ID: <20100802072711.GA5852@linux-m68k.org>
References: <cover.1280693675.git.mchehab@redhat.com> <20100801171718.5ad62978@pedra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100801171718.5ad62978@pedra>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 01, 2010 at 05:17:18PM -0300, Mauro Carvalho Chehab wrote:
> Add the proper gpio port for WinTV MiniStick, with the information provided
> by Michael.
> 
> Thanks-to: Michael Krufky <mkrufky@kernellabs.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/dvb/siano/sms-cards.c b/drivers/media/dvb/siano/sms-cards.c
> index cff77e2..dcde606 100644
> --- a/drivers/media/dvb/siano/sms-cards.c
> +++ b/drivers/media/dvb/siano/sms-cards.c
> @@ -67,6 +67,7 @@ static struct sms_board sms_boards[] = {
>  		.board_cfg.leds_power = 26,
>  		.board_cfg.led0 = 27,
>  		.board_cfg.led1 = 28,
> +		.board_cfg.ir = 9,
                               ^^^^

are you sure about this?

I am using the value of 4 for the ir port and it definitely works.. confused.

Thanks for looking at it, will test the patches as soon as I can.

Richard
