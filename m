Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:54859 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbZCTPH7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 11:07:59 -0400
Received: by qyk16 with SMTP id 16so1305932qyk.33
        for <linux-media@vger.kernel.org>; Fri, 20 Mar 2009 08:07:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49C33DE7.1050906@gmail.com>
References: <49B9BC93.8060906@nav6.org>
	 <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>
	 <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>
	 <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>
	 <20090319101601.2eba0397@pedra.chehab.org>
	 <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>
	 <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net>
	 <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>
	 <49C2D4DB.6060509@gmail.com> <49C33DE7.1050906@gmail.com>
Date: Fri, 20 Mar 2009 08:07:56 -0700
Message-ID: <a3ef07920903200807l501889bfu87d7906a082127e7@mail.gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
	and BER from HVR 4000 Lite
From: VDR User <user.vdr@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 19, 2009 at 11:55 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
> Well, that said positioning could be explained for those who on't
> have an understanding on how to do it.
>
> Let's assume, currently at position "X" there is no signal, no
> frontend LOCK. You can move the antenna to the approximate X-Y
> co-ordinates for the Azimuth and Elevation for your required
> transponder, while having an eye on FE_SIGNAL_LEVEL.
>
> While the FE_SIGNAL_LEVEL peaks for a given position, try to acquire
> a frontend LOCK, with the transponder parameters. Most likely you
> will get a frontend LOCK with the coarse positioning with AGC peak
> values.
>
> Now, with the frontend LOCK, you can look for initially the peak
> again, not the FE_SIGNAL_LEVEL peak in this case, but the
> FE_SIGNAL_STATS peak.
>
> In this case you should not be looking at just the strength
> parameter alone.
>
> * At the peak, you will get the maximum quality
> * falling down the slope to the left and right you will get falling
> signal strengths
> * Still rolling down, you will get increasing ERROR's, with still
> UNCORRECTABLES being steady.
> * Still falling down at the thresholds where you are about to loose
> frontend LOCK, you will see UNCORRECTABLE's getting incremented.
>
> Couple this logic into a program, with a feedback to the ROTOR and
> you get an automated satellite positioner, with a good fine tuned
> position.

This would make for a very very useful tool to have.  I can't count
the number of times I've seen people inquire about tools to help them
aim their dish and this sounds like the perfect solution to that long
standing problem.  Especially if it returned the network id once it's
achieve a lock so the user can see if he's pointed to the correct
satellite.
