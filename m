Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:18643
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751570AbaGWFFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 01:05:54 -0400
From: "Monica, Agnes" <Agnes.Monica@analog.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"v4l2-library@linuxtv.org" <v4l2-library@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: RE: [V4l2-library] FourCC support
Date: Wed, 23 Jul 2014 05:04:58 +0000
Message-ID: <E2B3634EC825DA45A0EB7D5409D69FBE584D1571@NWD2MBX6.ad.analog.com>
References: <E2B3634EC825DA45A0EB7D5409D69FBE584D03FA@NWD2MBX6.ad.analog.com>
 <53CE116D.8010404@xs4all.nl> <53CE14CF.9010900@xs4all.nl>
In-Reply-To: <53CE14CF.9010900@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

It would be good if support exists for full and limited range. 

1. So can we re-use(map) the existing  colorspace  for our different color format.
2. Or is it a good way to use custom control command. 

So in future if we come across some specific features with respect to our chip, is it good to use  custom control or  duplicate the functionality of the existing enums.

Regards,
Monica

-----Original Message-----
From: Hans Verkuil [mailto:hverkuil@xs4all.nl] 
Sent: Tuesday, July 22, 2014 1:08 PM
To: Monica, Agnes; v4l2-library@linuxtv.org; linux-media; Lars-Peter Clausen
Subject: Re: [V4l2-library] FourCC support

On 07/22/14 09:23, Hans Verkuil wrote:
> Hi Monica,
> 
> The v4l2-library is not the best mailinglist for that so I've added 
> linux-media as well, which is more appropriate. I've also added 
> Lars-Peter since he does a lot of adv work as well.
> 
> The short answer is that those colorspaces are not supported at the 
> moment, but that it is not a problem to add them, provided the driver 
> you are working on is going to be upstreamed (i.e., we'd like to have 
> users for the API elements we add).
> 
> One note of interest: there is currently no API mechanism to tell 
> userspace if the image data is limited or full range. YCbCr is always 
> assumed to be limited range and RGB full range. If you need to signal 
> that, then let me know. A flags field has been added to struct 
> v4l2_pix_format in the last few days that would allow you to add a 
> 'ALT_RANGE' flag, telling userspace that the alternate quantization 
> range is used. This flag doesn't exist yet, but it is no problem to add it.

To prevent any confusion: the colorspace isn't determined by the format fourcc, it's a separate colorspace field using the V4L2_COLORSPACE_* defines. The pixelformat and colorspace are two very different things.

Regards,

	Hans

> 
> Hope this helps,
> 
> 	Hans
> 
> On 07/22/14 08:18, Monica, Agnes wrote:
>> Hi ,
>>
>> One of drivers which we are developing supports formats like sYcc , 
>> AdobeRGB and AdobeYCC601 which was added recently in HDMI spec1.4. So 
>> can you please tell me how will these formats be supported by fmt.
>>
>> Regards,
>>
>> Monica
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
> 

