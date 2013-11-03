Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:43911 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3KCLcB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 06:32:01 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVO00KFQQPCTB30@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 03 Nov 2013 06:32:00 -0500 (EST)
Date: Sun, 03 Nov 2013 09:31:55 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: linux-media@vger.kernel.org
Subject: Re: DVB-C2
Message-id: <20131103093155.50b59b45@samsung.com>
In-reply-to: <21095.747.879743.551447@morden.metzler>
References: <1382462076-29121-1-git-send-email-guest@puma.are.ma>
 <21095.747.879743.551447@morden.metzler>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 23 Oct 2013 00:57:47 +0200
Ralph Metzler <rjkm@metzlerbros.de> escreveu:

> Hi,
> 
> I am wondering if anybody looked into API extensions for DVB-C2 yet?
> Obviously, we need some more modulations, guard intervals, etc. 
> even if the demod I use does not actually let me set those (only auto).
> 
> But I do need to set the PLP and slice ID.
> I currently set them (8 bit each) by combining them into the 32 bit 
> stream_id (DTV_STREAM_ID parameter).

I don't like the idea of combining them into a single field. One of the
reasons is that we may have endianness issues.

So, IMHO, the better is to add a new property for slice ID.

> By using the stream id like this and not having (or being able) to set
> the rest of the new parameters I only have to add SYS_DVBC2 to the delivery systems
> right now. But the new parameters should be added for completeness and if we want to
> be able to scan we will need calls to read out L1 signalling information.

I didn't have time yet to dig into DVB-C2 API, but I think that the better
is to add full support to all modulation types, guard intervals, etc, even
knowing that most modern demods work fine on auto mode those days.

As you said, scan should be able to read out L1 signaling information.

Also, as we're starting to talk about modulator drivers, all those properties
should be specified on the modulator. 

So, it makes sense to add a patch there extending the API (both
documentation and frontend.h) to fully support DVB C2.

Regard
-- 

Cheers,
Mauro
