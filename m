Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CF6C282C5
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C18E8217D8
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 15:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbfAVP5Y (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:57:24 -0500
Received: from mga12.intel.com ([192.55.52.136]:43271 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728756AbfAVP5Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 10:57:24 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Jan 2019 07:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,507,1539673200"; 
   d="scan'208";a="140328982"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga001.fm.intel.com with ESMTP; 22 Jan 2019 07:57:14 -0800
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id A6DB7205C8; Tue, 22 Jan 2019 17:57:13 +0200 (EET)
Date:   Tue, 22 Jan 2019 17:57:13 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 17/30] v4l: subdev: compat: Implement handling for
 VIDIOC_SUBDEV_[GS]_ROUTING
Message-ID: <20190122155713.pgylzmpzsmv2rdub@paasikivi.fi.intel.com>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
 <20181101233144.31507-18-niklas.soderlund+renesas@ragnatech.se>
 <20190115235303.GG31088@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190115235303.GG31088@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 16, 2019 at 01:53:03AM +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Fri, Nov 02, 2018 at 12:31:31AM +0100, Niklas Söderlund wrote:
> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> > 
> > Implement compat IOCTL handling for VIDIOC_SUBDEV_G_ROUTING and
> > VIDIOC_SUBDEV_S_ROUTING IOCTLs.
> 
> Let's instead design the ioctl in a way that doesn't require compat
> handling.

Yeah, I wrote the patch back then when the practice hadn't changed yes. I
agree.

> 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 77 +++++++++++++++++++
> >  1 file changed, 77 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > index 6481212fda772c73..83af332763f41a6b 100644
> > --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > @@ -1045,6 +1045,66 @@ static int put_v4l2_event32(struct v4l2_event __user *p64,
> >  	return 0;
> >  }
> >  
> > +struct v4l2_subdev_routing32 {
> > +	compat_caddr_t routes;
> > +	__u32 num_routes;
> > +	__u32 reserved[5];
> > +};
> > +
> > +static int get_v4l2_subdev_routing(struct v4l2_subdev_routing __user *p64,
> > +				   struct v4l2_subdev_routing32 __user *p32)
> > +{
> > +	struct v4l2_subdev_route __user *routes;
> > +	compat_caddr_t p;
> > +	u32 num_routes;
> > +
> > +	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
> > +	    get_user(p, &p32->routes) ||
> > +	    get_user(num_routes, &p32->num_routes) ||
> > +	    put_user(num_routes, &p64->num_routes) ||
> > +	    copy_in_user(&p64->reserved, &p32->reserved,
> > +			 sizeof(p64->reserved)) ||
> > +	    num_routes > U32_MAX / sizeof(*p64->routes))
> > +		return -EFAULT;
> > +
> > +	routes = compat_ptr(p);
> > +
> > +	if (!access_ok(VERIFY_READ, routes,
> > +		       num_routes * sizeof(*p64->routes)))
> > +		return -EFAULT;
> > +
> > +	if (put_user((__force struct v4l2_subdev_route *)routes,
> > +		     &p64->routes))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> > +
> > +static int put_v4l2_subdev_routing(struct v4l2_subdev_routing __user *p64,
> > +				   struct v4l2_subdev_routing32 __user *p32)
> > +{
> > +	struct v4l2_subdev_route __user *routes;
> > +	compat_caddr_t p;
> > +	u32 num_routes;
> > +
> > +	if (!access_ok(VERIFY_WRITE, p32, sizeof(*p32)) ||
> > +	    get_user(p, &p32->routes) ||
> > +	    get_user(num_routes, &p64->num_routes) ||
> > +	    put_user(num_routes, &p32->num_routes) ||
> > +	    copy_in_user(&p32->reserved, &p64->reserved,
> > +			 sizeof(p64->reserved)) ||
> > +	    num_routes > U32_MAX / sizeof(*p64->routes))
> > +		return -EFAULT;
> > +
> > +	routes = compat_ptr(p);
> > +
> > +	if (!access_ok(VERIFY_WRITE, routes,
> > +		       num_routes * sizeof(*p64->routes)))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> > +
> >  struct v4l2_edid32 {
> >  	__u32 pad;
> >  	__u32 start_block;
> > @@ -1117,6 +1177,8 @@ static int put_v4l2_edid32(struct v4l2_edid __user *p64,
> >  #define VIDIOC_STREAMOFF32	_IOW ('V', 19, s32)
> >  #define VIDIOC_G_INPUT32	_IOR ('V', 38, s32)
> >  #define VIDIOC_S_INPUT32	_IOWR('V', 39, s32)
> > +#define VIDIOC_SUBDEV_G_ROUTING32 _IOWR('V', 38, struct v4l2_subdev_routing32)
> > +#define VIDIOC_SUBDEV_S_ROUTING32 _IOWR('V', 39, struct v4l2_subdev_routing32)
> >  #define VIDIOC_G_OUTPUT32	_IOR ('V', 46, s32)
> >  #define VIDIOC_S_OUTPUT32	_IOWR('V', 47, s32)
> >  
> > @@ -1195,6 +1257,8 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
> >  	case VIDIOC_STREAMOFF32: cmd = VIDIOC_STREAMOFF; break;
> >  	case VIDIOC_G_INPUT32: cmd = VIDIOC_G_INPUT; break;
> >  	case VIDIOC_S_INPUT32: cmd = VIDIOC_S_INPUT; break;
> > +	case VIDIOC_SUBDEV_G_ROUTING32: cmd = VIDIOC_SUBDEV_G_ROUTING; break;
> > +	case VIDIOC_SUBDEV_S_ROUTING32: cmd = VIDIOC_SUBDEV_S_ROUTING; break;
> >  	case VIDIOC_G_OUTPUT32: cmd = VIDIOC_G_OUTPUT; break;
> >  	case VIDIOC_S_OUTPUT32: cmd = VIDIOC_S_OUTPUT; break;
> >  	case VIDIOC_CREATE_BUFS32: cmd = VIDIOC_CREATE_BUFS; break;
> > @@ -1227,6 +1291,15 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
> >  		compatible_arg = 0;
> >  		break;
> >  
> > +	case VIDIOC_SUBDEV_G_ROUTING:
> > +	case VIDIOC_SUBDEV_S_ROUTING:
> > +		err = alloc_userspace(sizeof(struct v4l2_subdev_routing),
> > +				      0, &new_p64);
> > +		if (!err)
> > +			err = get_v4l2_subdev_routing(new_p64, p32);
> > +		compatible_arg = 0;
> > +		break;
> > +
> >  	case VIDIOC_G_EDID:
> >  	case VIDIOC_S_EDID:
> >  		err = alloc_userspace(sizeof(struct v4l2_edid), 0, &new_p64);
> > @@ -1368,6 +1441,10 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
> >  		if (put_v4l2_edid32(new_p64, p32))
> >  			err = -EFAULT;
> >  		break;
> > +	case VIDIOC_SUBDEV_G_ROUTING:
> > +	case VIDIOC_SUBDEV_S_ROUTING:
> > +		err = put_v4l2_subdev_routing(new_p64, p32);
> > +		break;
> >  	}
> >  	if (err)
> >  		return err;
> 
> -- 
> Regards,
> 
> Laurent Pinchart

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
