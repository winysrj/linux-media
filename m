Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36394 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbdA2Wu0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Jan 2017 17:50:26 -0500
Subject: Re: [PATCH] Staging: omap4iss: fix coding style issues
To: Ozgur Karatas <okaratas@member.fsf.org>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
References: <1485626408-9768-1-git-send-email-avraham.shukron@gmail.com>
 <6973561485675117@web6h.yandex.ru>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From: Avraham Shukron <avraham.shukron@gmail.com>
Message-ID: <dcb0a8c9-88bc-ca18-6056-19c3cc39f33f@gmail.com>
Date: Mon, 30 Jan 2017 00:42:01 +0200
MIME-Version: 1.0
In-Reply-To: <6973561485675117@web6h.yandex.ru>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 29/01/2017 9:31, Ozgur Karatas wrote:
> 
> 
> 28.01.2017, 20:11, "Avraham Shukron" <avraham.shukron@gmail.com>:
>> This is a patch that fixes issues in omap4iss/iss_video.c
>> Specifically, it fixes "line over 80 characters" issues
> 
> Hello,
> 
> are you have a sent this changes patch before?
> And Greg KH answered you, are you read?
> 
> Please send the change once, there is no need for a repeat.

Greg asked me to resend because I messed-up the subject line. I did.
Later I figured that I should have sent it as v2, but now its too late.


>> ---
>>  drivers/staging/media/omap4iss/iss_video.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
>> index c16927a..cdab053 100644
>> --- a/drivers/staging/media/omap4iss/iss_video.c
>> +++ b/drivers/staging/media/omap4iss/iss_video.c
>> @@ -298,7 +298,8 @@ iss_video_check_format(struct iss_video *video, struct iss_video_fh *vfh)
>>
>>  static int iss_video_queue_setup(struct vb2_queue *vq,
>>                                   unsigned int *count, unsigned int *num_planes,
>> - unsigned int sizes[], struct device *alloc_devs[])
>> + unsigned int sizes[],
>> + struct device *alloc_devs[])
> 
> it should be on the same line, maintainer's up to 80 characters allowed.
> this "alloc_devs" variable start with int?
> 
> Example:
> 
> struct device {
>   int (struct device *alloc_devs[);
> 
> Check the top lines of the codes.
> 
> 

No idea what you mean, but the line was *above* 80 characters, so I broke it.

>>  {
>>          struct iss_video_fh *vfh = vb2_get_drv_priv(vq);
>>          struct iss_video *video = vfh->video;
>> @@ -678,8 +679,8 @@ iss_video_get_selection(struct file *file, void *fh, struct v4l2_selection *sel)
>>          if (subdev == NULL)
>>                  return -EINVAL;
>>
>> - /* Try the get selection operation first and fallback to get format if not
>> - * implemented.
>> + /* Try the get selection operation first and fallback to get format if
>> + * not implemented.
>>           */
> 
> There is no change here, it opens with comment /* and closes with */.
> Please read submittting patch document.

The *is* a change. the word "not" is now on the second line of the comment,
putting the first line below 80 characters.

