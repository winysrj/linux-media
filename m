Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54002 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbZJVUL1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2009 16:11:27 -0400
Date: Fri, 23 Oct 2009 05:10:25 +0900
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: Details about DVB frontend API
Message-ID: <20091023051025.597c05f4@caramujo.chehab.org>
In-Reply-To: <20091022211330.6e84c6e7@hyperion.delvare>
References: <20091022211330.6e84c6e7@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 22 Oct 2009 21:13:30 +0200
Jean Delvare <khali@linux-fr.org> escreveu:

> Hi folks,
> 
> I am looking for details regarding the DVB frontend API. I've read
> linux-dvb-api-1.0.0.pdf, it roughly explains what the FE_READ_BER,
> FE_READ_SNR, FE_READ_SIGNAL_STRENGTH and FE_READ_UNCORRECTED_BLOCKS
> commands return, however it does not give any information about how the
> returned values should be interpreted (or, seen from the other end, how
> the frontend kernel drivers should encode these values.) If there
> documentation available that would explain this?
> 
> For example, the signal strength. All I know so far is that this is a
> 16-bit value. But then what? Do greater values represent stronger
> signal or weaker signal? Are 0x0000 and 0xffff special values? Is the
> returned value meaningful even when FE_HAS_SIGNAL is 0? When
> FE_HAS_LOCK is 0? Is the scale linear, or do some values have
> well-defined meanings, or is it arbitrary and each driver can have its
> own scale? What are the typical use cases by user-space application for
> this value?
> 
> That's the kind of details I'd like to know, not only for the signal
> strength, but also for the SNR, BER and UB. Without this information,
> it seems a little difficult to have consistent frontend drivers.

We all want to know about that ;)

Seriously, the lack of a description of the meaning of the ranges for those
read values were already widely discussed at LMML and at the legacy dvb ML.
We should return this discussion again and decide what would be the better
way to describe those values.

My suggestion is that someone summarize the proposals we had and give some time
for people vote. After that, we just commit the most voted one, and commit the
patches for it. A pending question that should also be discussed is what we will
do with those dvb devices where we simply don't know what scale it uses. There
are several of them.

Btw, the new official documentation is the media infrastructure docbook that
can be found at the Kernel and at:
	http://linuxtv.org/downloads/v4l-dvb-apis

This covers both DVB and V4L API's.

Cheers,
Mauro
