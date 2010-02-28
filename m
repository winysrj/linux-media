Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:60353 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab0B1Sh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 13:37:56 -0500
Date: Sun, 28 Feb 2010 19:38:14 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org, Max Thrun <bear24rw@gmail.com>
Subject: Re: [PATCH 05/11] ov534: Fix setting manual exposure
Message-ID: <20100228193814.34f6755f@tele>
In-Reply-To: <1267302028-7941-6-git-send-email-ospite@studenti.unina.it>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
	<1267302028-7941-6-git-send-email-ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 27 Feb 2010 21:20:22 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> Exposure is now a u16 value, both MSB and LSB are set, but values in
> the v4l2 control are limited to the interval [0,506] as 0x01fa (506)
> is the maximum observed value with AEC enabled.
	[snip]
>  	    .type    = V4L2_CTRL_TYPE_INTEGER,
>  	    .name    = "Exposure",
>  	    .minimum = 0,
> -	    .maximum = 255,
> +	    .maximum = 506,
>  	    .step    = 1,
>  #define EXPO_DEF 120
>  	    .default_value = EXPO_DEF,

Hi Antonio,

Do we need a so high precision for the exposure? Just setting the
maximum value to 253 should solve the problem.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
