Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:57958 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1FVOo6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 10:44:58 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LN70044L4YJ9Y70@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 23:44:57 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LN700G2G4YLDY@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Jun 2011 23:44:49 +0900 (KST)
Date: Wed, 22 Jun 2011 16:44:44 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH 2/4 v9] v4l: add control definitions for codec devices.
In-reply-to: <201106221025.53838.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, jaeryul.oh@samsung.com,
	laurent.pinchart@ideasonboard.com, jtp.park@samsung.com
Message-id: <00b001cc30ea$f08302a0$d18907e0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-language: en-gb
Content-transfer-encoding: 7BIT
References: <1308069416-24723-1-git-send-email-k.debski@samsung.com>
 <1308069416-24723-3-git-send-email-k.debski@samsung.com>
 <201106221025.53838.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Just a quick comment below.

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: 22 June 2011 10:26
> 
> On Tuesday, June 14, 2011 18:36:54 Kamil Debski wrote:
> > Add control definitions and documentation for controls
> > specific to codec devices.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  Documentation/DocBook/media/v4l/controls.xml |  958
> ++++++++++++++++++++++++++
> >  include/linux/videodev2.h                    |  171 +++++
> >  2 files changed, 1129 insertions(+), 0 deletions(-)
> >
> > diff --git a/Documentation/DocBook/media/v4l/controls.xml
> b/Documentation/DocBook/media/v4l/controls.xml
> > index 6880798..6b0d06a 100644
> > --- a/Documentation/DocBook/media/v4l/controls.xml
> > +++ b/Documentation/DocBook/media/v4l/controls.xml
> > @@ -325,6 +325,22 @@ minimum value disables backlight

...

> > +	      <row><entry></entry></row>
> > +	      <row>
> > +		<entry
> spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MB_RC_ENABLE</constant>&nbsp;</e
> ntry>
> > +		<entry>boolean</entry>
> > +	      </row>
> > +	      <row><entry spanname="descr">Macroblock level rate control
> enable.
> > +Applicable to the MPEG4 and H264 encoders.</entry>
> 
> If I understand this right enabling this will 'activate' the
> V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_* controls.
> 
> So this makes me wonder whether this control shouldn't perhaps be MFC51
> specific
> as well. Alternatively, we can say something like: 'How macroblock rate
> control is
> implemented will differ per device, so devices that implement this will have
> their
> own set of controls.'
> 

The V4L2_CID_MPEG_MFC51_VIDEO_H264_ADAPTIVE_RC_* controls are an added tweak by
MFC. So I think it should stay as a generic control, especially that macroblock
rate control is defined in the MPEG4 standard.

...

Best regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

