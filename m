Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:53391 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751273AbeA3Lx4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 06:53:56 -0500
Subject: Re: [PATCHv2 13/13] v4l2-compat-ioctl32.c: refactor, fix security bug
 in compat ioctl32
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, stable@vger.kernel.org
References: <20180130102701.13664-1-hverkuil@xs4all.nl>
 <20180130102701.13664-14-hverkuil@xs4all.nl>
 <20180130114619.v55lvnto3wxnhygt@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ae433de5-cd6c-74d0-9ca4-e59d2e8e2a13@xs4all.nl>
Date: Tue, 30 Jan 2018 12:53:51 +0100
MIME-Version: 1.0
In-Reply-To: <20180130114619.v55lvnto3wxnhygt@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/30/18 12:46, Sakari Ailus wrote:
> Hi Hans,
> 
> Thanks for the update. Please see a few additional comments below.
> 
> On Tue, Jan 30, 2018 at 11:27:01AM +0100, Hans Verkuil wrote:
> ...
>> @@ -891,30 +1057,53 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>>  	case VIDIOC_STREAMOFF:
>>  	case VIDIOC_S_INPUT:
>>  	case VIDIOC_S_OUTPUT:
>> -		err = get_user(karg.vi, (s32 __user *)up);
>> +		err = alloc_userspace(sizeof(unsigned int), 0, &up_native);
>> +		if (!err && assign_in_user((unsigned int __user *)up_native,
>> +					   (compat_uint_t __user *)up))
>> +			err = -EFAULT;
>>  		compatible_arg = 0;
>>  		break;
>>  
>>  	case VIDIOC_G_INPUT:
>>  	case VIDIOC_G_OUTPUT:
>> +		err = alloc_userspace(sizeof(unsigned int), 0,
>> +				      &up_native);
> 
> Fits on a single line.

Changed.

> 
>>  		compatible_arg = 0;
>>  		break;
>>  
>>  	case VIDIOC_G_EDID:
>>  	case VIDIOC_S_EDID:
>> -		err = get_v4l2_edid32(&karg.v2edid, up);
>> +		err = alloc_userspace(sizeof(struct v4l2_edid), 0, &up_native);
>> +		if (!err)
>> +			err = get_v4l2_edid32(up_native, up);
>>  		compatible_arg = 0;
>>  		break;
>>  
>>  	case VIDIOC_G_FMT:
>>  	case VIDIOC_S_FMT:
>>  	case VIDIOC_TRY_FMT:
>> -		err = get_v4l2_format32(&karg.v2f, up);
>> +		err = bufsize_v4l2_format(up, &aux_space);
>> +		if (!err)
>> +			err = alloc_userspace(sizeof(struct v4l2_format),
>> +					      aux_space, &up_native);
>> +		if (!err) {
>> +			aux_buf = up_native + sizeof(struct v4l2_format);
>> +			err = get_v4l2_format32(up_native, up,
>> +						aux_buf, aux_space);
>> +		}
>>  		compatible_arg = 0;
>>  		break;
>>  
>>  	case VIDIOC_CREATE_BUFS:
>> -		err = get_v4l2_create32(&karg.v2crt, up);
>> +		err = bufsize_v4l2_create(up, &aux_space);
>> +		if (!err)
>> +			err = alloc_userspace(sizeof(struct v4l2_create_buffers),
>> +					    aux_space, &up_native);
>> +		if (!err) {
>> +			aux_buf = up_native + sizeof(struct v4l2_create_buffers);
> 
> A few lines over 80 characters. It's not a lot but I see no reason to avoid
> wrapping them either.

I'm not changing this. It looks really ugly if I split it up.

> 
>> +			err = get_v4l2_create32(up_native, up,
>> +						aux_buf, aux_space);
>> +		}
>>  		compatible_arg = 0;
>>  		break;
>>  
> 
> The above can be addressed later, right now this isn't a priority.
> 
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 

Thanks!

	Hans
