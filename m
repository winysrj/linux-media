Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:56444 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753389Ab1KYWJe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 17:09:34 -0500
Message-ID: <4ED01224.9020703@gmx.de>
Date: Fri, 25 Nov 2011 22:09:40 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	magnus.damm@gmail.com
Subject: Re: [PATCH v3 1/3] fbdev: Add FOURCC-based format configuration API
References: <1314789501-824-1-git-send-email-laurent.pinchart@ideasonboard.com> <4EC85F41.50100@gmx.de> <201111201155.22948.laurent.pinchart@ideasonboard.com> <201111241150.38653.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111241150.38653.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 11/24/2011 10:50 AM, Laurent Pinchart wrote:
> Hi Florian,
> 
> Gentle ping ?

Sorry, but I'm very busy at the moment and therefore time-consuming things, like
solving challenging problems, are delayed for some time.

> 
> On Sunday 20 November 2011 11:55:22 Laurent Pinchart wrote:
>> On Sunday 20 November 2011 03:00:33 Florian Tobias Schandinat wrote:
>>> Hi Laurent,
>>>
>>> On 08/31/2011 11:18 AM, Laurent Pinchart wrote:
>>>> This API will be used to support YUV frame buffer formats in a standard
>>>> way.
>>>
>>> looks like the union is causing problems. With this patch applied I get
>>>
>>> errors like this:
>>>   CC [M]  drivers/auxdisplay/cfag12864bfb.o
>>>
>>> drivers/auxdisplay/cfag12864bfb.c:57: error: unknown field ‘red’
>>> specified in initializer
>>
>> *ouch*
>>
>> gcc < 4.6 chokes on anonymous unions initializers :-/
>>
>> [snip]
>>
>>>> @@ -246,12 +251,23 @@ struct fb_var_screeninfo {
>>>>
>>>>  	__u32 yoffset;			/* resolution			*/
>>>>  	
>>>>  	__u32 bits_per_pixel;		/* guess what			*/
>>>>
>>>> -	__u32 grayscale;		/* != 0 Graylevels instead of colors */
>>>>
>>>> -	struct fb_bitfield red;		/* bitfield in fb mem if true color, */
>>>> -	struct fb_bitfield green;	/* else only length is significant */
>>>> -	struct fb_bitfield blue;
>>>> -	struct fb_bitfield transp;	/* transparency			*/
>>>> +	union {
>>>> +		struct {		/* Legacy format API		*/
>>>> +			__u32 grayscale; /* 0 = color, 1 = grayscale	*/
>>>> +			/* bitfields in fb mem if true color, else only */
>>>> +			/* length is significant			*/
>>>> +			struct fb_bitfield red;
>>>> +			struct fb_bitfield green;
>>>> +			struct fb_bitfield blue;
>>>> +			struct fb_bitfield transp;	/* transparency	*/
>>>> +		};
>>>> +		struct {		/* FOURCC-based format API	*/
>>>> +			__u32 fourcc;		/* FOURCC format	*/
>>>> +			__u32 colorspace;
>>>> +			__u32 reserved[11];
>>>> +		} fourcc;
>>>> +	};
>>
>> We can't name the union, otherwise this will change the userspace API.
>>
>> We could "fix" the problem on the kernel side with
>>
>> #ifdef __KERNEL__
>> 	} color;
>> #else
>> 	};
>> #endif
> 
> (and the structure that contains the grayscale, red, green, blue and transp 
> fields would need to be similarly named, the "rgb" name comes to mind)

Which, I guess, would require modifying all drivers?
I don't consider that a good idea. Maybe the simplest solution would be to drop
the union idea and just accept an utterly misleading name "grayscale" for
setting the FOURCC value. The colorspace could use one of the reserved fields at
the end or do you worry that we need to add a lot of other things?


Best regards,

Florian Tobias Schandinat

> 
>> That's quite hackish though... What's your opinion ?
>>
>> It would also not handle userspace code that initializes an
>> fb_var_screeninfo structure with named initializers, but that shouldn't
>> happen, as application should read fb_var_screeninfo , modify it and write
>> it back.
>>
>>>>  	__u32 nonstd;			/* != 0 Non standard pixel format */
> 

