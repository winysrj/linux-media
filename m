Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2313 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaBDMb4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 07:31:56 -0500
Message-ID: <52F0DCE9.5020109@xs4all.nl>
Date: Tue, 04 Feb 2014 13:28:25 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 3/6] DocBook media: partial rewrite of "Opening and
 Closing Devices"
References: <1389100017-42855-1-git-send-email-hverkuil@xs4all.nl> <1389100017-42855-4-git-send-email-hverkuil@xs4all.nl> <20140113132013.06f558a0@samsung.com> <52D4112C.5040902@xs4all.nl> <20140113152350.1ab23491@samsung.com> <52D8F6BB.5010704@xs4all.nl> <20140204102053.7faaa317@samsung.com>
In-Reply-To: <20140204102053.7faaa317@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/04/14 13:20, Mauro Carvalho Chehab wrote:
> Em Fri, 17 Jan 2014 10:24:11 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>>
>> I'll post the revised version of this patch next.
> 
> Weird, I'm not seeing the revised version of this patch posted.

https://patchwork.linuxtv.org/patch/21620/

> 
> Anyway, from your original patch:
> 
>> +      <para>Today each device node supports just one function, with the
>> +exception of overlay support.</para>
> 
> It is still mixing overlay with "function" (where "function" means
> VBI, radio, video).

Yes, I want to tackle that separately.

> 
> I'll drop this one from the series I'm applying. Please review and submit
> latter a new version of this one to the ML for easier review.

Please just take this as is. The 'function' terminology was there in the
original, so it is not something this patch has introduced. Yes, it should be
changed, but it's something I need to think about some more. This patch may
not solve everything, but at least it greatly improves it.

Regards,

	Hans
