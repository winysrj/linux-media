Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41277 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab2CVL3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 07:29:00 -0400
Received: by wibhq7 with SMTP id hq7so631201wib.1
        for <linux-media@vger.kernel.org>; Thu, 22 Mar 2012 04:28:59 -0700 (PDT)
Message-ID: <4F6B0CF9.2030608@gmail.com>
Date: Thu, 22 Mar 2012 12:28:57 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: current em28xx driver crashes
References: <4F6B065A.2060407@iki.fi>
In-Reply-To: <4F6B065A.2060407@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 22/03/2012 12:00, Antti Palosaari ha scritto:
> Hello
> I am running Kernel 3.3-rc7 + around week old linux-media.
> 
> During the implementation of MaxMedia UB425-TC and PCTV QuatroStick nano
> (520e) device support I ran very many crashes likely when unloading
> modules. Here is Kernel Panic [1].
> 
> Today it crashes just during PCTV 520e stress test. It have been
> scanning DVB-C channels in loop ~3 days now and it crashed without
> reason. Here is Kernel Panic [2].
> 
> Could someone look those and guess what is reason em28xx is so unstable
> currently?
> 
> 
> [1]
> http://palosaari.fi/linux/v4l-dvb/em28xx_crashes/IMG_20120318_225505.jpg
> [2] http://palosaari.fi/linux/v4l-dvb/em28xx_crashes/
> 
> regards
> Antti

Hi Antti,
it may be due to this patch:

http://patchwork.linuxtv.org/patch/9875/

Can you try to revert it and see if the problems disappear?
I've never seen this crashes on my systems, but my hardware and my use
cases are totally different.

Looks like the problems originates into em28xx_irq_callback() and/or
em28xx_dvb_isoc_copy().

Regards,
Gianluca
