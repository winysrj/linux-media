Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935024Ab1JERtr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Oct 2011 13:49:47 -0400
Message-ID: <4E8C98B4.7090209@redhat.com>
Date: Wed, 05 Oct 2011 14:49:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mike Isely <isely@isely.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCHv2 5/8] [media] pvrusb2: initialize standards mask before
 detecting standard
References: <1317758000-21154-1-git-send-email-mchehab@redhat.com> <1317758000-21154-2-git-send-email-mchehab@redhat.com> <1317758000-21154-3-git-send-email-mchehab@redhat.com> <1317758000-21154-4-git-send-email-mchehab@redhat.com> <1317758000-21154-5-git-send-email-mchehab@redhat.com> <alpine.DEB.1.10.1110050857090.9044@cnc.isely.net>
In-Reply-To: <alpine.DEB.1.10.1110050857090.9044@cnc.isely.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 05-10-2011 11:00, Mike Isely escreveu:
>
> Mauro:
>
> With the line you've just added, then the " = arg" assignment in the
> immediate prior line is effectively dead code.  Try this instead:

Look better:

>>   		v4l2_std_id *std = arg;
>> +		*std = V4L2_STD_ALL;

The above code is creating a pointer 'std' of the type 'v4l2_std_id', and
initializing the pointer with the void *arg.

Then, it is doing an indirect reference to the pointer, filling its
contents with V4L2_STD_ALL value.

The code above is sane (and, btw, it works). After those patches, the
detection code will detect PAL/M or NTSC/M depending on the channel I
tune here (my cable operator broadcasts some channels with one format,
and others with the other one). Before this patch and the msp3400, it
would return a mask with PAL/M and PAL/60 or a mask with all NTSC/M formats.

Regards,
Mauro.

>
>   	case VIDIOC_QUERYSTD:
>   	{
> -		v4l2_std_id *std = arg;
> +		v4l2_std_id *std = V4L2_STD_ALL;
>   		ret = pvr2_hdw_get_detected_std(hdw, std);
>   		break;
>   	}
>
>    -Mike
>
>
> On Tue, 4 Oct 2011, Mauro Carvalho Chehab wrote:
>
>> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>> ---
>>   drivers/media/video/pvrusb2/pvrusb2-v4l2.c |    1 +
>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
>> index 0d029da..ce7ac45 100644
>> --- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
>> +++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
>> @@ -230,6 +230,7 @@ static long pvr2_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>>   	case VIDIOC_QUERYSTD:
>>   	{
>>   		v4l2_std_id *std = arg;
>> +		*std = V4L2_STD_ALL;
>>   		ret = pvr2_hdw_get_detected_std(hdw, std);
>>   		break;
>>   	}
>>
>

