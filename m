Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52771 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbcDJADk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Apr 2016 20:03:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	sakari.ailus@iki.fi
Subject: Re: [PATCH v3] media: Add video processing entity functions
Date: Sun, 10 Apr 2016 03:03:34 +0300
Message-ID: <2779077.G9xBbKkPT5@avalon>
In-Reply-To: <9064017.URrFI5rgEZ@avalon>
References: <56F532AB.3000107@xs4all.nl> <56F555F3.4000308@xs4all.nl> <9064017.URrFI5rgEZ@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Sakari,

Ping ? I'd like to get the patch merged this week as part of a larger pull 
request.

On Friday 25 Mar 2016 17:23:25 Laurent Pinchart wrote:
> On Friday 25 Mar 2016 16:14:59 Hans Verkuil wrote:
> > On 03/25/2016 03:19 PM, Laurent Pinchart wrote:
> >> Add composer, format converter and scaler functions, as well as generic
> >> video processing to be used when no other processing function is
> >> applicable.
> >> 
> >> Signed-off-by: Laurent Pinchart
> >> <laurent.pinchart+renesas@ideasonboard.com>
> >> ---
> >> 
> >>  Documentation/DocBook/media/v4l/media-types.xml | 34 ++++++++++++++++++
> >>  include/uapi/linux/media.h                      |  8 ++++++
> >>  2 files changed, 42 insertions(+)
> >> 
> >> Changes since v2:
> >> 
> >> - Fix typo (any other mean -> any other means)
> >> 
> >> diff --git a/Documentation/DocBook/media/v4l/media-types.xml
> >> b/Documentation/DocBook/media/v4l/media-types.xml index
> >> 5e3f20fdcf17..38e8d6c25d49 100644
> >> --- a/Documentation/DocBook/media/v4l/media-types.xml
> >> +++ b/Documentation/DocBook/media/v4l/media-types.xml
> >> @@ -121,6 +121,40 @@
> >>  	    <entry><constant>MEDIA_ENT_F_AUDIO_MIXER</constant></entry>
> >>  	    <entry>Audio Mixer Function Entity.</entry>
> >>  	  </row>
> >> +	  <row>
> >> +
> >> <entry><constant>MEDIA_ENT_F_PROC_VIDEO_GENERIC</constant></entry>
> >> +	    <entry>Generic video processing, when no other processing
> >> function
> >> +		   is applicable.
> >> +	    </entry>
> > 
> > I'll be honest and say that I don't really like this. A VIDEO_GENERIC
> > function is only marginally more useful than UNKNOWN. And I think I prefer
> > UNKNOWN for now until we have a clear picture how these functions are
> > going to work. The main missing piece in this puzzle are properties that
> > allow us to register multiple functions and some decision as to what the
> > scope of 'functions' is going to be.
> > 
> > You mentioned that you have a few entities that are using this function,
> > but if you would specify the exact function of those entities, what would
> > the function name(s) be?
> 
> I'm not sure, otherwise I would have proposed more precise functions :-)
> 
> Two of the entities just apply look up tables. They can thus be used for
> various purpose, such as gamma correction, A-law/µ-law (de)compression, ...
> 
> The last entity is an interface between the VSP and the display device and
> just handles buffering, clock domain crossing and synchronization.
> 
> >> +	  <row>
> >> +
> >> <entry><constant>MEDIA_ENT_F_PROC_VIDEO_COMPOSER</constant></entry>
> >> +	    <entry>Video composer (blender). An entity capable of video
> >> +		   composing must have at least two sink pads and one source
> >> +		   pad, and composes input video frames onto output video
> >> +		   frames. Composition can be performed using alpha blending,
> >> +		   color keying, raster operations (ROP), stitching or any other
> >> +		   means.
> >> +	    </entry>
> >> +	  </row>
> > 
> > This one looks OK to me.
> > 
> >> +	  </row>
> >> +
> >> <entry><constant>MEDIA_ENT_F_PROC_VIDEO_CONVERTER</constant></entry>
> >> +	    <entry>Video format converter. An entity capable of video format
> >> +		   conversion must have at least one sink pad and one source
> >> +		   pad, and convert the format of pixels received on its sink
> >> +		   pad(s) to a different format output on its source pad(s).
> >> +	    </entry>
> >> +	  </row>
> > 
> > This is too vague as well, I think. You said that you don't consider
> > de-interlacing a converter function, but what about colorimetry
> > conversion? Debayer? 4:2:2 to 4:2:0 conversion or vice versa?
> 
> I'd consider that as video format conversion, yes.
> 
> The three entities that implement this function in the vsp1 driver are
> ARGB8888 <-> AHSV8888 converters and RGB <-> YUV converters (with various
> RGB and YUV formats supported).
> 
> >> +	  <row>
> >> +	    <entry><constant>MEDIA_ENT_F_PROC_VIDEO_SCALER</constant></entry>
> >> +	    <entry>Video scaler. An entity capable of video scaling must have
> >> +		   at least one sink pad and one source pad, and scaling the
> >> +		   video frame(s) received on its sink pad(s) to a different
> >> +		   resolution output on its source pad(s). The range of
> >> +		   supported scaling ratios is entity-specific and can differ
> >> +		   between the horizontal and vertical directions. In particular
> >> +		   scaling can be supported in one direction only.
> >> +	    </entry>
> >> +	  </row>
> > 
> > This looks OK too, although would sensor binning and/or skipping also be
> > considered scaling?
> 
> I would consider them as scaling, yes. Sakari, any opinion on that ?
> 
> >>  	</tbody>
> >>        </tgroup>
> >>      </table>

-- 
Regards,

Laurent Pinchart

