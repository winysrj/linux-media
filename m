Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:39013 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab1L2Fk7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Dec 2011 00:40:59 -0500
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LWY00K6IAG82HC0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 Dec 2011 14:40:58 +0900 (KST)
Received: from NORIVERFULK04 ([165.213.219.118])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LWY00I8EAG9FB20@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Thu, 29 Dec 2011 14:40:57 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
 <1325053428-2626-3-git-send-email-riverful.kim@samsung.com>
 <201112281456.05515.laurent.pinchart@ideasonboard.com>
In-reply-to: <201112281456.05515.laurent.pinchart@ideasonboard.com>
Subject: RE: [RFC PATCH 2/4] v4l: Add V4L2_CID_SCENEMODE menu control
Date: Thu, 29 Dec 2011 14:40:57 +0900
Message-id: <001201ccc5ec$709ca6d0$51d5f470$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Laurent Pinchart
> Sent: Wednesday, December 28, 2011 10:56 PM
> To: HeungJun, Kim
> Cc: linux-media@vger.kernel.org; mchehab@redhat.com; hverkuil@xs4all.nl;
> sakari.ailus@iki.fi; s.nawrocki@samsung.com; kyungmin.park@samsung.com
> Subject: Re: [RFC PATCH 2/4] v4l: Add V4L2_CID_SCENEMODE menu control
> 
> Hi,
> 
> On Wednesday 28 December 2011 07:23:46 HeungJun, Kim wrote:
> > It adds the new CID for setting Scenemode. This CID is provided as
> > menu type using the following items:
> > enum v4l2_scenemode {
> > 	V4L2_SCENEMODE_NONE = 0,
> > 	V4L2_SCENEMODE_NORMAL = 1,
> > 	V4L2_SCENEMODE_PORTRAIT = 2,
> > 	V4L2_SCENEMODE_LANDSCAPE = 3,
> > 	V4L2_SCENEMODE_SPORTS = 4,
> > 	V4L2_SCENEMODE_PARTY_INDOOR = 5,
> > 	V4L2_SCENEMODE_BEACH_SNOW = 6,
> > 	V4L2_SCENEMODE_SUNSET = 7,
> > 	V4L2_SCENEMODE_DAWN_DUSK = 8,
> > 	V4L2_SCENEMODE_FALL = 9,
> > 	V4L2_SCENEMODE_NIGHT = 10,
> > 	V4L2_SCENEMODE_AGAINST_LIGHT = 11,
> > 	V4L2_SCENEMODE_FIRE = 12,
> > 	V4L2_SCENEMODE_TEXT = 13,
> > 	V4L2_SCENEMODE_CANDLE = 14,
> > };
> >
> > Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  Documentation/DocBook/media/v4l/controls.xml |   88
> > ++++++++++++++++++++++++++ drivers/media/video/v4l2-ctrls.c             |
> >  21 ++++++
> >  include/linux/videodev2.h                    |   19 ++++++
> >  3 files changed, 128 insertions(+), 0 deletions(-)
> >
> > diff --git a/Documentation/DocBook/media/v4l/controls.xml
> > b/Documentation/DocBook/media/v4l/controls.xml index 350c138..afe1845
> > 100644
> > --- a/Documentation/DocBook/media/v4l/controls.xml
> > +++ b/Documentation/DocBook/media/v4l/controls.xml
> > @@ -2879,6 +2879,94 @@ it one step further. This is a write-only
> > control.</entry> </row>
> >  	  <row><entry></entry></row>
> >
> > +	  <row id="v4l2-scenemode">
> > +	    <entry
> > spanname="id"><constant>V4L2_CID_SCENEMODE</constant>&nbsp;</entry> +
> > <entry>enum&nbsp;v4l2_scenemode</entry>
> > +	  </row><row><entry spanname="descr">This control sets
> > +	  the camera's scenemode, and it is provided by the type of
> > +	  the enum values. The "None" mode means the status
> > +	  when scenemode algorithm is not activated, like after booting time.
> > +	  On the other hand, the "Normal" mode means the scenemode algorithm
> > +	  is activated on the normal mode.</entry>
> 
> What low-level parameters do the scene mode control ? How does it interact
> with the related controls ?
For using this control, in M-5MOLS sensor case, several register is configured,
like Exposure(locking/Indexed preset/mode), Focus(locking), WhiteBalance, etc.
And I think the process interacting and syncing the register's value should be
up to the each drivers, and the m5mols driver will be.

Anyways, could you explain the difference with low- and high- in more details?
:)
I still did not understand well.

> 
> > +	  </row>
> > +	  <row>
> > +	    <entrytbl spanname="descr" cols="2">
> > +	      <tbody valign="top">
> > +		<row>
> > +		  <entry><constant>V4L2_SCENEMODE_NONE</constant>&nbsp;</entry>
> > +		  <entry>Scenemode None.</entry>
> > +		</row>
> > +		<row>
> > +
<entry><constant>V4L2_SCENEMODE_NORMAL</constant>&nbsp;</entry>
> > +		  <entry>Scenemode Normal.</entry>
> > +		</row>
> > +		<row>
> > +
> <entry><constant>V4L2_SCENEMODE_PORTRAIT</constant>&nbsp;</entry>
> > +		  <entry>Scenemode Portrait.</entry>
> 
> Could you please describe the scene modes in more details ?
Yes, the photographer should adjust the exposure(luminance), focus, iso, etc,
for getting better image according to each specific circumstances.
But, it's uncomfortable to set all controls at every time.
The scene mode can make this at one time. It is just not only setting once.
According to fixed scene circumstance, the internal algorithm is also
needed for it. 

This function is usually provided as just preset, but, it's not just preset,
because the specific algorithm is existed for "scene mode",
except the collection of the camera control preset.

The enumeration I suggest, can cover almost scene mode. Of course, the term
is fixed. The M-5MOLS can use all the scene mode.
Please, see drivers/media/video/m5mols/m5mols_contro.c.

> 
> > +		</row>
> > +		<row>
> > +
> <entry><constant>V4L2_SCENEMODE_LANDSCAPE</constant>&nbsp;</entry>
> > +		  <entry>Scenemode Landscape.</entry>
> > +		</row>
> > +		<row>
> > +
<entry><constant>V4L2_SCENEMODE_SPORTS</constant>&nbsp;</entry>
> > +		  <entry>Scenemode Sports.</entry>
> > +		</row>
> > +		<row>
> > +
> <entry><constant>V4L2_SCENEMODE_PARTY_INDOOR</constant>&nbsp;</entry>
> > +		  <entry>Scenemode Party Indoor.</entry>
> > +		</row>
> > +		<row>
> > +
> <entry><constant>V4L2_SCENEMODE_BEACH_SNOW</constant>&nbsp;</entry>
> > +		  <entry>Scenemode Beach Snow.</entry>
> > +		</row>
> > +		<row>
> > +
<entry><constant>V4L2_SCENEMODE_SUNSET</constant>&nbsp;</entry>
> > +		  <entry>Scenemode Beach Snow.</entry>
> > +		</row>
> > +		<row>
> > +
> <entry><constant>V4L2_SCENEMODE_DAWN_DUSK</constant>&nbsp;</entry>
> > +		  <entry>Scenemode Dawn Dusk.</entry>
> > +		</row>
> > +		<row>
> > +		  <entry><constant>V4L2_SCENEMODE_FALL</constant>&nbsp;</entry>
> > +		  <entry>Scenemode Fall.</entry>
> > +		</row>
> > +		<row>
> > +		  <entry><constant>V4L2_SCENEMODE_NIGHT</constant>&nbsp;</entry>
> > +		  <entry>Scenemode Night.</entry>
> > +		</row>
> > +		<row>
> > +
> <entry><constant>V4L2_SCENEMODE_AGAINST_LIGHT</constant>&nbsp;</entry>
> > +		  <entry>Scenemode Against Light.</entry>
> > +		</row>
> > +		<row>
> > +		  <entry><constant>V4L2_SCENEMODE_FIRE</constant>&nbsp;</entry>
> > +		  <entry>Scenemode Fire.</entry>
> > +		</row>
> > +		<row>
> > +		  <entry><constant>V4L2_SCENEMODE_TEXT</constant>&nbsp;</entry>
> > +		  <entry>Scenemode Text.</entry>
> > +		</row>
> > +		<row>
> > +
<entry><constant>V4L2_SCENEMODE_CANDLE</constant>&nbsp;</entry>
> > +		  <entry>Scenemode Candle.</entry>
> > +		</row>
> > +	      </tbody>
> > +	    </entrytbl>
> > +	  </row>
> > +	  <row><entry></entry></row>
> > +
> > +	  <row>
> > +	    <entry
> > spanname="id"><constant>V4L2_CID_PRIVACY</constant>&nbsp;</entry> +
> > <entry>boolean</entry>
> > +	  </row><row><entry spanname="descr">Prevent video from being acquired
> > +by the camera. When this control is set to <constant>TRUE</constant> (1),
> > no +image can be captured by the camera. Common means to enforce privacy
> > are +mechanical obturation of the sensor and firmware image processing,
> > but the +device is not restricted to these methods. Devices that implement
> > the privacy +control must support read access and may support write
> > access.</entry> +	  </row>
> >  	  <row>
> >  	    <entry
> > spanname="id"><constant>V4L2_CID_PRIVACY</constant>&nbsp;</entry>
> > <entry>boolean</entry>
> 
> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

