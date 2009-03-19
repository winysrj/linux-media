Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:56964 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbZCSXGn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 19:06:43 -0400
Date: Thu, 19 Mar 2009 16:06:40 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org
Subject: Re: The right way to interpret the content of SNR, signal strength
 	and BER from HVR 4000 Lite
In-Reply-To: <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0903191558530.28292@shell2.speakeasy.net>
References: <49B9BC93.8060906@nav6.org>  <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>
  <49B9DECC.5090102@nav6.org>  <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
  <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>
 <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>
 <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>
 <20090319101601.2eba0397@pedra.chehab.org>  <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>
  <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net>
 <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Mar 2009, Devin Heitmueller wrote:
> On Thu, Mar 19, 2009 at 6:17 PM, Trent Piepho <xyzzy@speakeasy.org> wrote:
>
> == rant mode on ==
> Wow, I think we have lost our minds!
>
> The argument being put forth is based on the relative efficiency of
> the multiply versus divide opcodes on modern CPU architectures??  And

Maybe I just like writing efficient code to do interesting things?

> that you're going to be able to get an SNR with a higher level of
> precision than 0.1 dB?? (if the hardware suggests that it can then
> it's LYING to you)

Not really.  Absolute accuracy is not going to be that good of course.  But
the error measurements from which SNR is calculated do support precision of
better than 0.1 dB.  That precision does give you more power when fine
tuning antenna position.

Put another way, what advantage is there of less precision?

> this is the basis for proposing 8.8 format over just sending it back
> in 0.1dB increments.  We have officially entered the realm of

I've yet to see _any_ argument for using decimal fixed point.  Just because
binary fixed point isn't vastly superior to decimal doesn't make decimal
better.
