Return-path: <mchehab@pedra>
Received: from smtp02.frii.com ([216.17.135.168]:53819 "EHLO smtp02.frii.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903Ab1BHPZ0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Feb 2011 10:25:26 -0500
Received: from io.frii.com (io.frii.com [216.17.222.1])
	by smtp02.frii.com (FRII) with ESMTP id 2CD6AD9A2C
	for <linux-media@vger.kernel.org>; Tue,  8 Feb 2011 08:25:26 -0700 (MST)
Date: Tue, 8 Feb 2011 08:25:26 -0700
From: Mark Zimmerman <markzimm@frii.com>
To: v4l-dvb Mailing List <linux-media@vger.kernel.org>
Subject: Re: Tuning channels with DViCO FusionHDTV7 Dual Express
Message-ID: <20110208152525.GA47904@io.frii.com>
References: <AANLkTin8Rjch6o7aU-9S9m8f5aBYVeSwxSaVhyEfM5q9@mail.gmail.com> <20110206232800.GA83692@io.frii.com> <AANLkTinMCTh-u-JgcNB3SsZ2yf+9DgNFGA6thF7S0K15@mail.gmail.com> <6C78EB6E-7722-447F-833D-637DBB64CF61@dons.net.au> <AANLkTinn1XHifYy+PZTaTLP87NAqCind35iO7CBmdU-c@mail.gmail.com> <1297122870.2355.21.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297122870.2355.21.camel@localhost>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Feb 07, 2011 at 06:54:30PM -0500, Andy Walls wrote:
> 
> You perhaps could 
> 
> A. provide the smallest window of known good vs known bad kernel
> versions.  Maybe someone with time and hardware can 'git bisect' the
> issue down to the problem commit.  (I'm guessing this problem might be
> specific to a particular 64 bit platform IOMMU type, given the bad
> dma_ops pointer.)
> 

FYI: I am on the process of doing a git bisect (10 kernels to go) to
track down this problem:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg25342.html

Which may or may not be related to the problem in this thread. 
