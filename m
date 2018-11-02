Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13078 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbeKBXZr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 19:25:47 -0400
Date: Fri, 2 Nov 2018 16:18:28 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 21/30] v4l: Add bus type to frame descriptors
Message-ID: <20181102141827.6t7rhvzqmdywtnmp@paasikivi.fi.intel.com>
References: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
 <20180823132544.521-22-niklas.soderlund+renesas@ragnatech.se>
 <3c1ee187-cb95-efed-7c7e-4efda28209c3@ideasonboard.com>
 <20181102131522.y332vxbk5oc5zdxk@paasikivi.fi.intel.com>
 <17d55006-8698-d2f3-3a4d-5fa1200dce86@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17d55006-8698-d2f3-3a4d-5fa1200dce86@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 02, 2018 at 01:35:02PM +0000, Kieran Bingham wrote:
> Hi Sakari, Niklas,
> 
> On 02/11/2018 13:15, Sakari Ailus wrote:
> > Hi Kieran,
> > 
> > On Fri, Nov 02, 2018 at 12:27:11PM +0000, Kieran Bingham wrote:
> >> Hi Niklas, Sakari
> >>
> >> On 23/08/2018 14:25, Niklas Söderlund wrote:
> >>> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>>
> >>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>> ---
> >>>  include/media/v4l2-subdev.h | 9 +++++++++
> >>>  1 file changed, 9 insertions(+)
> >>>
> >>> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> >>> index 5acaeeb9b3cacefa..ac1f7ee4cdb978ad 100644
> >>> --- a/include/media/v4l2-subdev.h
> >>> +++ b/include/media/v4l2-subdev.h
> >>> @@ -349,12 +349,21 @@ struct v4l2_mbus_frame_desc_entry {
> >>>  
> >>>  #define V4L2_FRAME_DESC_ENTRY_MAX	4
> >>>  
> >>> +enum {
> >>> +	V4L2_MBUS_FRAME_DESC_TYPE_PLATFORM,
> >>> +	V4L2_MBUS_FRAME_DESC_TYPE_PARALLEL,
> >>> +	V4L2_MBUS_FRAME_DESC_TYPE_CCP2,
> >>> +	V4L2_MBUS_FRAME_DESC_TYPE_CSI2,
> >>
> >> Does this need to be extended to differentiate CSI2 DPHY/CPHY as has
> >> been done in the v4l2_mbus_config structures?
> > 
> > I'd say no; the PHY isn't really relevant at this level. The configuration
> > from fwnode should suffice.
> 
> Great - Thanks for the feedback.
> 
> 
> Well then - now that I've gone through the patch - and the PHY type
> naming is cleared up, I can add:
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> (I guess Niklas can pick up that tag currently)
> 
> Although - we're missing any commit message other than the commit title.
> Should something be added?
> 
> There's not much to describe above the title really.

Oh, indeed.

How about this:

The type will be used to determine which bus specific frame descriptor
struct is applicable to a given frame descriptor.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
