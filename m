Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:13369 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab1L2Fw5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 00:52:57 -0500
Received: from epcpsbgm2.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LWY00FFMB060470@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Dec 2011 14:52:55 +0900 (KST)
Received: from NORIVERFULK04 ([165.213.219.118])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LWY00GW6B061HI0@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Thu, 29 Dec 2011 14:52:55 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
 <1325053428-2626-4-git-send-email-riverful.kim@samsung.com>
 <201112281456.51024.laurent.pinchart@ideasonboard.com>
In-reply-to: <201112281456.51024.laurent.pinchart@ideasonboard.com>
Subject: RE: [RFC PATCH 3/4] v4l: Add V4L2_CID_WDR button control
Date: Thu, 29 Dec 2011 14:52:55 +0900
Message-id: <001401ccc5ee$1c60dc60$55229520$%kim@samsung.com>
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
> Sent: Wednesday, December 28, 2011 10:57 PM
> To: HeungJun, Kim
> Cc: linux-media@vger.kernel.org; mchehab@redhat.com; hverkuil@xs4all.nl;
> sakari.ailus@iki.fi; s.nawrocki@samsung.com; kyungmin.park@samsung.com
> Subject: Re: [RFC PATCH 3/4] v4l: Add V4L2_CID_WDR button control
> 
> hi,
> 
> On Wednesday 28 December 2011 07:23:47 HeungJun, Kim wrote:
> > It adds the new CID for setting White Balance Preset. This CID is provided
> 
> I suppose you mean wide dynamic range here.
Right, it's my miss.

> 
> > as button type. This can commands only if the camera turn on/off this
> > function.
> 
> Shouldn't it be a boolean ? A button can only be activated, for one-shot auto-
> focus for instance.
Any type can be possible, and fine to me. But, it depends on the whole hardware
architecture. The WDR is proceeded and used only in the ISP or another engine
processing image. And, the cases I've seen ever, are just one - The ISP exists
in the sensor.

In M-5MOLS use-case, the ISP is in the M-5MOLS sensor. To the position of
developer,
it's just ok to turn on/off for using this. But, in the other architecture
it might be need more.

But, I anticipate if the other architecture use this function, probably
any other setting seems be not needed any more. The photographer just says,
"turn on the WDR!", not says "adjust parm 1, 2, 3, and turn on WDR!". :)

So, IMHO, I think the any other setting is not needed more for now.

> 
> > Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  Documentation/DocBook/media/v4l/controls.xml |   12 ++++++++++++
> >  drivers/media/video/v4l2-ctrls.c             |    2 ++
> >  include/linux/videodev2.h                    |    2 ++
> >  3 files changed, 16 insertions(+), 0 deletions(-)
> >
> > diff --git a/Documentation/DocBook/media/v4l/controls.xml
> > b/Documentation/DocBook/media/v4l/controls.xml index afe1845..bed6c66
> > 100644
> > --- a/Documentation/DocBook/media/v4l/controls.xml
> > +++ b/Documentation/DocBook/media/v4l/controls.xml
> > @@ -2958,6 +2958,18 @@ it one step further. This is a write-only
> > control.</entry> <row><entry></entry></row>
> >
> >  	  <row>
> > +	    <entry spanname="id"><constant>V4L2_CID_WDR</constant></entry>
> > +	    <entry>button</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry spanname="descr">Wide Dynamic Range. It makes
> > +	    the image be more clear by adjusting the image's intensity
> > +	    of the illumination. This function can be provided according to
> > +	    the capability of the hardware(sensor or AP's multimedia block).
> > +	    </entry>
> > +	  </row>
> > +
> > +	  <row>
> >  	    <entry
> > spanname="id"><constant>V4L2_CID_PRIVACY</constant>&nbsp;</entry>
> > <entry>boolean</entry>
> >  	  </row><row><entry spanname="descr">Prevent video from being acquired
> > diff --git a/drivers/media/video/v4l2-ctrls.c
> > b/drivers/media/video/v4l2-ctrls.c index fef58c2..66110bc 100644
> > --- a/drivers/media/video/v4l2-ctrls.c
> > +++ b/drivers/media/video/v4l2-ctrls.c
> > @@ -598,6 +598,7 @@ const char *v4l2_ctrl_get_name(u32 id)
> >  	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
> >  	case V4L2_CID_PRESET_WHITE_BALANCE:	return "White Balance, Preset";
> >  	case V4L2_CID_SCENEMODE:		return "Scenemode";
> > +	case V4L2_CID_WDR:			return "Wide Dynamic Range";
> >
> >  	/* FM Radio Modulator control */
> >  	/* Keep the order of the 'case's the same as in videodev2.h! */
> > @@ -687,6 +688,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> > v4l2_ctrl_type *type, break;
> >  	case V4L2_CID_PAN_RESET:
> >  	case V4L2_CID_TILT_RESET:
> > +	case V4L2_CID_WDR:
> >  	case V4L2_CID_FLASH_STROBE:
> >  	case V4L2_CID_FLASH_STROBE_STOP:
> >  		*type = V4L2_CTRL_TYPE_BUTTON;
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index bc14feb..f85ad6c 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -1646,6 +1646,8 @@ enum v4l2_scenemode {
> >  	V4L2_SCENEMODE_CANDLE = 14,
> >  };
> >
> > +#define V4L2_CID_WDR
(V4L2_CID_CAMERA_CLASS_BASE+21)
> > +
> >  /* FM Modulator class control IDs */
> >  #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
> >  #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX |
1)
> 
> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

