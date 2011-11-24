Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59496 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab1KXKuj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 05:50:39 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH v3 1/3] fbdev: Add FOURCC-based format configuration API
Date: Thu, 24 Nov 2011 11:50:36 +0100
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	magnus.damm@gmail.com
References: <1314789501-824-1-git-send-email-laurent.pinchart@ideasonboard.com> <4EC85F41.50100@gmx.de> <201111201155.22948.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111201155.22948.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111241150.38653.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

Gentle ping ?

On Sunday 20 November 2011 11:55:22 Laurent Pinchart wrote:
> On Sunday 20 November 2011 03:00:33 Florian Tobias Schandinat wrote:
> > Hi Laurent,
> > 
> > On 08/31/2011 11:18 AM, Laurent Pinchart wrote:
> > > This API will be used to support YUV frame buffer formats in a standard
> > > way.
> > 
> > looks like the union is causing problems. With this patch applied I get
> > 
> > errors like this:
> >   CC [M]  drivers/auxdisplay/cfag12864bfb.o
> > 
> > drivers/auxdisplay/cfag12864bfb.c:57: error: unknown field ‘red’
> > specified in initializer
> 
> *ouch*
> 
> gcc < 4.6 chokes on anonymous unions initializers :-/
> 
> [snip]
> 
> > > @@ -246,12 +251,23 @@ struct fb_var_screeninfo {
> > > 
> > >  	__u32 yoffset;			/* resolution			*/
> > >  	
> > >  	__u32 bits_per_pixel;		/* guess what			*/
> > > 
> > > -	__u32 grayscale;		/* != 0 Graylevels instead of colors */
> > > 
> > > -	struct fb_bitfield red;		/* bitfield in fb mem if true color, */
> > > -	struct fb_bitfield green;	/* else only length is significant */
> > > -	struct fb_bitfield blue;
> > > -	struct fb_bitfield transp;	/* transparency			*/
> > > +	union {
> > > +		struct {		/* Legacy format API		*/
> > > +			__u32 grayscale; /* 0 = color, 1 = grayscale	*/
> > > +			/* bitfields in fb mem if true color, else only */
> > > +			/* length is significant			*/
> > > +			struct fb_bitfield red;
> > > +			struct fb_bitfield green;
> > > +			struct fb_bitfield blue;
> > > +			struct fb_bitfield transp;	/* transparency	*/
> > > +		};
> > > +		struct {		/* FOURCC-based format API	*/
> > > +			__u32 fourcc;		/* FOURCC format	*/
> > > +			__u32 colorspace;
> > > +			__u32 reserved[11];
> > > +		} fourcc;
> > > +	};
> 
> We can't name the union, otherwise this will change the userspace API.
> 
> We could "fix" the problem on the kernel side with
> 
> #ifdef __KERNEL__
> 	} color;
> #else
> 	};
> #endif

(and the structure that contains the grayscale, red, green, blue and transp 
fields would need to be similarly named, the "rgb" name comes to mind)

> That's quite hackish though... What's your opinion ?
> 
> It would also not handle userspace code that initializes an
> fb_var_screeninfo structure with named initializers, but that shouldn't
> happen, as application should read fb_var_screeninfo , modify it and write
> it back.
> 
> > >  	__u32 nonstd;			/* != 0 Non standard pixel format */

-- 
Regards,

Laurent Pinchart
