Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:58811 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030261Ab2CSRLO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 13:11:14 -0400
Message-ID: <4F676898.9010503@stericsson.com>
Date: Mon, 19 Mar 2012 18:10:48 +0100
From: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tom Cooksey <tom.cooksey@arm.com>,
	"patches@linaro.org" <patches@linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	'Rob Clark' <rob.clark@linaro.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"rschultz@google.com" <rschultz@google.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] [PATCH] RFC: dma-buf: userspace mmap support
References: <1331775148-5001-1-git-send-email-rob.clark@linaro.org> <000001cd0399$9e57db90$db0792b0$@cooksey@arm.com> <20120317201719.121f4104@pyx> <000101cd05ef$3eab78c0$bc026a40$@cooksey@arm.com> <20120319165644.3e4ce4ad@pyx>
In-Reply-To: <20120319165644.3e4ce4ad@pyx>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/19/2012 05:56 PM, Alan Cox wrote:
>> display controller will be reading the front buffer, but the GPU
>> >  might also need to read that front buffer. So perhaps adding
>> >  "read-only"&  "read-write" access flags to prepare could also be
>> >  interpreted as shared&  exclusive accesses, if we went down this
>> >  route for synchronization that is.:-)
> mmap includes read/write info so probably using that works out. It also
> means that you have the stuff mapped in a way that will bus error or
> segfault anyone who goofs rather than give them the usual 'deep
> weirdness' behaviour you get with mishandling of caching bits.
>
> Alan
mmap only give you this info at time of mmap call. prepare/finish would 
give you this info for each CPU access to the buffer (assuming mmap 
lasts multiple frames). Which means that you can optimize and have zero 
cache syncs for frames where CPU doesn't touch the buffer at all. If you 
use mmap info, then you would be forced to sync cache before each GPU 
access to the buffer. For example sub texture updates in glyph caches. 
They will only rarely change, so you don't want to sync CPU cache each 
time buffer is used in GPU, just because mmap says CPU has write access.

/Marcus

