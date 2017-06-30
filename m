Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38794 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751690AbdF3LEJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 07:04:09 -0400
Date: Fri, 30 Jun 2017 14:03:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Helen Koike <helen.koike@collabora.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org, jgebben@codeaurora.org
Subject: Re: [PATCH RFC 1/2] [media] v4l2: add V4L2_INPUT_TYPE_DEFAULT
Message-ID: <20170630110334.r4drthh6mg445kfd@valkosipuli.retiisi.org.uk>
References: <1490889738-30009-1-git-send-email-helen.koike@collabora.com>
 <20170404132203.GE3288@valkosipuli.retiisi.org.uk>
 <551ccb38-80d1-6c7d-9c17-448ca39ac192@xs4all.nl>
 <1782674.FVlt1ogjUj@avalon>
 <ad18653c-2a1d-7444-afdb-c26a36bf00ee@collabora.com>
 <e1550d0b-7329-a6c9-0657-70ca436989b8@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1550d0b-7329-a6c9-0657-70ca436989b8@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and others,

On Mon, Jun 12, 2017 at 11:26:12AM +0200, Hans Verkuil wrote:
> On 06/06/2017 06:22 PM, Helen Koike wrote:
> > Hi All,
> > 
> > Just reviving this discussion
> > 
> > On 2017-04-07 06:53 AM, Laurent Pinchart wrote:
> > > Hi Hans,
> > > 
> > > On Friday 07 Apr 2017 11:46:48 Hans Verkuil wrote:
> > > > On 04/04/2017 03:22 PM, Sakari Ailus wrote:
> > > > > On Mon, Apr 03, 2017 at 12:11:54PM -0300, Helen Koike wrote:
> > > > > > On 2017-03-31 06:57 AM, Mauro Carvalho Chehab wrote:
> > > > > > > Em Fri, 31 Mar 2017 10:29:04 +0200 Hans Verkuil escreveu:
> > > > > > > > On 30/03/17 18:02, Helen Koike wrote:
> > > > > > > > > Add V4L2_INPUT_TYPE_DEFAULT and helpers functions for input ioctls to
> > > > > > > > > be used when no inputs are available in the device
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Helen Koike <helen.koike@collabora.com>
> > > > > > > > > ---
> > > > > > > > > drivers/media/v4l2-core/v4l2-ioctl.c | 27 +++++++++++++++++++++++++++
> > > > > > > > > include/media/v4l2-ioctl.h           | 26 ++++++++++++++++++++++++++
> > > > > > > > > include/uapi/linux/videodev2.h       |  1 +
> > > > > > > > > 3 files changed, 54 insertions(+)
> > > > > > > > > 
> > > > > > > > > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> > > > > > > > > b/drivers/media/v4l2-core/v4l2-ioctl.c index 0c3f238..ccaf04b 100644
> > > > > > > > > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > > > > > > > > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > > > > > > > > @@ -2573,6 +2573,33 @@ struct mutex *v4l2_ioctl_get_lock(struct
> > > > > > > > > video_device *vdev, unsigned cmd)
> > > > > > > > > 	return vdev->lock;
> > > > > > > > > }
> > > > > > > > > 
> > > > > > > > > +int v4l2_ioctl_enum_input_default(struct file *file, void *priv,
> > > > > > > > > +				  struct v4l2_input *i)
> > > > > > > > > +{
> > > > > > > > > +	if (i->index > 0)
> > > > > > > > > +		return -EINVAL;
> > > > > > > > > +
> > > > > > > > > +	memset(i, 0, sizeof(*i));
> > > > > > > > > +	i->type = V4L2_INPUT_TYPE_DEFAULT;
> > > > > > > > > +	strlcpy(i->name, "Default", sizeof(i->name));
> > > > > > > > > +
> > > > > > > > > +	return 0;
> > > > > > > > > +}
> > > > > > > > > +EXPORT_SYMBOL(v4l2_ioctl_enum_input_default);
> > > > > > > > > +
> > > > > > > > > +int v4l2_ioctl_g_input_default(struct file *file, void *priv,
> > > > > > > > > unsigned int *i)
> > > > > > > > > +{
> > > > > > > > > +	*i = 0;
> > > > > > > > > +	return 0;
> > > > > > > > > +}
> > > > > > > > > +EXPORT_SYMBOL(v4l2_ioctl_g_input_default);
> > > > > > > > > +
> > > > > > > > > +int v4l2_ioctl_s_input_default(struct file *file, void *priv,
> > > > > > > > > unsigned int i)
> > > > > > > > > +{
> > > > > > > > > +	return i ? -EINVAL : 0;
> > > > > > > > > +}
> > > > > > > > > +EXPORT_SYMBOL(v4l2_ioctl_s_input_default);
> > > > > > > > > +
> > > > > > > > > /* Common ioctl debug function. This function can be used by
> > > > > > > > >     external ioctl messages as well as internal V4L ioctl */
> > > > > > > > > 
> > > > > > > > > void v4l_printk_ioctl(const char *prefix, unsigned int cmd)
> > > > > > > > > diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> > > > > > > > > index 6cd94e5..accc470 100644
> > > > > > > > > --- a/include/media/v4l2-ioctl.h
> > > > > > > > > +++ b/include/media/v4l2-ioctl.h
> > > > > > > > > @@ -652,6 +652,32 @@ struct video_device;
> > > > > > > > >   */
> > > > > > > > > 
> > > > > > > > > struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev, unsigned
> > > > > > > > > int cmd);
> > > > > > > > > +
> > > > > > > > > +/**
> > > > > > > > > + * v4l2_ioctl_enum_input_default - v4l2 ioctl helper for
> > > > > > > > > VIDIOC_ENUM_INPUT ioctl
> > > > > > > > > + *
> > > > > > > > > + * Plug this function in vidioc_enum_input field of the struct
> > > > > > > > > v4l2_ioctl_ops to
> > > > > > > > > + * enumerate a single input as V4L2_INPUT_TYPE_DEFAULT
> > > > > > > > > + */
> > > > > > > > > +int v4l2_ioctl_enum_input_default(struct file *file, void *priv,
> > > > > > > > > +				  struct v4l2_input *i);
> > > > > > > > > +
> > > > > > > > > +/**
> > > > > > > > > + * v4l2_ioctl_g_input_default - v4l2 ioctl helper for VIDIOC_G_INPUT
> > > > > > > > > ioctl
> > > > > > > > > + *
> > > > > > > > > + * Plug this function in vidioc_g_input field of the struct
> > > > > > > > > v4l2_ioctl_ops
> > > > > > > > > + * when using v4l2_ioctl_enum_input_default
> > > > > > > > > + */
> > > > > > > > > +int v4l2_ioctl_g_input_default(struct file *file, void *priv,
> > > > > > > > > unsigned int *i);
> > > > > > > > > +
> > > > > > > > > +/**
> > > > > > > > > + * v4l2_ioctl_s_input_default - v4l2 ioctl helper for VIDIOC_S_INPUT
> > > > > > > > > ioctl
> > > > > > > > > + *
> > > > > > > > > + * Plug this function in vidioc_s_input field of the struct
> > > > > > > > > v4l2_ioctl_ops
> > > > > > > > > + * when using v4l2_ioctl_enum_input_default
> > > > > > > > > + */
> > > > > > > > > +int v4l2_ioctl_s_input_default(struct file *file, void *priv,
> > > > > > > > > unsigned int i);
> > > > > > > > > +
> > > > > > > > > /* names for fancy debug output */
> > > > > > > > > extern const char *v4l2_field_names[];
> > > > > > > > > extern const char *v4l2_type_names[];
> > > > > > > > > diff --git a/include/uapi/linux/videodev2.h
> > > > > > > > > b/include/uapi/linux/videodev2.h index 316be62..c10bbde 100644
> > > > > > > > > --- a/include/uapi/linux/videodev2.h
> > > > > > > > > +++ b/include/uapi/linux/videodev2.h
> > > > > > > > > @@ -1477,6 +1477,7 @@ struct v4l2_input {
> > > > > > > > > };
> > > > > > > > > 
> > > > > > > > > /*  Values for the 'type' field */
> > > > > > > > > +#define V4L2_INPUT_TYPE_DEFAULT		0
> > > > > > > > 
> > > > > > > > I don't think we should add a new type here.
> > > > > > > 
> > > > > > > I second that. Just replied the same thing on a comment from Sakari to
> > > > > > > patch 2/2.
> > > > > > > 
> > > > > > > > The whole point of this exercise is to
> > > > > > > > allow existing apps to work, and existing apps expect a TYPE_CAMERA.
> > > > > > > > 
> > > > > > > > BTW, don't read to much in the term 'CAMERA': it's really a catch all
> > > > > > > > for any video stream, whether it is from a sensor, composite input,
> > > > > > > > HDMI, etc.
> > > > > > > > 
> > > > > > > > The description for V4L2_INPUT_TYPE_CAMERA in the spec is hopelessly
> > > > > > > > out of date :-(
> > > > > > > 
> > > > > > > Yeah, we always used "CAMERA" to mean NOT_TUNER.
> > > > > > > 
> > > > > > > > Rather than creating a new type I would add a new V4L2_IN_CAP_MC
> > > > > > > > capability that indicates that this input is controlled via the media
> > > > > > > > controller. That makes much more sense and it wouldn't potentially
> > > > > > > > break applications.
> > > > > > > > 
> > > > > > > > Exactly the same can be done for outputs as well: add V4L2_OUT_CAP_MC
> > > > > > > > and use V4L2_OUTPUT_TYPE_ANALOG as the output type (again, a horrible
> > > > > > > > outdated name and the spec is again out of date).
> > > > > > > 
> > > > > > > I don't see any sense on distinguishing IN and OUT for MC. I mean:
> > > > > > > should
> > > > > > > we ever allow that any driver to have their inputs controlled via V4L2
> > > > > > > API,
> > > > > > > and their outputs controlled via MC (or vice-versa)? I don't think so.
> > > > > > > 
> > > > > > > Either all device inputs/outputs are controlled via V4L2 or via MC. So,
> > > > > > > let's call it just V4L2_CAP_MC.
> > > > > > > 
> > > > > > > > Regarding the name: should we use the name stored in struct
> > > > > > > > video_device instead? That might be more descriptive.
> > > > > > > 
> > > > > > > Makes sense to me.
> > > > > > > 
> > > > > > > > Alternatively use something like "Media Controller Input".
> > > > > > > 
> > > > > > > Yeah, we could do that, if V4L2_CAP_MC. if not, we can use the name
> > > > > > > stored at video_device.
> > > > > > 
> > > > > > Just to clarify: the V4L2_CAP_MC would indicated that the media
> > > > > > controller
> > > > > > is enabled in general? Or just for inputs and outputs?
> > > > > 
> > > > > I let Mauro and Hans to comment on their own behalf, but I think whatever
> > > > > is communicated through the input IOCTLs should be applicable to inputs
> > > > > only.
> > > > > 
> > > > > The fact that the video device is a part of an MC graph could be conveyed
> > > > > using a capability flag. Or by providing information on the media device
> > > > > node, something that has been proposed earlier on. Either is out of the
> > > > > scope of this patchset IMO, but should be addressed separately.
> > > > > 
> > > > > > If it is the first case, not necessarily the inputs/outputs are
> > > > > > controlled
> > > > > > via MC (we can still have a MC capable driver, but inputs/outputs
> > > > > > controlled via V4L2 no? When the driver doesn't offer the necessary link
> > > > > > controls via MC), then checking if V4L2_CAP_MC then use the name "Media
> > > > > > Controller Input" is not enough.
> > > > > > If it is the second case, then wouldn't it be better to name it
> > > > > > V4L2_CAP_MC_IO ?
> > > > 
> > > > It's the second case. I would probably name it V4L2_CAP_IO_MC. But I also
> > > > feel that we need a V4L2_IN/OUT_CAP_MC as well. Because the existing
> > > > V4L2_IN/OUT_CAP flags make no sense in this case.
> > > 
> > > I'm not sure to see any use for V4L2_IN/OUT_CAP_MC from an application point
> > > of view. I'd rather avoid adding flags unless there's a real use for them.
> > 
> > 
> > Just to clarify, should this capability flag be set in struct
> > v4l2_input/struct v4l2_output through VIDIOC_ENUMINPUT/,
> > VIDIOC_ENUMOUTPUT?  Or should it be set in struct v4l2_capability
> > through VIDIOC_QUERYCAP ?
> > Because if it is the first case, the I feel we should have two flags
> > V4L2_IN/OUT_CAP_MC in the API to follow the current convention, but this
> > kinda implies that we could have a driver that allows both flags to be
> > set differently.
> > Setting a V4L2_IO_CAP_MC at struct v4l2_capability would avoid this
> > interpretation.
> 
> There are two different capability flags being discussed here.
> 
> The first is V4L2_CAP_IO_MC for struct v4l2_capability: if set, then the
> inputs and outputs are controlled by the media controller and not through
> the video device.
> 
> I think everyone agrees with that capability flag.

What exactly would that capability flag tell?

That the driver implements Media controller support? Or that any pipeline
configuration works through Media controller?

We've discussed device profiles in the past. Should this capability flag
tell about a device profile? We haven't documented the profiles, but in
practice the V4L2 video nodes are a data interface only on MC-enabled
drivers. That suggests that if there is input selection to be done, that
would take place on a control interface, i.e. on a V4L2 sub-device node.

I think it'd be good to have a single flag for this rather than small hints
here and there of what kind of an interface the user is dealing with.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
