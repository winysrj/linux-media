Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:57588 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbZIVH35 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 03:29:57 -0400
Date: Tue, 22 Sep 2009 09:29:45 +0200 (CEST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: liu.yaojin@zte.com.cn
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: re: Re: how to develop driver for cy7c68013(fx2 lp)?
In-Reply-To: <OFA2190736.178E50BE-ON48257639.001FAFA7-48257639.0020E884@zte.com.cn>
Message-ID: <alpine.LRH.1.10.0909220902390.23153@pub1.ifh.de>
References: <OFA2190736.178E50BE-ON48257639.001FAFA7-48257639.0020E884@zte.com.cn>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Liu,

(please avoid top-posts on this list)

On Tue, 22 Sep 2009, liu.yaojin@zte.com.cn wrote:

> hi,Mauro:
> thanks for replying.
> i am not sure the dtv api can be used in my project.because cmmb's
> protocol is different to dmb :(

Then the API needs to be extended. Maybe by you. Correct me if I'm wrong, 
but CMMB does not have standard MPEG2-TS and the configuration really 
needs real-time constraints.

How does it work for your device?

To have proper support for non-MPEG2-TS DTV streams we could add a new 
demuxer-type which handles it.

To tune a CMMB device we'd need to add the DTV_PROPERTIES to frontend.h

> in Windows, we download firmware using windows driver,config fx2 as bulk
> transfer,and read the TS stream,finally decode it and display.
> I also read this post: "http://www.linuxjournal.com/article/7466"----
> Writing a Real Driver?In User Space.
> if i just want to read the ts stream,should i use this method? or another
> way?

This option is rather useful for debugging/prototyping, IMO.

In the future we will have to support several CMMB device from different 
manufacturers. Up to now, we have used the kernel-user-interface to have 
stable API for different standards - we should continue to do so.

It would be nice to start the RFC-process for CMMB's extension to DVB API 
5 .

regards,

--

Patrick Boettcher - Kernel Labs
http://www.kernellabs.com/
