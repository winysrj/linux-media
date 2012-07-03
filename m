Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:7694 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2GCHTN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2012 03:19:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC PATCH 1/6] videodev2.h: add VIDIOC_ENUM_FREQ_BANDS.
Date: Tue, 3 Jul 2012 09:19:10 +0200
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1341238512-17504-1-git-send-email-hverkuil@xs4all.nl> <f8baa47c370e4d79309e126b56127df8a5edd11a.1341237775.git.hans.verkuil@cisco.com> <4FF1DD89.1070209@redhat.com>
In-Reply-To: <4FF1DD89.1070209@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207030919.11090.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 2 July 2012 19:42:33 Mauro Carvalho Chehab wrote:
> Em 02-07-2012 11:15, Hans Verkuil escreveu:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Add a new ioctl to enumerate the supported frequency bands of a tuner.
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >   include/linux/videodev2.h |   36 ++++++++++++++++++++++++++----------
> >   1 file changed, 26 insertions(+), 10 deletions(-)
> > 
> > diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> > index f79d0cc..d54ec6e 100644
> > --- a/include/linux/videodev2.h
> > +++ b/include/linux/videodev2.h
> > @@ -2048,6 +2048,7 @@ struct v4l2_modulator {
> >   #define V4L2_TUNER_CAP_RDS		0x0080
> >   #define V4L2_TUNER_CAP_RDS_BLOCK_IO	0x0100
> >   #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
> > +#define V4L2_TUNER_CAP_FREQ_BANDS	0x0400
> >   
> >   /*  Flags for the 'rxsubchans' field */
> >   #define V4L2_TUNER_SUB_MONO		0x0001
> > @@ -2066,19 +2067,30 @@ struct v4l2_modulator {
> >   #define V4L2_TUNER_MODE_LANG1_LANG2	0x0004
> >   
> >   struct v4l2_frequency {
> > -	__u32		      tuner;
> > -	__u32		      type;	/* enum v4l2_tuner_type */
> > -	__u32		      frequency;
> > -	__u32		      reserved[8];
> > +	__u32	tuner;
> > +	__u32	type;	/* enum v4l2_tuner_type */
> > +	__u32	frequency;
> > +	__u32	reserved[8];
> > +};
> > +
> > +struct v4l2_frequency_band {
> > +	__u32	tuner;
> > +	__u32	type;	/* enum v4l2_tuner_type */
> > +	__u32	index;
> > +	__u32	capability;
> > +	__u32	rangelow;
> > +	__u32	rangehigh;
> > +	__u8	name[32];
> 
> As we've discussed, band name can be inferred from the frequency.
> Also, there are more than one name for the same band (it could be
> named based on the wavelength or frequency - also, some bands or
> band segments may have special names, like Tropical Wave).
> Let's userspace just call it whatever it wants. So, I'll just
> drop it.

That will lead to chaos IMHO: one application will call it one thing,
the other something else. Since the frequency band boundaries will
generally be slightly different between different products it is even
not so easy to map a frequency to a particular name. Not to mention
the simple fact that most apps will only ever see FM since the number of
products that support other bands is very, very small.

Sure, an application can just print the frequency range and use that
as the name, but how many end-users would know how to interpret that as
FM or AM MW, etc.? Very few indeed.

> 
> On the other hand, the modulation is independent on the band, and
> ITU-R and regulator agencies may allow more than one modulation type
> and usage for the same frequency (like primary and secondary usage).

But the actual tuner/demod in question will support only one modulation
type per frequency range. It's not something you can change in our API. So
what's the use of such a modulation type? What would an application do with
it? I want to avoid adding a field for which there is no practical use.

This API is used to show a combobox or similar to the end-user allowing him/her
to select a frequency band that the radio application will use. So you need
human-readable names for the frequency bands that are understandable for
your average human being. Frequency ranges or talk about ITU standards are
NOT suitable for that.

Prior to me becoming involved in this discussion the only names I would have
understood are FM and AM SW/MW/LW and I would have no idea what the frequency
ranges for the AM bands were.

Regards,

	Hans

> So, it makes sense to have an enum here to describe the modulation type
> (currenly, AM, FM and VSB).
> 
> > +	__u32	reserved[6];
> >   };
> >   
> >   struct v4l2_hw_freq_seek {
> > -	__u32		      tuner;
> > -	__u32		      type;	/* enum v4l2_tuner_type */
> > -	__u32		      seek_upward;
> > -	__u32		      wrap_around;
> > -	__u32		      spacing;
> > -	__u32		      reserved[7];
> > +	__u32	tuner;
> > +	__u32	type;	/* enum v4l2_tuner_type */
> > +	__u32	seek_upward;
> > +	__u32	wrap_around;
> > +	__u32	spacing;
> > +	__u32	reserved[7];
> >   };
> >   
> >   /*
> > @@ -2646,6 +2658,10 @@ struct v4l2_create_buffers {
> >   #define VIDIOC_QUERY_DV_TIMINGS  _IOR('V', 99, struct v4l2_dv_timings)
> >   #define VIDIOC_DV_TIMINGS_CAP   _IOWR('V', 100, struct v4l2_dv_timings_cap)
> >   
> > +/* Experimental, this ioctl may change over the next couple of kernel
> > +   versions. */
> > +#define VIDIOC_ENUM_FREQ_BANDS	_IOWR('V', 101, struct v4l2_frequency_band)
> > +
> >   /* Reminder: when adding new ioctls please add support for them to
> >      drivers/media/video/v4l2-compat-ioctl32.c as well! */
> >   
> > 
> 
> 
