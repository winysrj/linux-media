Return-path: <linux-media-owner@vger.kernel.org>
Received: from phobos02.frii.com ([216.17.128.162]:55003 "EHLO mail.frii.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753502AbZAVW4x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 17:56:53 -0500
Received: from io.frii.com (io.frii.com [216.17.222.1])
	by mail.frii.com (FRII) with ESMTP id 7C65B699AB
	for <linux-media@vger.kernel.org>; Thu, 22 Jan 2009 15:37:50 -0700 (MST)
Date: Thu, 22 Jan 2009 15:37:50 -0700
From: Mark Zimmerman <markzimm@frii.com>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Fusion HDTV 7 Dual Express
Message-ID: <20090122223750.GA69246@io.frii.com>
References: <48F78D8A020000560001A654@GWISE1.matc.edu> <alpine.LFD.2.00.0901221434040.7609@tupari.net> <412bdbff0901221149x100cf8abwd07d2c5821e286b2@mail.gmail.com> <alpine.LFD.2.00.0901221542190.7960@tupari.net> <412bdbff0901221328u6338ecd9q9ecc2ecab19051e5@mail.gmail.com> <alpine.LFD.2.00.0901221635550.8219@tupari.net> <412bdbff0901221343s7fc16ecdl3bed34c8e50ee3da@mail.gmail.com> <alpine.LFD.2.00.0901221706250.8336@tupari.net> <cae4ceb0901221413y55072ee7r570f9f7000dc7ddd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cae4ceb0901221413y55072ee7r570f9f7000dc7ddd@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 22, 2009 at 02:13:02PM -0800, Tu-Tu Yu wrote:
> Then that means you're getting good signal== 012c (Hex) equal to
> 300(Dec) then that means your snr value is 300/10 = 30 dB
> 

I just got one of these cards and I was noticing the snr values
(generally 300 or 295) as compared to those from my HD5500 (which
reports large numbers that have to be shifted and scaled). The card
works great but I was wondering: Does every driver report SNR in its
own unique way? Is there a standard way to interpret the numbers other
than reading the driver code? Just curious, not flaming...

Also, perhaps OT, the remote is detected:

input: i2c IR (FusionHDTV) as /devices/virtual/input/input6
ir-kbd-i2c: i2c IR (FusionHDTV) detected at i2c-3/3-006b/ir0 [cx23885[0]]

I noticed the other thread about keytables and was wondering if there
is any testing I could do that might be useful.

-- Mark

