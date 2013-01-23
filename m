Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2326 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3AWSd4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 13:33:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [PATCH] tuner-core: return tuner name with ioctl VIDIOC_G_TUNER
Date: Wed, 23 Jan 2013 19:33:50 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1358883981-2645-1-git-send-email-fschaefer.oss@googlemail.com> <201301231713.55685.hverkuil@xs4all.nl> <510017E5.2010402@googlemail.com>
In-Reply-To: <510017E5.2010402@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301231933.50841.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed January 23 2013 18:03:33 Frank Schäfer wrote:
> Am 23.01.2013 17:13, schrieb Hans Verkuil:
> > On Wed January 23 2013 16:57:40 Frank Schäfer wrote:
> >> Am 23.01.2013 08:35, schrieb Hans Verkuil:
> >>> On Tue January 22 2013 20:46:21 Frank Schäfer wrote:
> >>>> tuner_g_tuner() is supposed to fill struct v4l2_tuner passed by ioctl
> >>>> VIDIOC_G_TUNER, but misses setting the name field.
> >>>>
> >>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> >>>> Cc: stable@kernel.org
> >>>> ---
> >>>>  drivers/media/v4l2-core/tuner-core.c |    1 +
> >>>>  1 Datei geändert, 1 Zeile hinzugefügt(+)
> >>>>
> >>>> diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
> >>>> index b5a819a..95a47cf 100644
> >>>> --- a/drivers/media/v4l2-core/tuner-core.c
> >>>> +++ b/drivers/media/v4l2-core/tuner-core.c
> >>>> @@ -1187,6 +1187,7 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
> >>>>  
> >>>>  	if (check_mode(t, vt->type) == -EINVAL)
> >>>>  		return 0;
> >>>> +	strcpy(vt->name, t->name);
> >>>>  	if (vt->type == t->mode && analog_ops->get_afc)
> >>>>  		vt->afc = analog_ops->get_afc(&t->fe);
> >>>>  	if (analog_ops->has_signal)
> >>>>
> >>> Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>>
> >>> And the reason is that the tuner field should be filled in by the bridge
> >>> driver. That's because you may have multiple tuners and it's only the
> >>> bridge driver that will know which tuner is which and what name to give
> >>> it.
> >> Hmmm... I don't understand.
> >> Isn't his a per-tuner (subdev) operation ? If a device has multiple
> >> tuners (subdevs) it is called for each of them.
> >> So how can the returned tuner name be wrong and why should the bridge
> >> driver know better than the subdevice itself which name is correct ?
> > The name that's filled in is exposed to userspace, so it should be something
> > meaningful and not some internal name. In the case of multiple tuners that
> > means that the name should be something like 'TV 1' or 'TV 2', where the name
> > matches a name (label) of a tuner input of the product. There is no way a
> > subdev driver can know that, only the bridge driver knows what product it is
> > and thus what the labels on the inputs are.
> 
> Hmm... I assume there is a misunderstanding about what the tuner "name"
> means and the corresponding field in struct v42l_tuner should contain...
> With the patch, the returned tuner names are e.g. "Temic PAL (4002
> FH5)", "LG PAL_BG+FM (TPI8PSB01D)" etc, which is what I expect / think
> is a correct tuner name.

That's the name of the tuner device. That's like reporting to the user
that the video input is named "saa7115 4-0021". That's not useful. It
*is* useful for us as developers, which is why such names are seen in the
kernel log.

> If it is a TV or radio tuner is defined by the "type" field and if it is
> the first / second / third / ... in the device is indeed the
> responsibility of the bridge driver. My understanding is, that both
> informations do not belong into the "name" field.
> If userspace isn't interested in the actual tuner name, it can easily
> create a simple name using the tuner "type" and "index" fields of the
> struct.

That's like saying that you don't need the name field in v4l2_input since
you can just say "Input 1", "Input 2", etc. In the case of multiple tuners
the tuner name should have some relationship with an antenna input on the
product (which may be internal as well, BTW).

Note that the only time I can see multiple tuners work is for radio receivers:
one tuner might be the current tuner, while a second tuner is testing whether
'alternate' frequencies as provided by an RDS feed have a better signal. Or
if you have different tuners each with different frequency ranges.

> 
> > ...
> >
> > The golden rule is that sub-devices should not assume anything about how they
> > are hooked up in the actual product.
> 
> Yeah, sure, but I can't see that we make such an assumption here !?

In this case it is more in the opposite direction: a subdev internal name is
exposed to userspace.

Regards,

	Hans
