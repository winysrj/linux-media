Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:53094 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206Ab2BGO5e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Feb 2012 09:57:34 -0500
Received: from localhost (smtp-filter.ukfsn.org [192.168.54.205])
	by mail.ukfsn.org (Postfix) with ESMTP id C68DEDEB6D
	for <linux-media@vger.kernel.org>; Tue,  7 Feb 2012 14:57:32 +0000 (GMT)
Received: from mail.ukfsn.org ([192.168.54.25])
	by localhost (smtp-filter.ukfsn.org [192.168.54.205]) (amavisd-new, port 10024)
	with ESMTP id lrLVR5RIH9KT for <linux-media@vger.kernel.org>;
	Tue,  7 Feb 2012 15:31:45 +0000 (GMT)
Received: from [192.168.0.3] (unknown [78.32.18.90])
	by mail.ukfsn.org (Postfix) with ESMTP id 9BFDEDEB6A
	for <linux-media@vger.kernel.org>; Tue,  7 Feb 2012 14:57:32 +0000 (GMT)
Message-ID: <4F313BDC.1000100@ukfsn.org>
Date: Tue, 07 Feb 2012 14:57:32 +0000
From: Andy Furniss <andyqos@ukfsn.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: PCTV 290e page allocation failure
References: <4F2AC7BF.4040006@ukfsn.org>
In-Reply-To: <4F2AC7BF.4040006@ukfsn.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Furniss wrote:

> At first the PCTV worked OK, but now I've been getting a page allocation
> failure. After this happens I can't use the PVTV until I re-plug it.

Further testing on this shows that even if I free up lots of memory with

sync;echo 3 > /proc/sys/vm/drop_caches giving -

DMA: 55*4kB 55*8kB 57*16kB 53*32kB 40*64kB 26*128kB 9*256kB 4*512kB 
2*1024kB 0*2048kB 0*4096kB = 15556kB
Normal: 2996*4kB 2169*8kB 1616*16kB 1021*32kB 596*64kB 221*128kB 
45*256kB 2*512kB 0*1024kB 0*2048kB 0*4096kB = 166840kB

It will still fail if it has already failed and not been replugged.

It's not failing to allocate - it's just not trying to allocate AFAICT , 
which I guess counts as a bug?
