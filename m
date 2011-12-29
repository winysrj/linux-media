Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:53124 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1L2EGN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Dec 2011 23:06:13 -0500
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LWY00H8J62BHO00@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Dec 2011 13:06:11 +0900 (KST)
Received: from NORIVERFULK04 ([165.213.219.118])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LWY00FX262B2070@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Thu, 29 Dec 2011 13:06:11 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: 'Sylwester Nawrocki' <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	'Hans de Goede' <hdegoede@redhat.com>
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
 <1325053428-2626-2-git-send-email-riverful.kim@samsung.com>
 <4EFB1B04.6060305@gmail.com>
In-reply-to: <4EFB1B04.6060305@gmail.com>
Subject: RE: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu control
Date: Thu, 29 Dec 2011 13:06:11 +0900
Message-id: <001001ccc5df$333baeb0$99b30c10$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

I'll continue this conversation to the Laurent's reply.
So, please check the others.

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sylwester Nawrocki
> Sent: Wednesday, December 28, 2011 10:35 PM
> To: HeungJun, Kim
> Cc: linux-media@vger.kernel.org; mchehab@redhat.com; hverkuil@xs4all.nl;
> sakari.ailus@iki.fi; laurent.pinchart@ideasonboard.com;
> kyungmin.park@samsung.com; Hans de Goede
> Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu
> control
> 
> Hi,
> 
> On 12/28/2011 07:23 AM, HeungJun, Kim wrote:
> > It adds the new CID for setting White Balance Preset. This CID is provided as
> > menu type using the following items:
> > 0 - V4L2_WHITE_BALANCE_INCANDESCENT,
> > 1 - V4L2_WHITE_BALANCE_FLUORESCENT,
> > 2 - V4L2_WHITE_BALANCE_DAYLIGHT,
> > 3 - V4L2_WHITE_BALANCE_CLOUDY,
> > 4 - V4L2_WHITE_BALANCE_SHADE,
> 
> I have been also investigating those white balance presets recently and noticed
> they're also needed for the pwc driver. Looking at
> drivers/media/video/pwc/pwc-v4l2.c there is something like:
> 
> const char * const pwc_auto_whitebal_qmenu[] = {
> 	"Indoor (Incandescant Lighting) Mode",
> 	"Outdoor (Sunlight) Mode",
> 	"Indoor (Fluorescent Lighting) Mode",
> 	"Manual Mode",
> 	"Auto Mode",
> 	NULL
> };
> 
> static const struct v4l2_ctrl_config pwc_auto_white_balance_cfg = {
> 	.ops	= &pwc_ctrl_ops,
> 	.id	= V4L2_CID_AUTO_WHITE_BALANCE,
> 	.type	= V4L2_CTRL_TYPE_MENU,
> 	.max	= awb_auto,
> 	.qmenu	= pwc_auto_whitebal_qmenu,
> };
> 
> ...
> 
> 	cfg = pwc_auto_white_balance_cfg;
> 	cfg.name = v4l2_ctrl_get_name(cfg.id);
> 	cfg.def = def;
> 	pdev->auto_white_balance = v4l2_ctrl_new_custom(hdl, &cfg, NULL);
> 
> So this driver re-defines V4L2_CID_AUTO_WHITE_BALANCE as a menu control
> with custom entries. That's interesting... However it works in practice
> and applications have access to what's provided by hardware.
> Perhaps V4L2_CID_AUTO_WHITE_BALANCE_TEMPERATURE would be a better fit for
> that :)
> 
> Nevertheless, redefining standard controls in particular drivers sounds
> a little dubious. I wonder if this is a generally agreed approach ?
> 
> Then, how does your V4L2_CID_PRESET_WHITE_BALANCE control interact with
> V4L2_CID_AUTO_WHITE_BALANCE control ? Does V4L2_CID_AUTO_WHITE_BALANCE need
> to be set to false for V4L2_CID_PRESET_WHITE_BALANCE to be effective ?
> 
> > Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  Documentation/DocBook/media/v4l/controls.xml |   38
> ++++++++++++++++++++++++++
> >  drivers/media/video/v4l2-ctrls.c             |   12 ++++++++
> >  include/linux/videodev2.h                    |    9 ++++++
> >  3 files changed, 59 insertions(+), 0 deletions(-)
> >
> > diff --git a/Documentation/DocBook/media/v4l/controls.xml
> b/Documentation/DocBook/media/v4l/controls.xml
> > index c0422c6..350c138 100644
> > --- a/Documentation/DocBook/media/v4l/controls.xml
> > +++ b/Documentation/DocBook/media/v4l/controls.xml
> > @@ -2841,6 +2841,44 @@ it one step further. This is a write-only
> control.</entry>
> >  	  </row>
> >  	  <row><entry></entry></row>
> >
> > +	  <row id="v4l2-preset-white-balance">
> > +	    <entry
> spanname="id"><constant>V4L2_CID_PRESET_WHITE_BALANCE</constant>&nbsp;</entry>
> 
> Wouldn't V4L2_CID_WHITE_BALANCE_PRESET be better ?
> 
> > +	    <entry>enum&nbsp;v4l2_preset_white_balance</entry>
> > +	  </row><row><entry spanname="descr">This control sets
> > +	  the camera's white balance by the presets. These preset is provided
> > +	  by the type of the enum values which are generally provided
> > +	  by several digital cameras. But, it dosen't mean that the specific
> 
> s/dosent'/doesn't
> 
> > +	  preset always can be counterposed with the unique white balance value.
> > +	  This is a read/write control.</entry>
> 
> We probably only need such a remark if a control is read-only or write-only.
> 
> > +	  </row>
> > +	  <row>
> > +	    <entrytbl spanname="descr" cols="2">
> > +	      <tbody valign="top">
> > +		<row>
> > +
> <entry><constant>V4L2_WHITE_BALANCE_INCANDESCENT</constant>&nbsp;</entry>
> > +		  <entry>White Balance Incandescent/Tungster preset.</entry>
> 
> s/Tungster/Tungsten
> 
> If we are to have these presets, then we need to be a little bit more verbose
> about what they mean. To avoid situation similar to V4L2_CID_COLORFX control
> where nobody knows exactly what's an exact meaning of the menu items.
> 
> > +		</row>
> > +		<row>
> > +
> <entry><constant>V4L2_WHITE_BALANCE_FLUORESCENT</constant>&nbsp;</entry>
> > +		  <entry>White Balance Fluorescent preset.</entry>
> > +		</row>
> > +		<row>
> > +
> <entry><constant>V4L2_WHITE_BALANCE_DAYLIGHT</constant>&nbsp;</entry>
> > +		  <entry>White Balance Daylight preset.</entry>
> > +		</row>
> > +		<row>
> > +
> <entry><constant>V4L2_WHITE_BALANCE_CLOUDY</constant>&nbsp;</entry>
> > +		  <entry>White Balance Cloudy preset.</entry>
> > +		</row>
> > +		<row>
> > +
> <entry><constant>V4L2_WHITE_BALANCE_SHADE</constant>&nbsp;</entry>
> > +		  <entry>White Balance Share preset.</entry>
> 
> s/Share/Shade
> 
> > +		</row>
> > +	      </tbody>
> > +	    </entrytbl>
> > +	  </row>
> > +	  <row><entry></entry></row>
> > +
> >  	  <row>
> >  	    <entry
> spanname="id"><constant>V4L2_CID_PRIVACY</constant>&nbsp;</entry>
> >  	    <entry>boolean</entry>
> > diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-
> ctrls.c
> > index 0f415da..f51b576 100644
> > --- a/drivers/media/video/v4l2-ctrls.c
> > +++ b/drivers/media/video/v4l2-ctrls.c
> > @@ -234,6 +234,14 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
> >  		"Vivid",
> >  		NULL
> >  	};
> > +	static const char * const preset_white_balance[] = {
> > +		"Incandescent",
> > +		"Fluorescent",
> > +		"Daylight",
> > +		"Cloudy",
> > +		"Shade",
> > +		NULL,
> > +	};
> >  	static const char * const tune_preemphasis[] = {
> >  		"No Preemphasis",
> >  		"50 useconds",
> > @@ -390,6 +398,8 @@ const char * const *v4l2_ctrl_get_menu(u32 id)
> >  		return camera_exposure_auto;
> >  	case V4L2_CID_COLORFX:
> >  		return colorfx;
> > +	case V4L2_CID_PRESET_WHITE_BALANCE:
> > +		return preset_white_balance;
> >  	case V4L2_CID_TUNE_PREEMPHASIS:
> >  		return tune_preemphasis;
> >  	case V4L2_CID_FLASH_LED_MODE:
> > @@ -567,6 +577,7 @@ const char *v4l2_ctrl_get_name(u32 id)
> >  	case V4L2_CID_PRIVACY:			return "Privacy";
> >  	case V4L2_CID_IRIS_ABSOLUTE:		return "Iris, Absolute";
> >  	case V4L2_CID_IRIS_RELATIVE:		return "Iris, Relative";
> > +	case V4L2_CID_PRESET_WHITE_BALANCE:	return "White Balance, Preset";
> >
> >  	/* FM Radio Modulator control */
> >  	/* Keep the order of the 'case's the same as in videodev2.h! */
> > @@ -680,6 +691,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
> v4l2_ctrl_type *type,
> >  	case V4L2_CID_MPEG_STREAM_VBI_FMT:
> >  	case V4L2_CID_EXPOSURE_AUTO:
> >  	case V4L2_CID_COLORFX:
> > +	case V4L2_CID_PRESET_WHITE_BALANCE:
> >  	case V4L2_CID_TUNE_PREEMPHASIS:
> >  	case V4L2_CID_FLASH_LED_MODE:
> >  	case V4L2_CID_FLASH_STROBE_SOURCE:
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index 3d62631..a842de0 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -1618,6 +1618,15 @@ enum  v4l2_exposure_auto_type {
> >  #define V4L2_CID_IRIS_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+17)
> >  #define V4L2_CID_IRIS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+18)
> >
> > +#define V4L2_CID_PRESET_WHITE_BALANCE		(V4L2_CID_CAMERA_CLASS_BASE+19)
> > +enum v4l2_preset_white_balance {
> > +	V4L2_WHITE_BALANCE_INCANDESCENT = 0,
> > +	V4L2_WHITE_BALANCE_FLUORESCENT = 1,
> > +	V4L2_WHITE_BALANCE_DAYLIGHT = 2,
> > +	V4L2_WHITE_BALANCE_CLOUDY = 3,
> > +	V4L2_WHITE_BALANCE_SHADE = 4,
> > +};
> > +
> >  /* FM Modulator class control IDs */
> >  #define V4L2_CID_FM_TX_CLASS_BASE		(V4L2_CTRL_CLASS_FM_TX | 0x900)
> >  #define V4L2_CID_FM_TX_CLASS			(V4L2_CTRL_CLASS_FM_TX | 1)
> 
> --
> 
> Thanks,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

