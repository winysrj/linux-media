Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:48582 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610Ab2BBTEK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 14:04:10 -0500
Received: from 188-222-111-86.zone13.bethere.co.uk ([188.222.111.86] helo=tiber)
	by mail81.extendcp.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.77)
	id 1Rt1x3-0001Nv-Qh
	for linux-media@vger.kernel.org; Thu, 02 Feb 2012 19:04:09 +0000
Received: from [127.0.0.1] (helo=tiber)
	by tiber with esmtp (Exim 4.77)
	(envelope-from <h@realh.co.uk>)
	id 1Rt1xE-0002QI-2y
	for linux-media@vger.kernel.org; Thu, 02 Feb 2012 19:04:20 +0000
Date: Thu, 2 Feb 2012 19:04:20 +0000
From: Tony Houghton <h@realh.co.uk>
To: linux-media@vger.kernel.org
Subject: Re: DVB TS/PES filters
Message-ID: <20120202190420.45629a9b@tiber>
In-Reply-To: <4F29791C.6060201@flensrocker.de>
References: <20120126154015.01eb2c18@tiber>
	<20120201133234.0b6222bc@junior>
	<4F29791C.6060201@flensrocker.de>
Reply-To: linux-media@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 01 Feb 2012 18:40:44 +0100
Lars Hanisch <dvb@flensrocker.de> wrote:

> Am 01.02.2012 14:32, schrieb Tony Houghton:
> > On Thu, 26 Jan 2012 15:40:15 +0000 Tony Houghton<h@realh.co.uk>
> > wrote:
> >
> >> I could do with a little more information about DMX_SET_PES_FILTER.
> >> Specifically I want to use an output type of DMX_OUT_TS_TAP. I
> >> believe there's a limit on how many filters can be set, but I don't
> >> know whether the kernel imposes such a limit or whether it depends
> >> on the hardware, If the latter, how can I read the limit?
> >
> > Can anyone help me get more information about this (and the "magic
> > number" pid of 8192 for the whole stream)?
> 
>   In the TS-header there are 13 bits for the PID, so it can be from 0
>   to 8191.  Therefore dvb-core interprets 8192 (and greater values I
>   think) as "all PIDs".

Thanks for that. But it would be really helpful if I could find out
whether there really is a limit to the number of filters and whether
it's hardware dependent or the kernel.
