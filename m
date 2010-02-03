Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab0BCI7N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 03:59:13 -0500
Message-ID: <4B693AD6.3030005@redhat.com>
Date: Wed, 03 Feb 2010 06:59:02 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Huang Shijie <shijie8@gmail.com>
CC: linux-media@vger.kernel.org, zyziii@telegent.com, tiwai@suse.de
Subject: Re: [PATCH v2 00/10] add linux driver for chip TLG2300
References: <1265094475-13059-1-git-send-email-shijie8@gmail.com> <4B6817E6.4070709@redhat.com> <4B69159D.2040606@gmail.com> <4B6925EB.7000601@redhat.com> <4B693681.2030402@gmail.com>
In-Reply-To: <4B693681.2030402@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Huang Shijie wrote:
> 
>>>> Instead of a country code, the driver should use the V4L2_STD_
>>>> macros to
>>>>
>>>>        
>>> If we are in the radio mode, I do not have any video standard, how can I
>>> choose
>>> the right audio setting in this situation?
>>>      
>> In the case of radio, the frequency ranges are controlled via the tuner
>>    
> 
> Do you mean that the frequency range can be used to set the pre-emphasis?
> I am not sure about this.

No, I don't meant that. 

The differences of FM radio standards are basically the preemphasis and the
frequency ranges.

For frequency ranges, V4L2_TUNER_RADIO allows specifying the maximum/minimum values.

For preemphasis, you should implement V4L2_CID_TUNE_PREEMPHASIS ctrl. This
CTRL has 3 states:

        static const char *tune_preemphasis[] = {
                "No preemphasis",
                "50 useconds",
                "75 useconds",
                NULL,
        };

At v4l2-common.c, there are some functions that helps to implement it
at the driver, like:
	v4l2_ctrl_get_menu, v4l2_ctrl_get_name and v4l2_ctrl_query_fill.

Take a look at si4713-i2c.c for an example on how to use it.

Ah, please submit those changes as another series of patches. This helps me
to not needing to review the entire changeset again.

Cheers,
Mauro
