Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:49665 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbeK3KTa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 05:19:30 -0500
From: "Zhi, Yong" <yong.zhi@intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: RE: [PATCH v7 01/16] v4l: Add Intel IPU3 meta buffer formats
Date: Thu, 29 Nov 2018 23:12:19 +0000
Message-ID: <C193D76D23A22742993887E6D207B54D3DB335DD@ORSMSX106.amr.corp.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
 <1540851790-1777-2-git-send-email-yong.zhi@intel.com>
 <3858085.x2vJft3ZLq@avalon>
In-Reply-To: <3858085.x2vJft3ZLq@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Laurent,

Thanks for the review.

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Thursday, November 29, 2018 1:17 PM
> To: Zhi, Yong <yong.zhi@intel.com>
> Cc: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com;
> tfiga@chromium.org; mchehab@kernel.org; hans.verkuil@cisco.com; Mani,
> Rajmohan <rajmohan.mani@intel.com>; Zheng, Jian Xu
> <jian.xu.zheng@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>; Toivonen,
> Tuukka <tuukka.toivonen@intel.com>; Qiu, Tian Shu
> <tian.shu.qiu@intel.com>; Cao, Bingbu <bingbu.cao@intel.com>
> Subject: Re: [PATCH v7 01/16] v4l: Add Intel IPU3 meta buffer formats
> 
> Hello Yong,
> 
> Thank you for the patch.
> 
> On Tuesday, 30 October 2018 00:22:55 EET Yong Zhi wrote:
> > Add IPU3-specific meta formats for parameter processing and 3A, DVS
> > statistics:
> 
> Unless I'm mistaken DVS support has been removed. You can write this as
> 
> Add IPU3-specific meta formats for processing parameters and 3A statistics.
> 

Ack.

> >
> >   V4L2_META_FMT_IPU3_PARAMS
> >   V4L2_META_FMT_IPU3_STAT_3A
> >
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> > ---
> >  drivers/media/v4l2-core/v4l2-ioctl.c | 2 ++
> >  include/uapi/linux/videodev2.h       | 4 ++++
> >  2 files changed, 6 insertions(+)
> 
> I would squash this with patch 03/16.
> 

OK, will squash patch 01 and 03 into single patch for v8.

> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> > b/drivers/media/v4l2-core/v4l2-ioctl.c index 6489f25..abff64b 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > @@ -1299,6 +1299,8 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc
> *fmt)
> > case V4L2_META_FMT_VSP1_HGO:	descr = "R-Car VSP1 1-D Histogram";
> break;
> > case V4L2_META_FMT_VSP1_HGT:	descr = "R-Car VSP1 2-D Histogram";
> break;
> > case V4L2_META_FMT_UVC:		descr = "UVC payload header
> metadata"; break;
> > +	case V4L2_META_FMT_IPU3_PARAMS:	descr = "IPU3 processing
> parameters";
> > break;
> > +	case V4L2_META_FMT_IPU3_STAT_3A:	descr = "IPU3 3A statistics";
> break;
> >
> >  	default:
> >  		/* Compressed formats */
> > diff --git a/include/uapi/linux/videodev2.h
> > b/include/uapi/linux/videodev2.h index f0a968a..bdccd7a 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -718,6 +718,10 @@ struct v4l2_pix_format {
> >  #define V4L2_META_FMT_UVC         v4l2_fourcc('U', 'V', 'C', 'H') /* UVC
> > Payload Header metadata */ #define V4L2_META_FMT_D4XX
> > v4l2_fourcc('D', '4', 'X', 'X') /* D4XX Payload Header metadata */
> >
> > +/* Vendor specific - used for IPU3 camera sub-system */
> > +#define V4L2_META_FMT_IPU3_PARAMS	v4l2_fourcc('i', 'p', '3', 'p') /*
> IPU3
> > params */
> 
> Maybe "IPU3 processing parameters" in full ?
> 

Ack, thanks!!

> Apart from that the patch looks good to me.
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> > +#define V4L2_META_FMT_IPU3_STAT_3A	v4l2_fourcc('i', 'p', '3', 's') /*
> IPU3
> > 3A statistics */
> > +
> >  /* priv field value to indicates that subsequent fields are valid. */
> >  #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe
> 
> 
> --
> Regards,
> 
> Laurent Pinchart
> 
> 
