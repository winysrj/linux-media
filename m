Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:52352 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab1GULZF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2011 07:25:05 -0400
Date: Thu, 21 Jul 2011 13:27:01 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Luiz Ramos <lramos.prof@yahoo.com.br>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Fix wrong register mask in gspca/sonixj.c
Message-ID: <20110721132701.2a305d8e@tele>
In-Reply-To: <1311244993.60601.YahooMailClassic@web121810.mail.ne1.yahoo.com>
References: <20110720131212.13a9f8d2@tele>
	<1311244993.60601.YahooMailClassic@web121810.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 21 Jul 2011 03:43:13 -0700 (PDT)
Luiz Ramos <lramos.prof@yahoo.com.br> wrote:

> Now my doubts. Unless I misunderstood something, it seems these are
> the our assumptions regarding reg01 and reg17:
> 
>   - reg01 bit 6 is set when bridge runs at 48 MHz; if reset, 24 MHz
>   - reg17 bits 0..4 is a mask for dividing a sensor clock of 48 MHz,
> so
>     - if reg17 = x | 01 then clock = 48 MHz
>     - if reg17 = x | 02 then clock = 24 MHz
>     - if reg17 = x | 04 then clock = 12 MHz
> 
> Putting some printk at the code version 2.13.3, the values of these
> registers at the last command are:
> 
>   - at 640x480 ........... reg01 = 0x66  reg17 = 0x64
>   - at 320x240/160x120 ... reg01 = 0x26  reg17 = 0x61
> 
> So, at 640x480 the bridge would be running at 48 MHz and the sensor
> at 12 MHz. At lower resolutions the bridge would be running at 24 MHz
> and the sensor at 48 MHz. It seems that this is not what we'd like to
> do.

>From the documentation, the register 17 contains a divide factor of the
bridge clock (the sensor has no clock). So:

- reg01 = 0x66  reg17 = 0x64 --> bridge 48 MHz sensor 12 MHz
- reg01 = 0x26  reg17 = 0x61 --> bridge 24 MHz sensor 24 MHz

> I made some experiences, and noticed that:
> 
>   - making reg17 = 0x62 (sensor clock at 24 MHz) and reg01 = 0x26
>     (bridge clock at 24 MHz) at 320x240 and lower makes it work again.
>     I think this reaches the goal of having both clocks at 24 MHz, but
>     at 10 fps

In fact, bridge 24 MHz and sensor 12 MHz. This seems the best
configuration.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
