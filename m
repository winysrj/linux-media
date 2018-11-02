Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:49294 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbeKBWWd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 18:22:33 -0400
Date: Fri, 2 Nov 2018 15:15:22 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 21/30] v4l: Add bus type to frame descriptors
Message-ID: <20181102131522.y332vxbk5oc5zdxk@paasikivi.fi.intel.com>
References: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
 <20180823132544.521-22-niklas.soderlund+renesas@ragnatech.se>
 <3c1ee187-cb95-efed-7c7e-4efda28209c3@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3c1ee187-cb95-efed-7c7e-4efda28209c3@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Fri, Nov 02, 2018 at 12:27:11PM +0000, Kieran Bingham wrote:
> Hi Niklas, Sakari
> 
> On 23/08/2018 14:25, Niklas Söderlund wrote:
> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  include/media/v4l2-subdev.h | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 5acaeeb9b3cacefa..ac1f7ee4cdb978ad 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -349,12 +349,21 @@ struct v4l2_mbus_frame_desc_entry {
> >  
> >  #define V4L2_FRAME_DESC_ENTRY_MAX	4
> >  
> > +enum {
> > +	V4L2_MBUS_FRAME_DESC_TYPE_PLATFORM,
> > +	V4L2_MBUS_FRAME_DESC_TYPE_PARALLEL,
> > +	V4L2_MBUS_FRAME_DESC_TYPE_CCP2,
> > +	V4L2_MBUS_FRAME_DESC_TYPE_CSI2,
> 
> Does this need to be extended to differentiate CSI2 DPHY/CPHY as has
> been done in the v4l2_mbus_config structures?

I'd say no; the PHY isn't really relevant at this level. The configuration
from fwnode should suffice.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
