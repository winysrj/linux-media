Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42679 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161109AbaJ3U1L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 16:27:11 -0400
Date: Thu, 30 Oct 2014 18:27:06 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: crope@iki.fi, linux-media@vger.kernel.org
Subject: Re: [PATCH v4 00/14] cx231xx: Use muxed i2c adapters instead of
 custom switching
Message-ID: <20141030182706.09265d37@recife.lan>
In-Reply-To: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
References: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Oct 2014 21:12:21 +0100
Matthias Schwarzott <zzam@gentoo.org> escreveu:

> Hi!
> 
> This time the series got only small updates from Antti's review.

Oh, no! I just merged the v3 patch series. I manually fixed the
points that Antti has made.

I'm also testing it already.

Could you, instead, rebase it on the top of my merge?

I added it at:
	ssh://linuxtv.org/git/mchehab/experimental.git cx231xx

While I'm still at the test phases.

> 
> Additionally I added a patch to no longer directly modify
> the content of the port3 switch bit in PWR_CTL_EN (from function cx231xx_set_power_mode).
> 
> Now there are two places where I wonder what happens:
> 1. cx231xx_set_Colibri_For_LowIF writes a fixed number into all 8bit parts of PWR_CTL_EN
>    What is this for?
> 2. I guess, cx231xx_demod_reset should reset the digital demod. For this it should toggle the bits 0 and 1 of PWR_CTL_EN. 
>    But instead it touches but 8 and 9.
>    Does someone know what this is?
> 
> 3. Is remembering the last status of the port3 bit working good enough?
>    Currently it is only used for the is_tuner hack function.
> 
> Regards
> Matthias
> 
