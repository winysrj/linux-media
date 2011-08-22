Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43177 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab1HVMBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Aug 2011 08:01:05 -0400
Received: by wwf5 with SMTP id 5so5131782wwf.1
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2011 05:01:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAATJ+fv6x6p5kimJs4unWGQ_PU36hp29Rafu8BDCcRAABtAfgQ@mail.gmail.com>
References: <CAATJ+fu5JqVmyY=zJn_CM_Eusst_YWKG2B2MAuu5fqELYYsYqA@mail.gmail.com>
	<CAATJ+ft9HNqLA62ZZkkEP6EswXC1Jhq=FBcXU+OHCkXTKpqeUA@mail.gmail.com>
	<1313949634.2874.13.camel@localhost>
	<CAATJ+fv6x6p5kimJs4unWGQ_PU36hp29Rafu8BDCcRAABtAfgQ@mail.gmail.com>
Date: Mon, 22 Aug 2011 14:01:02 +0200
Message-ID: <CAL9G6WUFddsFM2V46xXCDWEfhfCR0n5G-8S4JSYwLLkmZnYu7g@mail.gmail.com>
Subject: Re: Afatech AF9013
From: Josu Lazkano <josu.lazkano@gmail.com>
To: Jason Hecker <jwhecker@gmail.com>
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/8/22 Jason Hecker <jwhecker@gmail.com>:
> I just tried LiveCDs of Mythbuntu 10.04 and 10.10 but had limited luck
> with the former and some joy with the latter.  Unfortunately the
> default framebuffer slowed things down.  Anyway in LiveCD 10.10 I used
> mplayer to set up and view Tuner A and Tuner B and Tuner A only showed
> some slight errors when Tuner B was being set up.  After that for some
> strange reason attempt at retuning with mplayer failed utterly so I
> suspect there is some problems with the older versions of mplayer.
>
> These cards have blue LEDs for each tuner and light up when in use.  I
> did notice in my testing that the LED on tuner A would flicker off
> briefly (and presumably issue the errors) when Tuner B was being set
> up.  I am wondering if there is a general setup problem or even a I2S
> timing problem.  Could someone contact me off list about sending me
> the data sheets for the AF901x chips?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hello again, yesterday I try to connect the KWorld USB Dual DVB-T TV
Stick (DVB-T 399U) on my HTPC, I start MythTV and both tuners were
working great, I could record a channel and watch an other one, both
HD.

But 2 hours later they start to watch bad, with pixeled images:
http://dl.dropbox.com/u/1541853/kworld.3gp

I don't know what happens with this tuner. I have two identical ones
and both have same issues.

I could share a SSH root access to everyone that want to test the
tuner. I will install a fresh Debian Squeeze on my laptop and give
full access to the machine.

Anyone interested? I don't know what else to try with it.

Thanks and best regards.

-- 
Josu Lazkano
