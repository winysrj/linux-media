Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46395
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbcGLQIm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 12:08:42 -0400
Subject: Re: [PATCH] media: s5p-mfc Fix misspelled error message and
 checkpatch errors
To: Joe Perches <joe@perches.com>, kyungmin.park@samsung.com,
	k.debski@samsung.com, jtp.park@samsung.com, mchehab@kernel.org,
	javier@osg.samsung.com
References: <1468276740-1591-1-git-send-email-shuahkh@osg.samsung.com>
 <1468332418.8745.11.camel@perches.com> <578501E9.6090008@osg.samsung.com>
 <1468338700.8745.14.camel@perches.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <57851607.9050005@osg.samsung.com>
Date: Tue, 12 Jul 2016 10:08:39 -0600
MIME-Version: 1.0
In-Reply-To: <1468338700.8745.14.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/12/2016 09:51 AM, Joe Perches wrote:
> On Tue, 2016-07-12 at 08:42 -0600, Shuah Khan wrote:
>> On 07/12/2016 08:06 AM, Joe Perches wrote:
>>> On Mon, 2016-07-11 at 16:39 -0600, Shuah Khan wrote:
>>>> Fix misspelled error message and existing checkpatch errors in the
>>>> error message conditional.
>>> []
>>>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>>> []
>>>> @@ -775,11 +775,11 @@ static int vidioc_g_crop(struct file *file, void *priv,
>>>>  	u32 left, right, top, bottom;
>>>>  
>>>>  	if (ctx->state != MFCINST_HEAD_PARSED &&
>>>> -	ctx->state != MFCINST_RUNNING && ctx->state != MFCINST_FINISHING
>>>> -					&& ctx->state != MFCINST_FINISHED) {
>>>> -			mfc_err("Cannont set crop\n");
>>>> -			return -EINVAL;
>>>> -		}
>>>> +	    ctx->state != MFCINST_RUNNING && ctx->state != MFCINST_FINISHING
>>>> +	    && ctx->state != MFCINST_FINISHED) {
>>>> +		mfc_err("Can not get crop information\n");
>>>> +		return -EINVAL;
>>>> +	}
>>> is it a set or a get?
>> vidioc_g_crop is a get routine.
>>>
>>> It'd be nicer for humans to read if the alignment was consistent
>> Are you okay with this alignment change or would you like it
>> changed?
> 
> Well, if you're resubmitting, I'd prefer it changed.
> Thanks.
> 

chekcpatch stopped complaining. Are you looking for the entire file
alignments changed? I am not clear on what needs to be changed?

thanks,
-- Shuah

