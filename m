Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.work.de ([212.12.32.20]:40793 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbZCXXya (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 19:54:30 -0400
Message-ID: <49C972AF.4030002@gmail.com>
Date: Wed, 25 Mar 2009 03:54:23 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Mika Laitio <lamikr@pilppa.org>
CC: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Trent Piepho <xyzzy@speakeasy.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ang Way Chuang <wcang@nav6.org>,
	VDR User <user.vdr@gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
 and BER from HVR 4000 Lite
References: <49B9BC93.8060906@nav6.org>  <Pine.LNX.4.58.0903131649380.28292@shell2.speakeasy.net>  <20090319101601.2eba0397@pedra.chehab.org>  <Pine.LNX.4.58.0903191229370.28292@shell2.speakeasy.net>  <Pine.LNX.4.58.0903191457580.28292@shell2.speakeasy.net>  <412bdbff0903191536n525a2facp5bc9637ebea88ff4@mail.gmail.com>  <49C2D4DB.6060509@gmail.com> <49C33DE7.1050906@gmail.com>  <1237689919.3298.179.camel@palomino.walls.org>  <412bdbff0903221800j2f9e1137u7776191e2e75d9d2@mail.gmail.com> <412bdbff0903241439u472be49mbc2588abfc1d675d@mail.gmail.com> <49C96A37.4020905@gmail.com> <Pine.LNX.4.64.0903250128110.11676@shogun.pilppa.org>
In-Reply-To: <Pine.LNX.4.64.0903250128110.11676@shogun.pilppa.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mika Laitio wrote:

> But there should anyway be mandatory to have this one "standard goodness
> value" in a way that does not require apps to make any complicate
> comparisons... (I bet half of those apps would be broken for years)


That said, the conversion functions can be added into libdvb, how we
have added support for EN50221 CAM support. Apps that use the
library can simply use the builtin functions and forget about all
those conversions. That might help some of the applciations which
are not conversant in conversions.

Regards,
Manu

