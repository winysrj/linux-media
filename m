Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46382
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbcGLPHc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 11:07:32 -0400
Subject: Re: [PATCH] media: s5p-mfc Fix misspelled error message and
 checkpatch errors
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@kernel.org
References: <1468276740-1591-1-git-send-email-shuahkh@osg.samsung.com>
 <8dd68d9b-9455-d593-dc0f-c269c778b961@osg.samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <578507B2.9020501@osg.samsung.com>
Date: Tue, 12 Jul 2016 09:07:30 -0600
MIME-Version: 1.0
In-Reply-To: <8dd68d9b-9455-d593-dc0f-c269c778b961@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/12/2016 09:03 AM, Javier Martinez Canillas wrote:
> Hello Shuah,
> 
> On 07/11/2016 06:39 PM, Shuah Khan wrote:
>> Fix misspelled error message and existing checkpatch errors in the
>> error message conditional.
>>
>> WARNING: suspect code indent for conditional statements (8, 24)
>>  	if (ctx->state != MFCINST_HEAD_PARSED &&
>> [...]
>> +               mfc_err("Can not get crop information\n");
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
> 
> Patch looks good to me. Maybe is better to split the message and checkpatch
> changes in two different patches. But I don't have a strong opinion on this:
> 
> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 

Thanks for the review. I considered splitting them, however the patch
that fixes the message will be flagged by checkpatch. It does make
sense to split the changes into two patches. What I could do is, make
the checkpatch fixes the first patch and fix the error message in the
second one.

How does that sound?

-- Shuah


