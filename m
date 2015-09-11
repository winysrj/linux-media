Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44714 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbbIKNOn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 09:14:43 -0400
Message-ID: <55F2D37A.2060503@xs4all.nl>
Date: Fri, 11 Sep 2015 15:13:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v8 41/55] [media] DocBook: update descriptions for the
 media controller entities
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com> <00369c40b69f5ce1473d98398e32a7842cf28366.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <00369c40b69f5ce1473d98398e32a7842cf28366.1441540862.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2015 02:03 PM, Mauro Carvalho Chehab wrote:
> Cleanup the media controller entities description:
> - remove MEDIA_ENT_T_DEVNODE and MEDIA_ENT_T_V4L2_SUBDEV entity
>   types, as they don't mean anything;
> - add MEDIA_ENT_T_UNKNOWN with a proper description;
> - remove ALSA and FB entity types. Those should not be used, as
>   the types are deprecated. We'll soon be adidng ALSA, but with
>   a different entity namespace;
> - improve the description of some entities.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> index 32a783635649..bc101516e372 100644
> --- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> +++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> @@ -179,70 +179,65 @@
>          <colspec colname="c2"/>
>  	<tbody valign="top">
>  	  <row>
> -	    <entry><constant>MEDIA_ENT_T_DEVNODE</constant></entry>
> -	    <entry>Unknown device node</entry>
> +	    <entry><constant>MEDIA_ENT_T_UNKNOWN</constant> and <constant>MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN</constant></entry>
> +	    <entry>Unknown entity. That generally indicates that
> +	    a driver didn't initialize properly the entity, with is a Kernel bug</entry>
>  	  </row>

I'm wondering: if userspace should never see an unknown entity, wouldn't it
be better to move these UNKNOWN defines out of the public header to a kernel
header and drop this from the documentation?

>  	  <row>
>  	    <entry><constant>MEDIA_ENT_T_V4L2_VIDEO</constant></entry>
> -	    <entry>V4L video, radio or vbi device node</entry>
> +	    <entry>V4L video streaming input or output entity</entry>
>  	  </row>
> -	  <row>
> -	    <entry><constant>MEDIA_ENT_T_DEVNODE_FB</constant></entry>
> -	    <entry>Frame buffer device node</entry>
> +	    <entry><constant>MEDIA_ENT_T_V4L2_VBI</constant></entry>
> +	    <entry>V4L VBI streaming input or output entity</entry>
>  	  </row>
> -	  <row>
> -	    <entry><constant>MEDIA_ENT_T_DEVNODE_ALSA</constant></entry>
> -	    <entry>ALSA card</entry>
> +	    <entry><constant>MEDIA_ENT_T_V4L2_SWRADIO</constant></entry>
> +	    <entry>V4L Sofware Digital Radio (SDR) streaming input or output entity</entry>

s/Sofware/Software/

>  	  </row>
>  	  <row>
>  	    <entry><constant>MEDIA_ENT_T_DVB_DEMOD</constant></entry>
> -	    <entry>DVB frontend devnode</entry>
> +	    <entry>DVB demodulator entity</entry>
>  	  </row>
>  	  <row>
>  	    <entry><constant>MEDIA_ENT_T_DVB_DEMUX</constant></entry>
> -	    <entry>DVB demux devnode</entry>
> +	    <entry>DVB demux entity. Could be implemented on hardware or in Kernelspace</entry>

s/on/in/

>  	  </row>
>  	  <row>
>  	    <entry><constant>MEDIA_ENT_T_DVB_TSOUT</constant></entry>
> -	    <entry>DVB DVR devnode</entry>
> +	    <entry>DVB Transport Stream output entity</entry>
>  	  </row>
>  	  <row>
>  	    <entry><constant>MEDIA_ENT_T_DVB_CA</constant></entry>
> -	    <entry>DVB CAM devnode</entry>
> +	    <entry>DVB Conditional Access module (CAM) entity</entry>
>  	  </row>
>  	  <row>
>  	    <entry><constant>MEDIA_ENT_T_DVB_DEMOD_NET_DECAP</constant></entry>
> -	    <entry>DVB network devnode</entry>
> -	  </row>
> -	  <row>
> -	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV</constant></entry>
> -	    <entry>Unknown V4L sub-device</entry>
> +	    <entry>DVB network ULE/MLE desencapsulation entity. Could be implemented on hardware or in Kernelspace</entry>

s/on/in/

Hmm, is desencapsulation correct? Could it be 'de-encapsulation' instead? It looks weird.

>  	  </row>
>  	  <row>
>  	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_SENSOR</constant></entry>
> -	    <entry>Video sensor</entry>
> +	    <entry>Camera video sensor entity</entry>
>  	  </row>
>  	  <row>
>  	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_FLASH</constant></entry>
> -	    <entry>Flash controller</entry>
> +	    <entry>Flash controller entity</entry>
>  	  </row>
>  	  <row>
>  	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_LENS</constant></entry>
> -	    <entry>Lens controller</entry>
> +	    <entry>Lens controller entity</entry>
>  	  </row>
>  	  <row>
>  	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_DECODER</constant></entry>
> -	    <entry>Video decoder, the basic function of the video decoder is to
> -	    accept analogue video from a wide variety of sources such as
> +	    <entry>Analog video decoder, the basic function of the video decoder
> +	    is to accept analogue video from a wide variety of sources such as
>  	    broadcast, DVD players, cameras and video cassette recorders, in
> -	    either NTSC, PAL or HD format and still occasionally SECAM, separate
> -	    it into its component parts, luminance and chrominance, and output
> +	    either NTSC, PAL, SECAM or HD format, separating the stream
> +	    into its component parts, luminance and chrominance, and output
>  	    it in some digital video standard, with appropriate embedded timing
>  	    signals.</entry>
>  	  </row>
>  	  <row>
>  	    <entry><constant>MEDIA_ENT_T_V4L2_SUBDEV_TUNER</constant></entry>
> -	    <entry>TV and/or radio tuner</entry>
> +	    <entry>Digital TV, analog TV, radio and/or software radio tuner</entry>
>  	  </row>
>  	</tbody>
>        </tgroup>
> 

