Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:41380 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab1L2F5c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 00:57:32 -0500
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LWY00HORB6WZ2B0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Dec 2011 14:57:15 +0900 (KST)
Received: from NORIVERFULK04 ([165.213.219.118])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LWY00IH5B7FFB60@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Thu, 29 Dec 2011 14:57:15 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
 <1325053428-2626-5-git-send-email-riverful.kim@samsung.com>
 <201112281458.29992.laurent.pinchart@ideasonboard.com>
In-reply-to: <201112281458.29992.laurent.pinchart@ideasonboard.com>
Subject: RE: [RFC PATCH 4/4] v4l: Add V4L2_CID_ANTISHAKE button control
Date: Thu, 29 Dec 2011 14:57:15 +0900
Message-id: <001501ccc5ee$b7617e90$26247bb0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Wednesday, December 28, 2011 10:58 PM
> To: HeungJun, Kim
> Cc: linux-media@vger.kernel.org; mchehab@redhat.com; hverkuil@xs4all.nl;
> sakari.ailus@iki.fi; s.nawrocki@samsung.com; kyungmin.park@samsung.com
> Subject: Re: [RFC PATCH 4/4] v4l: Add V4L2_CID_ANTISHAKE button control
> 
> Hi,
> 
> On Wednesday 28 December 2011 07:23:48 HeungJun, Kim wrote:
> > It adds the new CID for setting Anti-shake. This CID is provided as
> > button type. This can commands only if the camera turn on/off this
> > function.
> 
> Shouldn't it be a boolean control ?
It's also similar case with WDR. Yes, for now, I've never seen this function
needs more modes or settings. On status of turning on, the image can be
compensated shaking and blurring.

> 
> > Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  Documentation/DocBook/media/v4l/controls.xml |   11 +++++++++++
> >  drivers/media/video/v4l2-ctrls.c             |    2 ++
> >  include/linux/videodev2.h                    |    1 +
> >  3 files changed, 14 insertions(+), 0 deletions(-)
> >
> > diff --git a/Documentation/DocBook/media/v4l/controls.xml
> > b/Documentation/DocBook/media/v4l/controls.xml index bed6c66..73ff05c
> > 100644
> > --- a/Documentation/DocBook/media/v4l/controls.xml
> > +++ b/Documentation/DocBook/media/v4l/controls.xml
> > @@ -2970,6 +2970,17 @@ it one step further. This is a write-only
> > control.</entry> </row>
> >
> >  	  <row>
> > +	    <entry spanname="id"><constant>V4L2_CID_ANTISHAKE</constant></entry>
> > +	    <entry>button</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="descr">Anti-Shake. It makes
> > +	    the image be more stabilized from the image's shakeness.
> > +	    This function can be provided according to the capability
> > +	    of the hardware(sensor or AP's multimedia block).</entry>
> 
> Isn't this usually called image (or video) stabilization ? What stabilization
> techniques does this control cover ?
> 
> > +	  </row>
> > +
> > +	  <row>
> >  	    <entry
> > spanname="id"><constant>V4L2_CID_PRIVACY</constant>&nbsp;</entry>
> > <entry>boolean</entry>
> >  	  </row><row><entry spanname="descr">Prevent video from being acquired
> > diff --git a/drivers/media/video/v4l2-ctrls.c
> > b/drivers/media/video/v4l2-ctrls.c index 66110bc..05ff6bb 100644
> > --- a/drivers/media/video/v4l2-ctrls.c
> > +++ b/drivers/media/video/v4l2-ctrls.c
> > @@ -599,6 +599,7 @@ const char *v4l2_ctrl_get_name(u32 id)
> >  	case V4L2_CID_PRESET_WHITE_BALANCE:	return "White Balance, Preset";
> >  	case V4L2_CID_SCENEMODE:		return "Scenemode";
> >  	case V4L2_CID_WDR:			return "Wide Dynamic Range";
> > +	case V4L2_CID_ANTISHAKE:		return "Antishake";
> >
> >  	/* FM Radio Modulator control */
> >  	/* Keep the order of the 'case's the same as in videodev2.h! */
> > @@ -689,6 +690,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> > v4l2_ctrl_type *type, case V4L2_CID_PAN_RESET:
> >  	case V4L2_CID_TILT_RESET:
> >  	case V4L2_CID_WDR:
> > +	case V4L2_CID_ANTISHAKE:
> >  	case V4L2_CID_FLASH_STROBE:
> >  	case V4L2_CID_FLASH_STROBE_STOP:
> >  		*type = V4L2_CTRL_TYPE_BUTTON;
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index f85ad6c..ddd775f 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -1647,6 +1647,7 @@ enum v4l2_scenemode {
> >  };
> >
> >  #define V4L2_CID_WDR
(V4L2_CID_CAMERA_CLASS_BASE+21)
> > +#define V4L2_CID_ANTISHAKE			(V4L2_CID_CAMERA_CLASS_BASE+22)
> >
> >  /* FM Modulator class control IDs */
> >  #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
> 
> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

