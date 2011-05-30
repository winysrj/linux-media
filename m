Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3486 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab1E3HPE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 May 2011 03:15:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv2] Add a library to retrieve associated media devices - was: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
Date: Mon, 30 May 2011 09:14:59 +0200
Cc: Hans de Goede <hdegoede@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4DDAC0C2.7090508@redhat.com> <4DE24A84.5030909@redhat.com> <4DE25E6A.5080900@redhat.com>
In-Reply-To: <4DE25E6A.5080900@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105300914.59674.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, May 29, 2011 16:55:38 Mauro Carvalho Chehab wrote:
> Em 29-05-2011 10:30, Hans de Goede escreveu:
> > Hi,
> > 
> > On 05/29/2011 03:08 PM, Mauro Carvalho Chehab wrote:
> >> Em 29-05-2011 08:54, Hans de Goede escreveu:
> >>> Hi,
> >>>
> >>> On 05/29/2011 01:19 PM, Hans Verkuil wrote:
> >>>> Hi Mauro,
> >>>>
> >>>> Thanks for the RFC! Some initial comments below. I'll hope to do some more
> >>>> testing and reviewing in the coming week.
> >>>>
> >>>
> >>> <Snip>
> >>>
> >>>>> c) get_not_associated_device: Returns the next device not associated with
> >>>>>                    an specific device type.
> >>>>>
> >>>>> char *get_not_associated_device(void *opaque,
> >>>>>                  char *last_seek,
> >>>>>                  enum device_type desired_type,
> >>>>>                  enum device_type not_desired_type);
> >>>>>
> >>>>> The parameters are:
> >>>>>
> >>>>> opaque:            media devices opaque descriptor
> >>>>> last_seek:        last seek result. Use NULL to get the first result
> >>>>> desired_type:        type of the desired device
> >>>>> not_desired_type:    type of the seek device
> >>>>>
> >>>>> This function seeks inside the media_devices struct for the next physical
> >>>>> device that doesn't support a non_desired type.
> >>>>> This method is useful for example to return the audio devices that are
> >>>>> provided by the motherboard.
> >>>>
> >>>> Hmmm. What you really want IMHO is to iterate over 'media hardware', and for
> >>>> each piece of hardware you can find the associated device nodes.
> >>>>
> >>>> It's what you expect to see in an application: a list of USB/PCI/Platform
> >>>> devices to choose from.
> >>>
> >>> This is exactly what I was thinking, I was think along the lines of making
> >>> the device_type enum bitmasks instead, and have a list devices functions,
> >>> which lists all the "physical" media devices as "describing string",
> >>> capabilities pairs, where capabilities would include things like sound
> >>> in / sound out, etc.
> >>
> >> A bitmask for device_type in practice means that we'll have just 32 (or 64)
> >> types of devices. Not sure if this is enough in the long term.
> >>
> > 
> > Ok, so we may need to use a different mechanism. I'm trying to think from
> > the pov of what the average app needs when it comes to media device discovery,
> > and what it needs is a list of devices which have the capabilities it needs
> > (like for example video input). As mentioned in this thread earlier it might
> > be an idea to add an option to this new lib to filter the discovered
> > devices. We could do that, but with a bitmask containing capabilities, the
> > user of the lib can easily iterate over all found devices itself and
> > discard unwanted ones itself.
> 
> I think that one of the issues of the current device node name is that the
> kernel just names all video devices as "video???", no matter if such device
> is a video output device, a video input device, an analog TV device or a
> webcam.
> 
> IMO, we should be reviewing this policy, for example, to name video output
> devices as "video_out", and webcams as "webcam", and let udev to create
> aliases for the old namespace.

What categories of video devices do we have?

- video (TV, HDMI et al) input
- video output
- sensor input (webcam-like)
- mem2mem devices (input and/or output)
- MPEG (compressed video) input
- MPEG (compressed video) output
- Weird: ivtv still captures audio over a video node, there may be others.

My understanding is that in practice the difference between webcam and video
input isn't that important (since you could hook up a camera to a video input
device I'm not even sure that you should make that difference). But input,
output, mem2mem is important. And so is compressed vs uncompressed.

Creating video_out and video_m2m nodes doesn't seem unreasonable to me.

I don't know how to signal compressed vs uncompressed, though. Currently
this is done through ENUM_FMT so it doesn't lend itself to using a different
video node name, even though in practice video device nodes do not switch
between compressed and uncompressed. But that's the case today and may not
be true tomorrow. The whole UVC H.264 mess that Laurent is looking into
springs to mind.

> >> Grouping the discovered information together is not hard, but there's one
> >> issue if we'll be opening devices to retrieve additional info: some devices
> >> do weird stuff at open, like retrieving firmware, when the device is waking
> >> from a suspend state. So, the discover procedure that currently happens in
> >> usecs may take seconds. Ok, this is, in fact, a driver and/or hardware trouble,
> >> but I think that having a separate method for it is a good idea.
> > 
> > WRT detection speed I agree we should avoid opening the nodes where possible,
> > so I guess that also means we may want a second "give me more detailed info"
> > call which an app can do an a per device (function) basis, or we could
> > leave this to the apps themselves.
> 
> I'm in favour of a "more detailed info" call.

+1

Regards,

	Hans
