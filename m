Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47129 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1K1LMc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 06:12:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH v3 1/3] fbdev: Add FOURCC-based format configuration API
Date: Mon, 28 Nov 2011 12:12:37 +0100
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	magnus.damm@gmail.com
References: <1314789501-824-1-git-send-email-laurent.pinchart@ideasonboard.com> <201111241150.38653.laurent.pinchart@ideasonboard.com> <4ED01224.9020703@gmx.de>
In-Reply-To: <4ED01224.9020703@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111281212.37923.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Friday 25 November 2011 23:09:40 Florian Tobias Schandinat wrote:
> On 11/24/2011 10:50 AM, Laurent Pinchart wrote:
> > Hi Florian,
> > 
> > Gentle ping ?
> 
> Sorry, but I'm very busy at the moment and therefore time-consuming things,
> like solving challenging problems, are delayed for some time.

No worries.

> > On Sunday 20 November 2011 11:55:22 Laurent Pinchart wrote:
> >> On Sunday 20 November 2011 03:00:33 Florian Tobias Schandinat wrote:
> >>> Hi Laurent,
> >>> 
> >>> On 08/31/2011 11:18 AM, Laurent Pinchart wrote:
> >>>> This API will be used to support YUV frame buffer formats in a
> >>>> standard way.
> >>> 
> >>> looks like the union is causing problems. With this patch applied I get
> >>> 
> >>> errors like this:
> >>>   CC [M]  drivers/auxdisplay/cfag12864bfb.o
> >>> 
> >>> drivers/auxdisplay/cfag12864bfb.c:57: error: unknown field ‘red’
> >>> specified in initializer
> >> 
> >> *ouch*
> >> 
> >> gcc < 4.6 chokes on anonymous unions initializers :-/
> >> 
> >> [snip]
> >> 
> >>>> @@ -246,12 +251,23 @@ struct fb_var_screeninfo {
> >>>> 
> >>>>  	__u32 yoffset;			/* resolution			*/
> >>>>  	
> >>>>  	__u32 bits_per_pixel;		/* guess what			*/
> >>>> 
> >>>> -	__u32 grayscale;		/* != 0 Graylevels instead of colors */
> >>>> 
> >>>> -	struct fb_bitfield red;		/* bitfield in fb mem if true color, */
> >>>> -	struct fb_bitfield green;	/* else only length is significant */
> >>>> -	struct fb_bitfield blue;
> >>>> -	struct fb_bitfield transp;	/* transparency			*/
> >>>> +	union {
> >>>> +		struct {		/* Legacy format API		*/
> >>>> +			__u32 grayscale; /* 0 = color, 1 = grayscale	*/
> >>>> +			/* bitfields in fb mem if true color, else only */
> >>>> +			/* length is significant			*/
> >>>> +			struct fb_bitfield red;
> >>>> +			struct fb_bitfield green;
> >>>> +			struct fb_bitfield blue;
> >>>> +			struct fb_bitfield transp;	/* transparency	*/
> >>>> +		};
> >>>> +		struct {		/* FOURCC-based format API	*/
> >>>> +			__u32 fourcc;		/* FOURCC format	*/
> >>>> +			__u32 colorspace;
> >>>> +			__u32 reserved[11];
> >>>> +		} fourcc;
> >>>> +	};
> >> 
> >> We can't name the union, otherwise this will change the userspace API.
> >> 
> >> We could "fix" the problem on the kernel side with
> >> 
> >> #ifdef __KERNEL__
> >> 
> >> 	} color;
> >> 
> >> #else
> >> 
> >> 	};
> >> 
> >> #endif
> > 
> > (and the structure that contains the grayscale, red, green, blue and
> > transp fields would need to be similarly named, the "rgb" name comes to
> > mind)
> 
> Which, I guess, would require modifying all drivers?

Unfortunately. That can be automated using coccinelle (I wrote a semantic 
patch for that), but it will still be around 10k lines of diff.

> I don't consider that a good idea. Maybe the simplest solution would be to
> drop the union idea and just accept an utterly misleading name "grayscale"
> for setting the FOURCC value.

I'll see if we can add an accessor macro to make it more explicit.

> The colorspace could use one of the reserved fields at the end or do you
> worry that we need to add a lot of other things?

For FOURCC-based format configuration I don't think we will need much more. If 
we do need lots of additional fields in the future we might have to consider 
an fbdev2 API ;-)

I'll resubmit patches based on this.

-- 
Regards,

Laurent Pinchart
