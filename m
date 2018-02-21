Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47532 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S933330AbeBUPOi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 10:14:38 -0500
Date: Wed, 21 Feb 2018 17:14:35 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 15/15] media.h: reorganize header to make it easier to
 understand
Message-ID: <20180221151435.3okax5vslkt3eg5d@valkosipuli.retiisi.org.uk>
References: <20180219103806.17032-1-hverkuil@xs4all.nl>
 <20180219103806.17032-16-hverkuil@xs4all.nl>
 <20180221141539.bvyluuodvulenn2b@valkosipuli.retiisi.org.uk>
 <e683d5f4-b2cd-4fdd-779e-b7cb6f1e70cf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e683d5f4-b2cd-4fdd-779e-b7cb6f1e70cf@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Feb 21, 2018 at 03:33:03PM +0100, Hans Verkuil wrote:
> On 02/21/18 15:15, Sakari Ailus wrote:
> > Hi Hans,
> > 
> > On Mon, Feb 19, 2018 at 11:38:06AM +0100, Hans Verkuil wrote:
> >> The media.h public header is very messy. It mixes legacy and 'new' defines
> >> and it is not easy to figure out what should and what shouldn't be used. It
> >> also contains confusing comment that are either out of date or completely
> >> uninteresting for anyone that needs to use this header.
> >>
> >> The patch groups all entity functions together, including the 'old' defines
> >> based on the old range base. The reader just wants to know about the available
> >> functions and doesn't care about what range is used.
> >>
> >> All legacy defines are moved to the end of the header, so it is easier to
> >> locate them and just ignore them.
> >>
> >> The legacy structs in the struct media_entity_desc are put under
> >> #if !defined(__KERNEL__) to prevent the kernel from using them, and this is
> >> also a much more effective signal to the reader that they shouldn't be used
> >> compared to the old method of relying on '#if 1' followed by a comment.
> >>
> >> The unused MEDIA_INTF_T_ALSA_* defines are also moved to the end of the header
> >> in the legacy area. They are also dropped from intf_type() in media-entity.c.
> >>
> >> All defines are also aligned at the same tab making the header easier to read.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  drivers/media/media-entity.c |  16 --
> >>  include/uapi/linux/media.h   | 345 +++++++++++++++++++++----------------------
> >>  2 files changed, 166 insertions(+), 195 deletions(-)
> >>
> 
> <snip>
> 
> >>  /*
> >> - * I/O entities
> >> + * Subdevs are initialized with MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN in order
> >> + * to preserve backward compatibility. Drivers must change to the proper
> >> + * subdev type before registering the entity.
> > 
> > s/type/function/
> 
> Good catch!
> 
> > 
> > I wonder if "should" would actually be better; the current API assumes an
> > entity has at most one function which is somehow defined by the API. I
> > guess you could force everything into some kind of a group, as the current
> > approach seems to be. This is also what the enumeration through
> > MEDIA_IOC_ENUM_ENTITIES will yield to for the new functions anyway.
> 
> I don't quite follow you. 'should' suggests that they don't have to, but that's
> not the case. They really must set function to something other than UNKNOWN.

I'd like to reiterate that a single function cannot fully describe all
entities, and not all of them fit well to existing categories. If an entity
has multiple functions, which one do you pick?

Say, a SoC camera that also controls the lens.

> 
> The fact that newer functions are never actually exposed in the MEDIA_IOC_ENUM_ENTITIES
> ioctl since there only is a 'type' field and not a 'function' field is another
> matter altogether.

I don't have a strong opinion on this, feel free to leave it as-is for now.

> 
> > 
> >>   */
> >> -#define MEDIA_ENT_F_IO_DTV		(MEDIA_ENT_F_BASE + 0x01001)
> >> -#define MEDIA_ENT_F_IO_VBI		(MEDIA_ENT_F_BASE + 0x01002)
> >> -#define MEDIA_ENT_F_IO_SWRADIO		(MEDIA_ENT_F_BASE + 0x01003)
> >> +#define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN		MEDIA_ENT_F_OLD_SUBDEV_BASE
> >>  
> >>  /*
> >> - * Analog TV IF-PLL decoders
> >> - *
> >> - * It is a responsibility of the master/bridge drivers to create links
> >> - * for MEDIA_ENT_F_IF_VID_DECODER and MEDIA_ENT_F_IF_AUD_DECODER.
> >> + * DVB entity functions
> >>   */
> >> -#define MEDIA_ENT_F_IF_VID_DECODER	(MEDIA_ENT_F_BASE + 0x02001)
> >> -#define MEDIA_ENT_F_IF_AUD_DECODER	(MEDIA_ENT_F_BASE + 0x02002)
> >> +#define MEDIA_ENT_F_DTV_DEMOD			(MEDIA_ENT_F_BASE + 0x00001)
> >> +#define MEDIA_ENT_F_TS_DEMUX			(MEDIA_ENT_F_BASE + 0x00002)
> >> +#define MEDIA_ENT_F_DTV_CA			(MEDIA_ENT_F_BASE + 0x00003)
> >> +#define MEDIA_ENT_F_DTV_NET_DECAP		(MEDIA_ENT_F_BASE + 0x00004)
> >>  
> >>  /*
> >> - * Audio Entity Functions
> >> + * I/O entity functions
> >>   */
> >> -#define MEDIA_ENT_F_AUDIO_CAPTURE	(MEDIA_ENT_F_BASE + 0x03001)
> >> -#define MEDIA_ENT_F_AUDIO_PLAYBACK	(MEDIA_ENT_F_BASE + 0x03002)
> >> -#define MEDIA_ENT_F_AUDIO_MIXER		(MEDIA_ENT_F_BASE + 0x03003)
> >> +#define MEDIA_ENT_F_IO_V4L  			(MEDIA_ENT_F_OLD_BASE + 1)
> >> +#define MEDIA_ENT_F_IO_DTV			(MEDIA_ENT_F_BASE + 0x01001)
> >> +#define MEDIA_ENT_F_IO_VBI			(MEDIA_ENT_F_BASE + 0x01002)
> >> +#define MEDIA_ENT_F_IO_SWRADIO			(MEDIA_ENT_F_BASE + 0x01003)
> >>  
> >>  /*
> >> - * Processing entities
> >> + * Sensor functions
> >>   */
> >> -#define MEDIA_ENT_F_PROC_VIDEO_COMPOSER		(MEDIA_ENT_F_BASE + 0x4001)
> >> -#define MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER	(MEDIA_ENT_F_BASE + 0x4002)
> >> -#define MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV	(MEDIA_ENT_F_BASE + 0x4003)
> >> -#define MEDIA_ENT_F_PROC_VIDEO_LUT		(MEDIA_ENT_F_BASE + 0x4004)
> >> -#define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4005)
> >> -#define MEDIA_ENT_F_PROC_VIDEO_STATISTICS	(MEDIA_ENT_F_BASE + 0x4006)
> >> +#define MEDIA_ENT_F_CAM_SENSOR			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 1)
> >> +#define MEDIA_ENT_F_FLASH			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 2)
> >> +#define MEDIA_ENT_F_LENS			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 3)
> >>  
> >>  /*
> >> - * Switch and bridge entitites
> >> + * Analog video decoder functions
> >>   */
> >> -#define MEDIA_ENT_F_VID_MUX			(MEDIA_ENT_F_BASE + 0x5001)
> >> -#define MEDIA_ENT_F_VID_IF_BRIDGE		(MEDIA_ENT_F_BASE + 0x5002)
> >> +#define MEDIA_ENT_F_ATV_DECODER			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 4)
> >>  
> >>  /*
> >> - * Connectors
> >> - */
> >> -/* It is a responsibility of the entity drivers to add connectors and links */
> >> -#ifdef __KERNEL__
> >> -	/*
> >> -	 * For now, it should not be used in userspace, as some
> >> -	 * definitions may change
> >> -	 */
> >> -
> >> -#define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 0x30001)
> >> -#define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 0x30002)
> >> -#define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 0x30003)
> >> -
> >> -#endif
> >> -
> >> -/*
> >> - * Don't touch on those. The ranges MEDIA_ENT_F_OLD_BASE and
> >> - * MEDIA_ENT_F_OLD_SUBDEV_BASE are kept to keep backward compatibility
> >> - * with the legacy v1 API.The number range is out of range by purpose:
> >> - * several previously reserved numbers got excluded from this range.
> >> + * Digital TV, analog TV, radio and/or software defined radio tuner functions.
> >>   *
> >> - * Subdevs are initialized with MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN,
> >> - * in order to preserve backward compatibility.
> >> - * Drivers must change to the proper subdev type before
> >> - * registering the entity.
> >> - */
> >> -
> >> -#define MEDIA_ENT_F_IO_V4L  		(MEDIA_ENT_F_OLD_BASE + 1)
> >> -
> >> -#define MEDIA_ENT_F_CAM_SENSOR		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 1)
> >> -#define MEDIA_ENT_F_FLASH		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 2)
> >> -#define MEDIA_ENT_F_LENS		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 3)
> >> -#define MEDIA_ENT_F_ATV_DECODER		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 4)
> >> -/*
> >>   * It is a responsibility of the master/bridge drivers to add connectors
> >>   * and links for MEDIA_ENT_F_TUNER. Please notice that some old tuners
> >>   * may require the usage of separate I2C chips to decode analog TV signals,
> >> @@ -151,49 +104,46 @@ struct media_device_info {
> >>   * On such cases, the IF-PLL staging is mapped via one or two entities:
> >>   * MEDIA_ENT_F_IF_VID_DECODER and/or MEDIA_ENT_F_IF_AUD_DECODER.
> >>   */
> >> -#define MEDIA_ENT_F_TUNER		(MEDIA_ENT_F_OLD_SUBDEV_BASE + 5)
> >> +#define MEDIA_ENT_F_TUNER			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 5)
> >>  
> >> -#define MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN	MEDIA_ENT_F_OLD_SUBDEV_BASE
> >> +/*
> >> + * Analog TV IF-PLL decoder functions
> >> + *
> >> + * It is a responsibility of the master/bridge drivers to create links
> >> + * for MEDIA_ENT_F_IF_VID_DECODER and MEDIA_ENT_F_IF_AUD_DECODER.
> >> + */
> >> +#define MEDIA_ENT_F_IF_VID_DECODER		(MEDIA_ENT_F_BASE + 0x02001)
> >> +#define MEDIA_ENT_F_IF_AUD_DECODER		(MEDIA_ENT_F_BASE + 0x02002)
> >>  
> >> -#if !defined(__KERNEL__) || defined(__NEED_MEDIA_LEGACY_API)
> >> +/*
> >> + * Audio entity functions
> >> + */
> >> +#define MEDIA_ENT_F_AUDIO_CAPTURE		(MEDIA_ENT_F_BASE + 0x03001)
> >> +#define MEDIA_ENT_F_AUDIO_PLAYBACK		(MEDIA_ENT_F_BASE + 0x03002)
> >> +#define MEDIA_ENT_F_AUDIO_MIXER			(MEDIA_ENT_F_BASE + 0x03003)
> >>  
> >>  /*
> >> - * Legacy symbols used to avoid userspace compilation breakages
> >> - *
> >> - * Those symbols map the entity function into types and should be
> >> - * used only on legacy programs for legacy hardware. Don't rely
> >> - * on those for MEDIA_IOC_G_TOPOLOGY.
> >> + * Processing entity functions
> >>   */
> >> -#define MEDIA_ENT_TYPE_SHIFT		16
> >> -#define MEDIA_ENT_TYPE_MASK		0x00ff0000
> >> -#define MEDIA_ENT_SUBTYPE_MASK		0x0000ffff
> >> -
> >> -/* End of the old subdev reserved numberspace */
> >> -#define MEDIA_ENT_T_DEVNODE_UNKNOWN	(MEDIA_ENT_T_DEVNODE | \
> >> -					 MEDIA_ENT_SUBTYPE_MASK)
> >> -
> >> -#define MEDIA_ENT_T_DEVNODE		MEDIA_ENT_F_OLD_BASE
> >> -#define MEDIA_ENT_T_DEVNODE_V4L		MEDIA_ENT_F_IO_V4L
> >> -#define MEDIA_ENT_T_DEVNODE_FB		(MEDIA_ENT_T_DEVNODE + 2)
> >> -#define MEDIA_ENT_T_DEVNODE_ALSA	(MEDIA_ENT_T_DEVNODE + 3)
> >> -#define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
> >> -
> >> -#define MEDIA_ENT_T_UNKNOWN		MEDIA_ENT_F_UNKNOWN
> >> -#define MEDIA_ENT_T_V4L2_VIDEO		MEDIA_ENT_F_IO_V4L
> >> -#define MEDIA_ENT_T_V4L2_SUBDEV		MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN
> >> -#define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	MEDIA_ENT_F_CAM_SENSOR
> >> -#define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	MEDIA_ENT_F_FLASH
> >> -#define MEDIA_ENT_T_V4L2_SUBDEV_LENS	MEDIA_ENT_F_LENS
> >> -#define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	MEDIA_ENT_F_ATV_DECODER
> >> -#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	MEDIA_ENT_F_TUNER
> >> +#define MEDIA_ENT_F_PROC_VIDEO_COMPOSER		(MEDIA_ENT_F_BASE + 0x4001)
> >> +#define MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER	(MEDIA_ENT_F_BASE + 0x4002)
> >> +#define MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV	(MEDIA_ENT_F_BASE + 0x4003)
> >> +#define MEDIA_ENT_F_PROC_VIDEO_LUT		(MEDIA_ENT_F_BASE + 0x4004)
> >> +#define MEDIA_ENT_F_PROC_VIDEO_SCALER		(MEDIA_ENT_F_BASE + 0x4005)
> >> +#define MEDIA_ENT_F_PROC_VIDEO_STATISTICS	(MEDIA_ENT_F_BASE + 0x4006)
> >>  
> >> -/* Obsolete symbol for media_version, no longer used in the kernel */
> >> -#define MEDIA_API_VERSION		KERNEL_VERSION(0, 1, 0)
> >> -#endif
> >> +/*
> >> + * Switch and bridge entity functions
> >> + */
> >> +#define MEDIA_ENT_F_VID_MUX			(MEDIA_ENT_F_BASE + 0x5001)
> >> +#define MEDIA_ENT_F_VID_IF_BRIDGE		(MEDIA_ENT_F_BASE + 0x5002)
> >>  
> >>  /* Entity flags */
> >> -#define MEDIA_ENT_FL_DEFAULT		(1 << 0)
> >> -#define MEDIA_ENT_FL_CONNECTOR		(1 << 1)
> >> +#define MEDIA_ENT_FL_DEFAULT			(1 << 0)
> >> +#define MEDIA_ENT_FL_CONNECTOR			(1 << 1)
> >> +
> >> +/* OR with the entity id value to find the next entity */
> > 
> > This comment is confusing, I'd prefer to either drop or improve it. This is
> > well documented in uAPI documentation after all.
> 
> Hmm. How about:
> 
> /* Modifier flag for the media_entity_desc 'id' field */
> 
> Or, alternatively: /* Entity ID flag */
> 
> I'd like to have something, otherwise it is just a random define without a
> comment that puts it into context.

How about:

/* Flags for struct media_entity_desc id field */

Pick the one you like the best.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
