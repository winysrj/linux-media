Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60859 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbbBPNkw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 08:40:52 -0500
Date: Mon, 16 Feb 2015 11:40:47 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCHv2] Partially revert 'Fix DVB devnode representation at
 media controller'
Message-ID: <20150216114047.60e19274@recife.lan>
In-Reply-To: <54E1DE7B.1060106@xs4all.nl>
References: <54E1DE7B.1060106@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Feb 2015 13:11:39 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> Partially revert e31a0ba7df6ce21ac4ed58c4182ec12ca8fd78fb (media: Fix DVB devnode
> representation at media controller) and 15d2042107f90f7ce39705716bc2c9a2ec1d5125
> (Docbook: Fix documentation for media controller devnodes) commits.
> 
> Those commits mark the alsa struct in struct media_entity_desc as deprecated.
> However, the alsa struct should remain as it is since it cannot be replaced
> by a simple major/minor device node description. The alsa struct was designed
> to be used as an alsa card description so V4L2 drivers could use this to expose
> the alsa card that they create to carry the captured audio. Such a card is not
> just a PCM device, but also needs to contain the alsa subdevice information,
> and it may map to multiple devices, e.g. a PCM and a mixer device, such as the
> au0828 usb stick creates.
> 
> This is exactly as intended and this cannot and should not be replaced by a
> simple major/minor.
> 
> However, whether this information is in the right form for an ALSA device such
> that it can handle udev renaming rules as well is another matter. So mark this
> alsa struct as experimental and document the problems involved.
> 
> Updated the documentation as well to reflect this and to reinstate the 'major'
> and 'minor' field documentation for the struct dev that was removed in the
> original commit.
> 
> Updated the documentation to clearly state that struct dev is to be used for
> (sub-)devices that create a single device node. Other devices need their own
> structure here.

I'm OK with this patch.

I have to say that, when we end by merging media controller support into
ALSA, the best is to not use MEDIA_ENT_T_DEVNODE_ALSA, as we should reserve
MEDIA_ENT_T_DEVNODE_* for the (sub-)devices that have a single devnode
mapping.

So, IMHO, the best would be to create a new type for ALSA (MEDIA_ENT_T_ALSA),
as its properties will be different than a normal MEDIA_ENT_T_DEVNODE.

In other words, something like:

#define MEDIA_ENT_T_DEVNODE		(1 << MEDIA_ENT_TYPE_SHIFT)
#define MEDIA_ENT_T_V4L2_SUBDEV		(2 << MEDIA_ENT_TYPE_SHIFT)
#define MEDIA_ENT_T_ALSA		(3 << MEDIA_ENT_TYPE_SHIFT)

struct media_entity_desc {
	/* Common fields for all types/subtypes of entities */
	__u32 id;
	char name[32];
	__u32 type;
	__u32 revision;
	__u32 flags;
	__u32 group_id;
	__u16 pads;
	__u16 links;
	__u32 reserved[4];

	/*
	 * Data specific for a media entity type
	 */
	union {
		/*
		 * for MEDIA_ENT_T_DEVNODE and MEDIA_ENT_T_V4L2_SUBDEV.
		 *
		 * If MEDIA_ENT_T_V4L2_SUBDEV, this is filled only if 
		 * CONFIG_VIDEO_V4L2_SUBDEV_API. Otherwise, major/minor
		 * should be zero. Perhaps we should add a new flag to
		 * indicate if subdev devnode info is available.
		 */
		struct { __u32 major, minor } dev;

		/* for MEDIA_ENT_T_ALSA */
		struct { __u32 card, device, subdevice } alsa_props; /* MEDIA_ENT_T_DEVNODE_ALSA */
	}

	/*
	 * Data specific to a media entity subtype, if needed
	 */
	union {
		u32 reserved2[172];
	}
}

(deprecated fields removed, just to easy the reading of the above struct)

Regards,
Mauro

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> index cbf307f..a77c1de 100644
> --- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> +++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
> @@ -145,7 +145,52 @@
>  	    <entry>struct</entry>
>  	    <entry><structfield>dev</structfield></entry>
>  	    <entry></entry>
> -	    <entry>Valid for (sub-)devices that create devnodes.</entry>
> +	    <entry>Valid for (sub-)devices that create a single device node.</entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>major</structfield></entry>
> +	    <entry>Device node major number.</entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>minor</structfield></entry>
> +	    <entry>Device node minor number.</entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
> +	    <entry>struct</entry>
> +	    <entry><structfield>alsa</structfield></entry>
> +	    <entry></entry>
> +	    <entry>Valid for ALSA devices only. This is an <link linkend="experimental">experimental</link>
> +	    ALSA device specification. If you want to use this, please contact the
> +	    linux-media mailing list (&v4l-ml;) first.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>card</structfield></entry>
> +	    <entry>ALSA card number</entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>device</structfield></entry>
> +	    <entry>ALSA device number</entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
> +	    <entry></entry>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>subdevice</structfield></entry>
> +	    <entry>ALSA sub-device number</entry>
>  	  </row>
>  	  <row>
>  	    <entry></entry>
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 52cc2a6..bcb2fe8a 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -91,6 +91,27 @@ struct media_entity_desc {
>  
>  #if 1
>  		/*
> +		 * EXPERIMENTAL: this shouldn't have been added without
> +		 * actual drivers that use this. When the first real driver
> +		 * appears that sets this information, special attention
> +		 * should be given whether this information is 1) enough, and
> +		 * 2) can deal with udev rules that rename devices. The struct
> +		 * dev would not be sufficient for this since that does not
> +		 * contain the subdevice information. In addition, struct dev
> +		 * can only refer to a single device, and not to multiple (e.g.
> +		 * pcm and mixer devices).
> +		 *
> +		 * So for now mark this as experimental.
> +		 */
> +		struct {
> +			__u32 card;
> +			__u32 device;
> +			__u32 subdevice;
> +		} alsa;
> +#endif
> +
> +#if 1
> +		/*
>  		 * DEPRECATED: previous node specifications. Kept just to
>  		 * avoid breaking compilation, but media_entity_desc.dev
>  		 * should be used instead. In particular, alsa and dvb
> @@ -106,11 +127,6 @@ struct media_entity_desc {
>  			__u32 major;
>  			__u32 minor;
>  		} fb;
> -		struct {
> -			__u32 card;
> -			__u32 device;
> -			__u32 subdevice;
> -		} alsa;
>  		int dvb;
>  #endif
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
