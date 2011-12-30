Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:46232 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1L3FbF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 00:31:05 -0500
Received: from epcpsbgm1.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LX0006IZ4NFKBJ0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 30 Dec 2011 14:31:03 +0900 (KST)
Received: from NORIVERFULK04 ([165.213.219.118])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LX0006NQ4NRBQ40@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Fri, 30 Dec 2011 14:31:03 +0900 (KST)
From: "HeungJun, Kim" <riverful.kim@samsung.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	kyungmin.park@samsung.com
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com>
 <201112281456.05515.laurent.pinchart@ideasonboard.com>
 <001201ccc5ec$709ca6d0$51d5f470$%kim@samsung.com>
 <201112300111.09581.laurent.pinchart@ideasonboard.com>
In-reply-to: <201112300111.09581.laurent.pinchart@ideasonboard.com>
Subject: RE: [RFC PATCH 2/4] v4l: Add V4L2_CID_SCENEMODE menu control
Date: Fri, 30 Dec 2011 14:31:03 +0900
Message-id: <000401ccc6b4$38a4d040$a9ee70c0$%kim@samsung.com>
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
> Sent: Friday, December 30, 2011 9:11 AM
> To: HeungJun, Kim
> Cc: linux-media@vger.kernel.org; mchehab@redhat.com; hverkuil@xs4all.nl;
> sakari.ailus@iki.fi; s.nawrocki@samsung.com; kyungmin.park@samsung.com
> Subject: Re: [RFC PATCH 2/4] v4l: Add V4L2_CID_SCENEMODE menu control
> 
> Hi,
> 
> On Thursday 29 December 2011 06:40:57 HeungJun, Kim wrote:
> > On Wednesday, December 28, 2011 10:56 PM Laurent Pinchart wrote:
> > > On Wednesday 28 December 2011 07:23:46 HeungJun, Kim wrote:
> 
> [snip]
> 
> > > > diff --git a/Documentation/DocBook/media/v4l/controls.xml
> > > > b/Documentation/DocBook/media/v4l/controls.xml index 350c138..afe1845
> > > > 100644
> > > > --- a/Documentation/DocBook/media/v4l/controls.xml
> > > > +++ b/Documentation/DocBook/media/v4l/controls.xml
> > > > @@ -2879,6 +2879,94 @@ it one step further. This is a write-only
> > > > control.</entry> </row>
> > > >
> > > >  	  <row><entry></entry></row>
> > > >
> > > > +	  <row id="v4l2-scenemode">
> > > > +	    <entry
> > > > spanname="id"><constant>V4L2_CID_SCENEMODE</constant>&nbsp;</entry> +
> > > > <entry>enum&nbsp;v4l2_scenemode</entry>
> > > > +	  </row><row><entry spanname="descr">This control sets
> > > > +	  the camera's scenemode, and it is provided by the type of
> > > > +	  the enum values. The "None" mode means the status
> > > > +	  when scenemode algorithm is not activated, like after booting
> > > > time.
> > > > +	  On the other hand, the "Normal" mode means the scenemode
> algorithm
> > > > +	  is activated on the normal mode.</entry>
> > >
> > > What low-level parameters do the scene mode control ? How does it
> > > interact with the related controls ?
> >
> > For using this control, in M-5MOLS sensor case, several register is
> > configured, like Exposure(locking/Indexed preset/mode), Focus(locking),
> > WhiteBalance, etc. And I think the process interacting and syncing the
> > register's value should be up to the each drivers, and the m5mols driver
> > will be.
> 
> Does it mean that the scene mode is handled by the driver, which then
> configures exposure, focus, white balance, ... ?
Yes, the other controls(exposure/focus/wb, etc) is needed to be changed
for setting scene mode. So, In M-5MOLS case, the user set the scene mode,
then the driver should write the registers - scene mode itself register,
and even the other controls registers related with scene mode. 

> 
> > Anyways, could you explain the difference with low- and high- in more
> > details?
> >
> > :)
> >
> > I still did not understand well.
> 
> The concepts are a bit ill-defined currently. We have low-level sensor
> controls such as exposure time, gains, ... The controls you propose offer a
> higher level interface, likely using software-based algorithms running on the
> sensor instead of just applying hardware parameters.
I could understand high-/low- level meaning with your explanation. Thank you. 

> 
> > > > +	  </row>
> > > > +	  <row>
> > > > +	    <entrytbl spanname="descr" cols="2">
> > > > +	      <tbody valign="top">
> > > > +		<row>
> > > > +
> <entry><constant>V4L2_SCENEMODE_NONE</constant>&nbsp;</entry>
> > > > +		  <entry>Scenemode None.</entry>
> > > > +		</row>
> > > > +		<row>
> > > > +
> >
> > <entry><constant>V4L2_SCENEMODE_NORMAL</constant>&nbsp;</entry>
> >
> > > > +		  <entry>Scenemode Normal.</entry>
> > > > +		</row>
> > > > +		<row>
> > > > +
> > >
> > > <entry><constant>V4L2_SCENEMODE_PORTRAIT</constant>&nbsp;</entry>
> > >
> > > > +		  <entry>Scenemode Portrait.</entry>
> > >
> > > Could you please describe the scene modes in more details ?
> >
> > Yes, the photographer should adjust the exposure(luminance), focus, iso,
> > etc, for getting better image according to each specific circumstances.
> > But, it's uncomfortable to set all controls at every time.
> > The scene mode can make this at one time. It is just not only setting once.
> > According to fixed scene circumstance, the internal algorithm is also
> > needed for it.
> >
> > This function is usually provided as just preset, but, it's not just
> > preset, because the specific algorithm is existed for "scene mode",
> > except the collection of the camera control preset.
> >
> > The enumeration I suggest, can cover almost scene mode. Of course, the term
> > is fixed. The M-5MOLS can use all the scene mode.
> > Please, see drivers/media/video/m5mols/m5mols_contro.c.
> 
> What I meant when asking you to explain the scene modes in more details was to
> improve the documentation by adding a detailed description of each scene mode.
Ok, I'll add the relation about the new and previous controls in more details.

> 
> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

