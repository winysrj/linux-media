Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:11632 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaAGO6g (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 09:58:36 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ100K22DLN2Y50@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Jan 2014 09:58:35 -0500 (EST)
Date: Tue, 07 Jan 2014 12:58:30 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Tim Mester <ttmesterr@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Tim Mester <tmester@ieee.org>
Subject: Re: [PATCH 3/3] au8522, au0828: Added demodulator reset
Message-id: <20140107125830.4525c52c@samsung.com>
In-reply-to: <CAGoCfizhR=QJaonNzesLSVRZ+rEZCaY+QLVi7ksF1wx4N=Sm7Q@mail.gmail.com>
References: <1389068966-14594-1-git-send-email-tmester@ieee.org>
 <1389068966-14594-3-git-send-email-tmester@ieee.org>
 <CAGoCfix3GRETd+YXNSimpDY8StVPzc0sEMpzhdnuLf1eA4g+vw@mail.gmail.com>
 <CAGoCfizhR=QJaonNzesLSVRZ+rEZCaY+QLVi7ksF1wx4N=Sm7Q@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

Em Mon, 06 Jan 2014 23:53:15 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> What is the actual "corruption" that you are seeing?  Can you describe
> it in greater detail?  The original fix was specifically related to
> the internal FIFO on the au0828 where it can get shifted by one or
> more bits (i.e. the leading byte is no longer 0x47 but 0x47 << X).
> Hence it's an issue unrelated to the actual au8522.
> 
> I suspect this is actually a different problem which out of dumb luck
> gets "fixed" by resetting the chip.  Without more details on the
> specific behavior you are seeing though I cannot really advise on what
> the correct change is.
> 
> This patch should not be accepted upstream without more discussion.

Patches 1 and 2 are ok? If so, could you please reply to them with your 
ack?

> http://git.kernellabs.com/?p=dheitmueller/linuxtv.git;a=shortlog;h=refs/heads/950q_improv
> 
> I'm not against the hack you've proposed if it's really warranted, but
> a reset is really a last resort and I'm very concerned it's masking
> over the real problem.

Are you planning to submit the above patches upstream soon?



-- 

Cheers,
Mauro
