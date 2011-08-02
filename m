Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:48837 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753318Ab1HBPb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 11:31:28 -0400
Date: Tue, 2 Aug 2011 08:31:26 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	jaeryul.oh@samsung.com, mchehab@infradead.org
Subject: Re: [PATCH] v4l2: Fix documentation of the codec device controls
Message-Id: <20110802083126.413c07ee.rdunlap@xenotime.net>
In-Reply-To: <002401cc50e9$d348d6f0$79da84d0$%debski@samsung.com>
References: <1312210299-8040-1-git-send-email-k.debski@samsung.com>
	<20110801102346.0b2b9126.rdunlap@xenotime.net>
	<002401cc50e9$d348d6f0$79da84d0$%debski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 02 Aug 2011 09:57:23 +0200 Kamil Debski wrote:

> Hi,
> 
> I am sorry, I did run "make htmldocs" and got no errors. So I have to be
> doing something wrong building the docs. Could you tell me how do you build
> the documentation? Knowing this I could check the next patch to make sure it
> is error free.

I'm just running "make htmldocs".  I expect the differences are in what
versions of tools (or xml reference files etc.) we have installed.
I'm using fedora 11 (which is fairly old).

You have done what you should do, so I'll just ignore the warnings etc.
(and move off of fedora 11 one day).

Thanks.

> Best wishes,
> --
> Kamil Debski
> Linux Platform Group
> Samsung Poland R&D Center
> 
> 
> > -----Original Message-----
> > From: Randy Dunlap [mailto:rdunlap@xenotime.net]
> > Sent: 01 August 2011 19:24
> > To: Kamil Debski
> > Cc: linux-media@vger.kernel.org; kyungmin.park@samsung.com;
> > jaeryul.oh@samsung.com; mchehab@infradead.org
> > Subject: Re: [PATCH] v4l2: Fix documentation of the codec device controls
> > 
> > On Mon, 01 Aug 2011 16:51:39 +0200 Kamil Debski wrote:
> > 
> > > Fixed missing ids of the codec controls description in the controls.xml
> > file.
> > >
> > > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> > > ---
> > > Hi,
> > >
> > > This patch fixes the problem with codec controls documentation reported by
> > Randy
> > > in the following email:
> > > http://comments.gmane.org/gmane.linux.drivers.video-input-
> > infrastructure/36288
> > >
> > > Thanks for reporting those errors.
> > >
> > > Best wishes,
> > > Kamil
> > 
> > Hi,
> > This patch eliminates some (3) of the reported errors, but not all of them.
> > 
> > The fixed ones are:
> > Error: no ID for constraint linkend: v4l2-mpeg-video-h264-level.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-h264-vui-sar-idc.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-mpeg4-level.
> > 
> > but I still see these:
> > Error: no ID for constraint linkend: v4l2-mpeg-video-header-mode.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-multi-slice-mode.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-h264-entropy-mode.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-h264-loop-filter-mode.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-h264-profile.
> > Error: no ID for constraint linkend: v4l2-mpeg-video-mpeg4-profile.
> > Error: no ID for constraint linkend: v4l2-mpeg-mfc51-video-frame-skip-mode.
> > Error: no ID for constraint linkend: v4l2-mpeg-mfc51-video-force-frame-type.
> > 
> > 
> > > ---
> > >  Documentation/DocBook/media/v4l/controls.xml |   24 ++++++++++++---------
> > ---
> > >  1 files changed, 12 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/Documentation/DocBook/media/v4l/controls.xml
> > b/Documentation/DocBook/media/v4l/controls.xml
> > > index 8516401..09d6872 100644
> > > --- a/Documentation/DocBook/media/v4l/controls.xml
> > > +++ b/Documentation/DocBook/media/v4l/controls.xml
> > > @@ -1455,7 +1455,7 @@ Applicable to the H264 encoder.</entry>
> > >  	      </row>
> > >
> > >  	      <row><entry></entry></row>
> > > -	      <row>
> > > +	      <row id="v4l2-mpeg-video-h264-vui-sar-idc">
> > >  		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC</constant>&nbsp
> > ;</entry>
> > >  		<entry>enum&nbsp;v4l2_mpeg_video_h264_vui_sar_idc</entry>
> > >  	      </row>
> > > @@ -1561,7 +1561,7 @@ Applicable to the H264 encoder.</entry>
> > >  	      </row>
> > >
> > >  	      <row><entry></entry></row>
> > > -	      <row>
> > > +	      <row id="v4l2-mpeg-video-h264-level">
> > >  		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_LEVEL</constant>&nbsp;</ent
> > ry>
> > >  		<entry>enum&nbsp;v4l2_mpeg_video_h264_level</entry>
> > >  	      </row>
> > > @@ -1641,7 +1641,7 @@ Possible values are:</entry>
> > >  	      </row>
> > >
> > >  	      <row><entry></entry></row>
> > > -	      <row>
> > > +	      <row id="v4l2-mpeg-video-mpeg4-level">
> > >  		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_LEVEL</constant>&nbsp;</en
> > try>
> > >  		<entry>enum&nbsp;v4l2_mpeg_video_mpeg4_level</entry>
> > >  	      </row>
> > > @@ -1689,7 +1689,7 @@ Possible values are:</entry>
> > >  	      </row>
> > >
> > >  	      <row><entry></entry></row>
> > > -	      <row>
> > > +	      <row id="v4l2-mpeg-h264-profile">
> > >  		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_PROFILE</constant>&nbsp;</e
> > ntry>
> > >  		<entry>enum&nbsp;v4l2_mpeg_h264_profile</entry>
> > >  	      </row>
> > > @@ -1774,7 +1774,7 @@ Possible values are:</entry>
> > >  	      </row>
> > >
> > >  	      <row><entry></entry></row>
> > > -	      <row>
> > > +	      <row id="v4l2-mpeg-mpeg4-profile">
> > >  		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE</constant>&nbsp;</
> > entry>
> > >  		<entry>enum&nbsp;v4l2_mpeg_mpeg4_profile</entry>
> > >  	      </row>
> > > @@ -1820,7 +1820,7 @@ Applicable to the encoder.
> > >  	      </row>
> > >
> > >  	      <row><entry></entry></row>
> > > -	      <row>
> > > +	      <row id="v4l2-mpeg-multi-slice-mode">
> > >  		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE</constant>&nbsp
> > ;</entry>
> > >  		<entry>enum&nbsp;v4l2_mpeg_multi_slice_mode</entry>
> > >  	      </row>
> > > @@ -1868,7 +1868,7 @@ Applicable to the encoder.</entry>
> > >  	      </row>
> > >
> > >  	      <row><entry></entry></row>
> > > -	      <row>
> > > +	      <row id="v4l2-mpeg-h264-loop-filter-mode">
> > >  		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_LOOP_FILTER_MODE</constant>
> > &nbsp;</entry>
> > >  		<entry>enum&nbsp;v4l2_mpeg_h264_loop_filter_mode</entry>
> > >  	      </row>
> > > @@ -1913,9 +1913,9 @@ Applicable to the H264 encoder.</entry>
> > >  	      </row>
> > >
> > >  	      <row><entry></entry></row>
> > > -	      <row>
> > > +	      <row id="v4l2-mpeg-h264-entropy-mode">
> > >  		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE</constant>&nbs
> > p;</entry>
> > > -		<entry>enum&nbsp;v4l2_mpeg_h264_symbol_mode</entry>
> > > +		<entry>enum&nbsp;v4l2_mpeg_h264_entropy_mode</entry>
> > >  	      </row>
> > >  	      <row><entry spanname="descr">Entropy coding mode for H264 -
> > CABAC/CAVALC.
> > >  Applicable to the H264 encoder.
> > > @@ -2140,7 +2140,7 @@ previous frames. Applicable to the H264
> > encoder.</entry>
> > >  	      </row>
> > >
> > >  	      <row><entry></entry></row>
> > > -	      <row>
> > > +	      <row id="v4l2-mpeg-header-mode">
> > >  		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_VIDEO_HEADER_MODE</constant>&nbsp;</en
> > try>
> > >  		<entry>enum&nbsp;v4l2_mpeg_header_mode</entry>
> > >  	      </row>
> > > @@ -2320,7 +2320,7 @@ Valid only when H.264 and macroblock level RC is
> > enabled (<constant>V4L2_CID_MPE
> > >  Applicable to the H264 encoder.</entry>
> > >  	      </row>
> > >  	      <row><entry></entry></row>
> > > -	      <row>
> > > +	      <row id="v4l2-mpeg-mfc51-frame-skip-mode">
> > >  		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE</constant>
> > &nbsp;</entry>
> > >  		<entry>enum&nbsp;v4l2_mpeg_mfc51_frame_skip_mode</entry>
> > >  	      </row>
> > > @@ -2361,7 +2361,7 @@ the stream will meet tight bandwidth contraints.
> > Applicable to encoders.
> > >  </entry>
> > >  	      </row>
> > >  	      <row><entry></entry></row>
> > > -	      <row>
> > > +	      <row id="v4l2-mpeg-mfc51-force-frame-type">
> > >  		<entry
> > spanname="id"><constant>V4L2_CID_MPEG_MFC51_VIDEO_FORCE_FRAME_TYPE</constant
> > >&nbsp;</entry>
> > >  		<entry>enum&nbsp;v4l2_mpeg_mfc51_force_frame_type</entry>
> > >  	      </row>
> > > --
> > 
> > 
> > ---
> > ~Randy
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
