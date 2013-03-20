Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30066 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3CTPf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 11:35:58 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJY002WPTZNYU90@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Mar 2013 15:35:55 +0000 (GMT)
Received: from [106.116.147.108] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MJY00LC2TZVOC80@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Mar 2013 15:35:55 +0000 (GMT)
Message-id: <5149D75A.3000703@samsung.com>
Date: Wed, 20 Mar 2013 16:35:54 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [REVIEW PATCH 0/6] s5p-tv: replace dv_preset by dv_timings
References: <1362402126-13149-1-git-send-email-hverkuil@xs4all.nl>
 <201303181524.12891.hverkuil@xs4all.nl>
In-reply-to: <201303181524.12891.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,
After successful testing (after applying "use cap instead of 0" fix),
please add:

Tested-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Acked-by: Tomasz Stanislawski <t.stanislaws@samsung.com>

to the commit log.

Regards,
Tomasz Stanislawski

On 03/18/2013 03:24 PM, Hans Verkuil wrote:
> On Mon March 4 2013 14:02:00 Hans Verkuil wrote:
>> Hi Tomasz,
>>
>> Here is what I hope is the final patch series for this. I've incorporated
>> your suggestions and it's split off from the davinci/blackfin changes into
>> its own patch series to keep things better organized.
>>
>> The changes since the previous version are:
>>
>> - changed the order of the first three patches as per your suggestion.
>> - the patch named "[RFC PATCH 08/18] s5p-tv: add dv_timings support for
>>   mixer_video." had two changes that rightfully belonged to the 'add
>>   dv_timings support for mixer_video.' patch. Moved them accordingly.
>> - hdmiphy now also supports dv_timings_cap and sets the pixelclock range
>>   accordingly. The hdmi driver chains hdmiphy to get those values.
>> - updating the minimum width to 720.
>>
>> I didn't add a comment to clarify the pixclk handling hdmiphy_s_dv_preset
>> because 1) I forgot, 2) it's not a bug, and 3) that whole function is
>> removed anyway a few patches later :-)
>>
>> The only functional change is the handling of dv_timings_cap. Can you
>> verify that that works as it should?
> 
> Tomasz,
> 
> Should I wait for feedback from you, or can I go ahead and make a pull
> request for this?
> 
> Regards,
> 
> 	Hans
> 

