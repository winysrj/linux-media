Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:50915 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752683AbbHaLXo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 07:23:44 -0400
Message-ID: <55E43907.7040001@xs4all.nl>
Date: Mon, 31 Aug 2015 13:22:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v8 41/55] [media] DocBook: update descriptions for the
 media controller entities
References: <cover.1440902901.git.mchehab@osg.samsung.com> <08890f5bbebb0ddaaacda3c95142fa545ab15306.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <08890f5bbebb0ddaaacda3c95142fa545ab15306.1440902901.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> Cleanup the media controller entities description:
> - remove MEDIA_ENT_T_DEVNODE and MEDIA_ENT_T_V4L2_SUBDEV entity
>   types, as they don't mean anything;

Shouldn't this add MEDIA_ENT_T_V4L2_VBI and _SWRADIO descriptions?

Regards,

	Hans

> - add MEDIA_ENT_T_UNKNOWN with a proper description;
> - remove ALSA and FB entity types. Those should not be used, as
>   the types are deprecated. We'll soon be adidng ALSA, but with
>   a different entity namespace;
> - improve the description of some entities.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> index 32a783635649..bd90dde54416 100644
> --- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> +++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> @@ -179,70 +179,59 @@
>          <colspec colname="c2"/>
>  	<tbody valign="top">
>  	  <row>
> -	    <entry><constant>MEDIA_ENT_T_DEVNODE</constant></entry>
> -	    <entry>Unknown device node</entry>
> +	    <entry><constant>MEDIA_ENT_T_UNKNOWN</constant> and <constant>MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN</constant></entry>
> +	    <entry>Unknown entity. That generally indicates that
> +	    a driver didn't initialize properly the entity, with is a Kernel bug</entry>
>  	  </row>
>  	  <row>
>  	    <entry><constant>MEDIA_ENT_T_V4L2_VIDEO</constant></entry>
> -	    <entry>V4L video, radio or vbi device node</entry>
> -	  </row>
> -	  <row>
> -	    <entry><constant>MEDIA_ENT_T_DEVNODE_FB</constant></entry>
> -	    <entry>Frame buffer device node</entry>
> -	  </row>
> -	  <row>
> -	    <entry><constant>MEDIA_ENT_T_DEVNODE_ALSA</constant></entry>
> -	    <entry>ALSA card</entry>
> +	    <entry>V4L video streaming input or output entity</entry>
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

