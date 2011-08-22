Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f170.google.com ([209.85.210.170]:54409 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756589Ab1HVCGA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Aug 2011 22:06:00 -0400
Received: by mail-iy0-f170.google.com with SMTP id 16so9471111iye.1
        for <linux-media@vger.kernel.org>; Sun, 21 Aug 2011 19:05:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313949634.2874.13.camel@localhost>
References: <CAATJ+fu5JqVmyY=zJn_CM_Eusst_YWKG2B2MAuu5fqELYYsYqA@mail.gmail.com>
	<CAATJ+ft9HNqLA62ZZkkEP6EswXC1Jhq=FBcXU+OHCkXTKpqeUA@mail.gmail.com>
	<1313949634.2874.13.camel@localhost>
Date: Mon, 22 Aug 2011 12:05:59 +1000
Message-ID: <CAATJ+fv6x6p5kimJs4unWGQ_PU36hp29Rafu8BDCcRAABtAfgQ@mail.gmail.com>
Subject: Re: Afatech AF9013
From: Jason Hecker <jwhecker@gmail.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just tried LiveCDs of Mythbuntu 10.04 and 10.10 but had limited luck
with the former and some joy with the latter.  Unfortunately the
default framebuffer slowed things down.  Anyway in LiveCD 10.10 I used
mplayer to set up and view Tuner A and Tuner B and Tuner A only showed
some slight errors when Tuner B was being set up.  After that for some
strange reason attempt at retuning with mplayer failed utterly so I
suspect there is some problems with the older versions of mplayer.

These cards have blue LEDs for each tuner and light up when in use.  I
did notice in my testing that the LED on tuner A would flicker off
briefly (and presumably issue the errors) when Tuner B was being set
up.  I am wondering if there is a general setup problem or even a I2S
timing problem.  Could someone contact me off list about sending me
the data sheets for the AF901x chips?
