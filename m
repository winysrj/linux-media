Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60001 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbdJ2Nh0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 09:37:26 -0400
Subject: Re: [PATCH] [media] bdisp: remove redundant assignment to pix
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Fabien Dessenne <fabien.dessenne@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20171029132105.6444-1-colin.king@canonical.com>
 <alpine.DEB.2.20.1710292129380.2004@hadrien>
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <7324ffb7-56d9-0f3a-46a8-c5b4be0b452b@canonical.com>
Date: Sun, 29 Oct 2017 13:37:23 +0000
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1710292129380.2004@hadrien>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29/10/17 13:30, Julia Lawall wrote:
> 
> 
> On Sun, 29 Oct 2017, Colin King wrote:
> 
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Pointer pix is being initialized to a value and a little later
>> being assigned the same value again. Remove the redundant second
>> duplicate assignment. Cleans up the clang warning:
>>
>> drivers/media/platform/sti/bdisp/bdisp-v4l2.c:726:26: warning: Value
>> stored to 'pix' during its initialization is never read
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  drivers/media/platform/sti/bdisp/bdisp-v4l2.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
>> index 939da6da7644..14e99aeae140 100644
>> --- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
>> +++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
>> @@ -731,7 +731,6 @@ static int bdisp_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
>>  		return PTR_ERR(frame);
>>  	}
>>
>> -	pix = &f->fmt.pix;
> 
> Why not keep this one and drop the first one?  Maybe it would be nice to
> keep all the initializations related to pix together?

Good point. Will send a V2.

> 
> julia
> 
>>  	pix->width = frame->width;
>>  	pix->height = frame->height;
>>  	pix->pixelformat = frame->fmt->pixelformat;
>> --
>> 2.14.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
