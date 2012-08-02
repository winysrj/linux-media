Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52295 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab2HBVZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 17:25:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Manju <manjunath.hadli@ti.com>
Cc: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Rob Landley <rob@landley.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David Cohen <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH] [media] davinci: vpfe: Add documentation
Date: Thu, 02 Aug 2012 23:25:43 +0200
Message-ID: <8508926.WDmbUJmVgK@avalon>
In-Reply-To: <50178D17.8030504@ti.com>
References: <1342021166-6092-1-git-send-email-manjunath.hadli@ti.com> <1461029.ufNJEg1MSf@avalon> <50178D17.8030504@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manjunath,

On Tuesday 31 July 2012 13:15:27 Manju wrote:
> On Friday 27 July 2012 04:19 PM, Laurent Pinchart wrote:
> > On Friday 27 July 2012 05:49:24 Hadli, Manjunath wrote:
> >> On Thu, Jul 26, 2012 at 05:55:31, Laurent Pinchart wrote:
> >>> On Tuesday 17 July 2012 10:43:54 Hadli, Manjunath wrote:
> >>>> On Sun, Jul 15, 2012 at 18:16:25, Laurent Pinchart wrote:
> >>>>> On Wednesday 11 July 2012 21:09:26 Manjunath Hadli wrote:
> >>>>>> Add documentation on the Davinci VPFE driver. Document the subdevs,
> >>>>>> and private IOTCLs the driver implements
> >>>>>> 
> >>>>>> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> >>>>>> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> >>> 
> >>> [snip]
> >>> 
> >>>>>> +Private IOCTLs
> >>>>>> +==============
> >>>>>> +
> >>>>>> +The Davinci Video processing Front End (VPFE) driver supports
> >>>>>> standard V4L2
> >>>>>> +IOCTLs and controls where possible and practical. Much of the
> >>>>>> functions provided
> >>>>>> +by the VPFE, however, does not fall under the standard IOCTLs.
> >>>>>> +
> >>>>>> +In general, there is a private ioctl for configuring each of the
> >>>>>> blocks
> >>>>>> +containing hardware-dependent functions.
> >>>>>> +
> >>>>>> +The following private IOCTLs are supported:
> >>>>>> +
> >>>>>> +1: IOCTL: PREV_S_PARAM/PREV_G_PARAM
> >>>>>> +Description:
> >>>>>> +	Sets/Gets the parameters required by the previewer module
> >>>>>> +Parameter:
> >>>>>> +	/**
> >>>>>> +	 * struct prev_module_param- structure to configure preview
> >>>>>> modules
> >>>>>> +	 * @version: Version of the preview module
> >>>>> 
> >>>>> Who is responsible for filling this field, the application or the
> >>>>> driver ?
> >>>> 
> >>>> The application is responsible for filling this info. He would
> >>>> enumerate the capabilities first and  set them using S_PARAM/G_PARAM.
> >>> 
> >>> And what's the point of the application setting the version field ? How
> >>> does the driver use it ?
> >> 
> >> The version may not be required. Will remove it.
> >> 
> >>>>>> +	 * @len: Length of the module config structure
> >>>>>> +	 * @module_id: Module id
> >>>>>> +	 * @param: pointer to module config parameter.
> >>>>> 
> >>>>> What is module_id for ? What does param point to ?
> >>>> 
> >>>> There are a lot of tiny modules in the previewer/resizer which are
> >>>> enumerated as individual modules. The param points to the parameter set
> >>>> that the module expects to be set.
> >>> 
> >>> Why don't you implement something similar to
> >>> VPFE_CMD_S_CCDC_RAW_PARAMS/VPFE_CMD_G_CCDC_RAW_PARAMS instead ?
> >> 
> >> I feel if we implement direct IOCTLS there might be many of them. To make
> >> sure than independent of the number of internal modules present, having
> >> the
> >> same IOCTL used for all modules is a good idea.
> > 
> > You can set several parameters using a single ioctl, much like
> > VPFE_CMD_S_CCDC_RAW_PARAMS does. You don't need one ioctl per parameter.
> > 
> > PREV_ENUM_CAP, PREV_[GS]_PARAM and PREV_[GS]_CONFIG are essentially
> > reinventing V4L2 controls, and I don't think that's a good idea.
> 
> Ok. I looked into this, and found that the structure needed to pass
> all the parameters is going to be huge. just to avoid a big structure
> from the user space, I propose:
> 
> Having a union of structures and a parameter identifying the structure.
> 
> In that way, we will remove the enumeration and all the other
> things except for a SET and GET, much like the CCDC_RAW_PARAMS
> like you suggested. So essentially we will have only 2 IOCTLS for setting
> the private params/configs and remove the rest.  I hope that was your
> point and this proposal will solve it?

What about something like the following structure, from the OMAP3 ISP driver ?

struct omap3isp_prev_update_config {
        __u32 update;
        __u32 flag;
        __u32 shading_shift;
        struct omap3isp_prev_luma __user *luma;
        struct omap3isp_prev_hmed __user *hmed;
        struct omap3isp_prev_cfa __user *cfa;
        struct omap3isp_prev_csup __user *csup;
        struct omap3isp_prev_wbal __user *wbal;
        struct omap3isp_prev_blkadj __user *blkadj;
        struct omap3isp_prev_rgbtorgb __user *rgb2rgb;
        struct omap3isp_prev_csc __user *csc;
        struct omap3isp_prev_yclimit __user *yclimit;
        struct omap3isp_prev_dcor __user *dcor;
        struct omap3isp_prev_nf __user *nf;
        struct omap3isp_prev_gtables __user *gamma;
};

I'll probably have more comments when I'll see the complete list of parameters 
you need to expose.

> >>>>>> +	 */
> >>>>>> +	struct prev_module_param {
> >>>>>> +		char version[IMP_MAX_NAME_SIZE];
> >>>>> 
> >>>>> Is there a need to express the version as a string instead of an
> >>>>> integer ?
> >>>> 
> >>>> It could be integer. It is generally a fixed point num, and easy to
> >>>> read
> >>>> it as a string than an integer. Can I keep it as a string?
> >>> 
> >>> Let's first decide whether a version field is needed at all :-)
> >> 
> >> Will remove.
> >> 
> >>>>>> +		unsigned short len;
> >>>>>> +		unsigned short module_id;
> >>>>>> +		void *param;
> >>>>>> +	};

-- 
Regards,

Laurent Pinchart

