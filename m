Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1599 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab2GCQsQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2012 12:48:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC PATCH 1/6] videodev2.h: add VIDIOC_ENUM_FREQ_BANDS.
Date: Tue, 3 Jul 2012 18:47:38 +0200
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1341238512-17504-1-git-send-email-hverkuil@xs4all.nl> <201207030919.11090.hverkuil@xs4all.nl> <4FF3176F.6050304@redhat.com>
In-Reply-To: <4FF3176F.6050304@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207031847.38946.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue July 3 2012 18:01:51 Mauro Carvalho Chehab wrote:
> Em 03-07-2012 04:19, Hans Verkuil escreveu:
> > On Mon 2 July 2012 19:42:33 Mauro Carvalho Chehab wrote:
> >> Em 02-07-2012 11:15, Hans Verkuil escreveu:
> >>> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>>
> >>> Add a new ioctl to enumerate the supported frequency bands of a tuner.
> >>>
> >>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>> ---
> >>>    include/linux/videodev2.h |   36 ++++++++++++++++++++++++++----------
> >>>    1 file changed, 26 insertions(+), 10 deletions(-)
> >>>
> >>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> >>> index f79d0cc..d54ec6e 100644
> >>> --- a/include/linux/videodev2.h
> >>> +++ b/include/linux/videodev2.h
> >>> @@ -2048,6 +2048,7 @@ struct v4l2_modulator {
> >>>    #define V4L2_TUNER_CAP_RDS		0x0080
> >>>    #define V4L2_TUNER_CAP_RDS_BLOCK_IO	0x0100
> >>>    #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
> >>> +#define V4L2_TUNER_CAP_FREQ_BANDS	0x0400
> >>>    
> >>>    /*  Flags for the 'rxsubchans' field */
> >>>    #define V4L2_TUNER_SUB_MONO		0x0001
> >>> @@ -2066,19 +2067,30 @@ struct v4l2_modulator {
> >>>    #define V4L2_TUNER_MODE_LANG1_LANG2	0x0004
> >>>    
> >>>    struct v4l2_frequency {
> >>> -	__u32		      tuner;
> >>> -	__u32		      type;	/* enum v4l2_tuner_type */
> >>> -	__u32		      frequency;
> >>> -	__u32		      reserved[8];
> >>> +	__u32	tuner;
> >>> +	__u32	type;	/* enum v4l2_tuner_type */
> >>> +	__u32	frequency;
> >>> +	__u32	reserved[8];
> >>> +};
> >>> +
> >>> +struct v4l2_frequency_band {
> >>> +	__u32	tuner;
> >>> +	__u32	type;	/* enum v4l2_tuner_type */
> >>> +	__u32	index;
> >>> +	__u32	capability;
> >>> +	__u32	rangelow;
> >>> +	__u32	rangehigh;
> >>> +	__u8	name[32];
> >>
> >> As we've discussed, band name can be inferred from the frequency.
> >> Also, there are more than one name for the same band (it could be
> >> named based on the wavelength or frequency - also, some bands or
> >> band segments may have special names, like Tropical Wave).
> >> Let's userspace just call it whatever it wants. So, I'll just
> >> drop it.
> > 
> > That will lead to chaos IMHO: one application will call it one thing,
> > the other something else. Since the frequency band boundaries will
> > generally be slightly different between different products it is even
> > not so easy to map a frequency to a particular name. Not to mention
> > the simple fact that most apps will only ever see FM since the number of
> > products that support other bands is very, very small.
> > 
> > Sure, an application can just print the frequency range and use that
> > as the name, but how many end-users would know how to interpret that as
> > FM or AM MW, etc.? Very few indeed.
> 
> AM or FM can be retrieved from a modulation field. The band range is:
> 	1) Country-dependent, e. g. they're defined by the regulator's
> 	   agency on each Country and standardized on ITU-R;
> 
> 	2) Per-country regulatory restrictions may apply, as it may be
> illegal or it may be required an special license to operate outside the 
> public services range. Some of the supported devices for can be used
> at the amateur radio range
> 
> 	3) requires locale support. For example, in Brazil:
> 		short wave is OC
> 		medium wave is OM
> 		part of the OC band is called Tropical wave
> 		...
> 
> Devices with dual TV/FM tuners allows a band that it is larger than SW+MW+LW.
> How would you call such band?
> 
> What I'm saying is that an application that would properly implement radio
> support will need to have a per-Country regulatory data, in order to name
> a band, using the Country's denomination for that band.
> 
> It is not a Kernel's task to keep such database. It may be added on a library,
> through.
> 
> >> On the other hand, the modulation is independent on the band, and
> >> ITU-R and regulator agencies may allow more than one modulation type
> >> and usage for the same frequency (like primary and secondary usage).
> > 
> > But the actual tuner/demod in question will support only one modulation
> > type per frequency range. It's not something you can change in our API. So
> > what's the use of such a modulation type? What would an application do with
> > it? I want to avoid adding a field for which there is no practical use.
> 
> Devices like bttv and cx88 with a TV/FM tuner allow at least 2 modulation types:
> FM and SDR (Software Delivered Radio), as the internal RISC processor can deliver
> the IF samples though the DMA engine, allowing demodulation in userspace.
> 
> > This API is used to show a combobox or similar to the end-user allowing him/her
> > to select a frequency band that the radio application will use. So you need
> > human-readable names for the frequency bands that are understandable for
> > your average human being. Frequency ranges or talk about ITU standards are
> > NOT suitable for that.
> 
> It is not a Kernel's task to present a combobox. Also, converting the radio
> band names into a combobox will require converting the band names into locale
> data, with is more complex, less portable than to compare the band ranges with 
> the ITU-R tables.
> 
> That's said, let's suppose an application that would allow to select between:
> 	- FM Europe/America;
> 	- FM Japan;
> 	- FM Russia
> 
> And let's suppose 2 different drivers:
> 	- driver 1: bttv + TV/FM tuner - band from 56 MHz to 165 MHz;
> 	- driver 2: tea5767 - japan band from 76 to 108 MHz;
> 		    european band from 87.5 to 108 MHz;
> 
> For driver 1, the band will be bigger than all 3 FM ranges. Userspace will need
> to use S_TUNER to adjust the single band to the selected one, or to prevent
> using a frequency outside band;
> 
> For driver 2, for euro band, it can just select the second band. However, for
> band 1, it will need to use S_TUNER to restrict the maximum frequency to 90 MHz,
> in order to match the regulatory band.
> 
> So, whatever "name" would be used, the userspace will need to know what are the
> regulatory standards and use some logic to make sure that the proper band will
> be used.
> 
> Of course, as such logic is common for all radio applications, it makes sense to
> add it into a radio v4l-utils library.
> 
> > Prior to me becoming involved in this discussion the only names I would have
> > understood are FM and AM SW/MW/LW and I would have no idea what the frequency
> > ranges for the AM bands were.
> 
> Well, the sort wave range is actually 15 bands, each with their own regulations.
> For example, In Brazil, SW is used by broadcast and amateur radio. For amateur
> radio, those are the used ranges:
> 	160m, 80m, 40m, 30m, 20m, 17m, 15m, 12m, 10m
> 
> In summary, band names can't be properly represented in Kernel, as this is not
> a trivial issue, nor Kernel should bother about localized names or per-Country
> data.

You clearly have way too much knowledge on this topic :-)

OK, name is out, a modulation field is in.

This promptly leads to the next problem: there is no modulation field in v4l2_tuner,
so what to do for existing drivers.

It makes sense to have the tuner capability field be a union of the caps of all bands,
but you can't do the same for a modulation field (unless you make it a bitfield, but
that's just weird IMHO).

So perhaps we should add compat code like what I suggested earlier in a private email
where, if no enum_freq_bands op is defined but g_tuner is, then the core will provide
a enum_freq_bands version that uses the caps/rangelow/high from g_tuner and that can
fill in the modulation type based on the video node (i.e. if called from radio, then
the modulation is FM, else VSB).

This is true for all currently available drivers, except for radio-cadet. But the
latter will be updated with proper enum_freq_bands support, so it won't use the
compat code.

As a result of this, an application can always find the modulation of a particular
frequency band by calling VIDIOC_ENUM_FREQ_BANDS.

Note that for the sake of brevity I'm ignoring the modulator in this discussion, but
the same principle applies there.

BTW, if I understand it correctly SDR isn't a modulation type as such, it's the raw
output from the tuner and it is up to the software to decide whether to demodulate
as FM or AM (in the case of analog radio), right? Although in practice I expect it
to be obvious what should be used.

Regards,

	Hans
