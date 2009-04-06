Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40780 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZDFBYt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 21:24:49 -0400
Date: Sun, 5 Apr 2009 22:23:35 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Marton Balint <cus@fazekas.hu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1 of 3] cx88: Add support for stereo and sap detection
 for A2
Message-ID: <20090405222335.2778eef4@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0904060201380.438@cinke.fazekas.hu>
References: <patchbomb.1238536910@roadrunner.athome>
	<32593e0b3a9253e4f3d2.1238536911@roadrunner.athome>
	<20090405190257.060906ee@pedra.chehab.org>
	<Pine.LNX.4.64.0904060201380.438@cinke.fazekas.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 6 Apr 2009 02:36:01 +0200 (CEST)
Marton Balint <cus@fazekas.hu> wrote:

> On Sun, 5 Apr 2009, Mauro Carvalho Chehab wrote:
> 
> > Hi Marton,
> > 
> > I suspect that you will need to use div64 math or some othe way to calculate the freq:
> > 
> > /home/v4l/master/v4l/cx88-dsp.c: In function 'detect_a2_a2m_eiaj':
> > /home/v4l/master/v4l/cx88-dsp.c:147: error: SSE register return with SSE disabled
> > make[3]: *** [/home/v4l/master/v4l/cx88-dsp.o] Error 1
> > make[3]: *** Waiting for unfinished jobs....
> 
> Gcc should have optimised away the floating point operations and the 
> __builtin_remainder function. Hmm, it seems that older gcc's don't do 
> this. Would you try the attached patch? It uses integer modulo instead 
> of __builtin_remainder, so only basic floating point operations needs 
> optimising, hopefully every common gcc version will be able to do it.

Worked. I've folded this patch with the previous one, to avoid bisect breakage upstream.

Cheers,
Mauro
