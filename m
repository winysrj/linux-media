Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58087 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab1CCKJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 05:09:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: riverful.kim@samsung.com
Subject: Re: [RFC PATCH RESEND v2 3/3] v4l2-ctrls: document the changes about auto focus mode
Date: Thu, 3 Mar 2011 11:08:39 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"???/Mobile S/W Platform Lab(DMC?)/E4(??)/????"
	<sw0312.kim@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
References: <4D6EFA02.4080105@samsung.com>
In-Reply-To: <4D6EFA02.4080105@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103031108.46219.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Thursday 03 March 2011 03:16:34 Kim, HeungJun wrote:
> Document about the type changes and the enumeration of the auto focus
> control.
> 
> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/v4l/controls.xml    |   31
> +++++++++++++++++++++++++--- Documentation/DocBook/v4l/videodev2.h.xml |  
>  6 +++++
>  2 files changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/DocBook/v4l/controls.xml
> b/Documentation/DocBook/v4l/controls.xml index 2fae3e8..889fa84 100644
> --- a/Documentation/DocBook/v4l/controls.xml
> +++ b/Documentation/DocBook/v4l/controls.xml
> @@ -1801,12 +1801,35 @@ negative values towards infinity. This is a
> write-only control.</entry> </row>
>  	  <row><entry></entry></row>
> 
> -	  <row>
> +	  <row id="v4l2-focus-auto-type">
>  	    <entry
> spanname="id"><constant>V4L2_CID_FOCUS_AUTO</constant>&nbsp;</entry> -	   
> <entry>boolean</entry>
> +	    <entry>enum&nbsp;v4l2_focus_auto_type</entry>
>  	  </row><row><entry spanname="descr">Enables automatic focus
> -adjustments. The effect of manual focus adjustments while this feature
> -is enabled is undefined, drivers should ignore such requests.</entry>
> +adjustments of the normal or macro or continuous(CAF) mode. The effect of
> +manual focus adjustments while this feature is enabled is undefined,
> +drivers should ignore such requests. Possible values are:</entry>
> +	  </row>
> +	  <row>
> +	    <entrytbl spanname="descr" cols="2">
> +	      <tbody valign="top">
> +		<row>
> +		  <entry><constant>V4L2_FOCUS_MANUAL</constant>&nbsp;</entry>
> +		  <entry>Manual focus mode.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_FOCUS_AUTO</constant>&nbsp;</entry>
> +		  <entry>Auto focus mode with normal operation.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_FOCUS_MACRO</constant>&nbsp;</entry>
> +		  <entry>Auto focus mode with macro operation.</entry>
> +		</row>
> +		<row>
> +		  <entry><constant>V4L2_FOCUS_CONTINUOUS</constant>&nbsp;</entry>
> +		  <entry>Auto focus mode with continuous(CAF) operation.</entry>

I should have asked this sooner, but what's the difference between normal AF 
and continuous AF ?

> +		</row>
> +	      </tbody>
> +	    </entrytbl>
>  	  </row>
>  	  <row><entry></entry></row>
> 
> diff --git a/Documentation/DocBook/v4l/videodev2.h.xml
> b/Documentation/DocBook/v4l/videodev2.h.xml index 325b23b..ccf6c2b 100644
> --- a/Documentation/DocBook/v4l/videodev2.h.xml
> +++ b/Documentation/DocBook/v4l/videodev2.h.xml
> @@ -1291,6 +1291,12 @@ enum  <link
> linkend="v4l2-exposure-auto-type">v4l2_exposure_auto_type</link> { #define
> V4L2_CID_FOCUS_ABSOLUTE                 (V4L2_CID_CAMERA_CLASS_BASE+10)
> #define V4L2_CID_FOCUS_RELATIVE                
> (V4L2_CID_CAMERA_CLASS_BASE+11) #define V4L2_CID_FOCUS_AUTO               
>      (V4L2_CID_CAMERA_CLASS_BASE+12) +enum  <link
> linkend="v4l2-focus-auto-type">v4l2_exposure_auto_type</link> {
> +	V4L2_FOCUS_MANUAL = 0,
> +	V4L2_FOCUS_AUTO = 1,
> +	V4L2_FOCUS_MACRO = 2,
> +	V4L2_FOCUS_CONTINUOUS = 3
> +};
> 
>  #define V4L2_CID_ZOOM_ABSOLUTE                 
> (V4L2_CID_CAMERA_CLASS_BASE+13) #define V4L2_CID_ZOOM_RELATIVE            
>      (V4L2_CID_CAMERA_CLASS_BASE+14)

-- 
Regards,

Laurent Pinchart
