Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:40940 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab1HDSdF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 14:33:05 -0400
Date: Thu, 4 Aug 2011 13:37:53 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: Media Subsystem Workshop 2011
In-Reply-To: <4E3A91D1.1040000@redhat.com>
Message-ID: <alpine.LNX.2.00.1108041255070.17533@banach.math.auburn.edu>
References: <4E398381.4080505@redhat.com> <alpine.LNX.2.00.1108031418480.16384@banach.math.auburn.edu> <4E39B150.40108@redhat.com> <alpine.LNX.2.00.1108031750241.16520@banach.math.auburn.edu> <4E3A91D1.1040000@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


(Added Hans to the reply. I already knew that he shares my concerns about 
this issue, and I am glad he has joined the discussion.)

On Thu, 4 Aug 2011, Mauro Carvalho Chehab wrote:

> Em 03-08-2011 20:20, Theodore Kilgore escreveu:
> > 
> > 
> > On Wed, 3 Aug 2011, Mauro Carvalho Chehab wrote:
> > 
> >> Em 03-08-2011 16:53, Theodore Kilgore escreveu:
> >>>
> >>>
> >>> On Wed, 3 Aug 2011, Mauro Carvalho Chehab wrote:
> >>>
> >>>> As already announced, we're continuing the planning for this year's 
> >>>> media subsystem workshop.
> >>>>
> >>>> To avoid overriding the main ML with workshop-specifics, a new ML
> >>>> was created:
> >>>> 	workshop-2011@linuxtv.org
> >>>>
> >>>> I'll also be updating the event page at:
> >>>> 	http://www.linuxtv.org/events.php
> >>>>
> >>>> Over the one-year period, we had 242 developers contributing to the
> >>>> subsystem. Thank you all for that! Unfortunately, the space there is
> >>>> limited, and we can't affort to have all developers there. 
> >>>>
> >>>> Due to that some criteria needed to be applied to create a short list
> >>>> of people that were invited today to participate. 
> >>>>
> >>>> The main criteria were to select the developers that did significant 
> >>>> contributions for the media subsystem over the last 1 year period, 
> >>>> measured in terms of number of commits and changed lines to the kernel
> >>>> drivers/media tree.
> >>>>
> >>>> As the used criteria were the number of kernel patches, userspace-only 
> >>>> developers weren't included on the invitations. It would be great to 
> >>>> have there open source application developers as well, in order to allow 
> >>>> us to tune what's needed from applications point of view. 
> >>>>
> >>>> So, if you're leading the development of some V4L and/or DVB open-source 
> >>>> application and wants to be there, or you think you can give good 
> >>>> contributions for helping to improve the subsystem, please feel free 
> >>>> to send us an email.
> >>>>
> >>>> With regards to the themes, we're received, up to now, the following 
> >>>> proposals:
> >>>>
> >>>> ---------------------------------------------------------+----------------------
> >>>> THEME                                                    | Proposed-by:
> >>>> ---------------------------------------------------------+----------------------
> >>>> Buffer management: snapshot mode                         | Guennadi
> >>>> Rotation in webcams in tablets while streaming is active | Hans de Goede
> >>>> V4L2 Spec ? ambiguities fix                              | Hans Verkuil
> >>>> V4L2 compliance test results                             | Hans Verkuil
> >>>> Media Controller presentation (probably for Wed, 25)     | Laurent Pinchart
> >>>> Workshop summary presentation on Wed, 25                 | Mauro Carvalho Chehab
> >>>> ---------------------------------------------------------+----------------------
> >>>>
> >>>> >From my side, I also have the following proposals:
> >>>>
> >>>> 1) DVB API consistency - what to do with the audio and video DVB API's 
> >>>> that conflict with V4L2 and (somewhat) with ALSA?
> >>>>
> >>>> 2) Multi FE support - How should we handle a frontend with multiple 
> >>>> delivery systems like DRX-K frontend?
> >>>>
> >>>> 3) videobuf2 - migration plans for legacy drivers
> >>>>
> >>>> 4) NEC IR decoding - how should we handle 32, 24, and 16 bit protocol
> >>>> variations?
> >>>>
> >>>> Even if you won't be there, please feel free to propose themes for 
> >>>> discussion, in order to help us to improve even more the subsystem.
> >>>>
> >>>> Thank you!
> >>>> Mauro
> >>>
> >>> Mauro,
> >>>
> >>> Not saying that you need to change the program for this session to deal 
> >>> with this topic, but an old and vexing problem is dual-mode devices. It is 
> >>> an issue which needs some kind of unified approach, and, in my opinion, 
> >>> consensus about policy and methodology.
> >>>
> >>> As a very good example if this problem, several of the cameras that I have 
> >>> supported as GSPCA devices in their webcam modality are also still cameras 
> >>> and are supported, as still cameras, in Gphoto. This can cause a collision 
> >>> between driver software in userspace which functions with libusb, and on 
> >>> the other hand with a kernel driver which tries to grab the device.
> >>>
> >>> Recent attempts to deal with this problem involve the incorporation of 
> >>> code in libusb which disables a kernel module that has already grabbed the 
> >>> device, allowing the userspace driver to function. This has made life a 
> >>> little bit easier for some people, but not for everybody. For, the device 
> >>> needs to be re-plugged in order to re-activate the kernel support. But 
> >>> some of the "user-friencly" desktop setups used by some distros will 
> >>> automatically start up a dual-mode camera with a gphoto-based program, 
> >>> thereby making it impossible for the camera to be used as a webcam unless 
> >>> the user goes for a crash course in how to disable the "feature" which has 
> >>> been so thoughtfully (thoughtlessly?) provided. 
> >>>
> >>> As the problem is not confined to cameras but also affects some other 
> >>> devices, such as DSL modems which have a partition on them and are thus 
> >>> seen as Mass Storage devices, perhaps it is time to try to find a 
> >>> systematic approach to problems like this.
> >>>
> >>> There are of course several possible approaches. 
> >>>
> >>> 1. A kernel module should handle everything related to connecting up the 
> >>> hardware. In that case, the existing userspace driver has to be modified 
> >>> to use the kernel module instead of libusb. Those who support this option 
> >>> would say that it gets everything under the control of the kernel, where 
> >>> it belongs. OTOG, the possible result is to create a minor mess in 
> >>> projects like Gphoto.
> >>>
> >>> 2. The kernel module should be abolished, and all of its functionality 
> >>> moved to userspace. This would of course involve difficulties 
> >>> approximately equivalent to item 1. An advantage, in the eyes of some, 
> >>> would be to cut down on the 
> >>> yet-another-driver-for-yet-another-piece-of-peculiar-hardware syndrome 
> >>> which obviously contributes to an in principle unlimited increase in the 
> >>> size of the kernel codebase. A disadvantage would be that it would create 
> >>> some disruption in webcam support.
> >>>
> >>> 3. A further modification to libusb reactivates the kernel module 
> >>> automatically, as soon as the userspace app which wanted to access the 
> >>> device through a libusb-based driver library is closed. This seems 
> >>> attractive, but it has certain deficiencies as well. One of them is that 
> >>> it can not necessarily provide a smooth and informative user experience, 
> >>> since circumstances can occur in which something appears to go wrong, but 
> >>> the user gets no clear message saying what the problem is. In other words, 
> >>> it is a patchwork solution which only slightly refines the current 
> >>> patchwork solution in libusb, which is in itself only a slight improvement 
> >>> on the original, unaddressed problem.
> >>>
> >>> 4. ???
> >>>
> >>> Several people are interested in this problem, but not much progress has 
> >>> been made at this time. I think that the topic ought to be put somehow on 
> >>> the front burner so that lots of people will try to think of the best way 
> >>> to handle it. Many eyes, and all that.
> >>>
> >>> Not saying change your schedule, as I said. Have a nice conference. I wish 
> >>> I could attend. But I do hope by this message to raise some general 
> >>> concern about this problem.
> > 
> > I meant this. Two ways. First, I knew when the conference was announced 
> > that it would severely conflict with the schedule of my workplace 
> > (right after the start of the academic semester). So I had simply to write 
> > off a conference which I really think I would have enjoyed attending. 
> 
> Ah, I see.

Exactly.

> 
> > Second, I am hoping to raise general interest in a rather vexing issue. 
> > The problem here, in a nutshell, originates from a conflict between user 
> > convenience and the Linux security model. Nobody wants to sacrifice either 
> > of these. More cleverness is needed.
> > 
> >>
> >> That's an interesting issue. 
> > 
> > Yes.
> > 
> >>
> >> A solution like (3) is a little bit out of scope, as it is a pure userspace
> >> (or a mixed userspace USB stack) solution.
> > 
> > And does not completely solve the problem, either. 
> > 
> >>
> >> Technically speaking, letting the same device being handled by either an
> >> userspace or a kernelspace driver doesn't seem smart to me, due to:
> >> 	- Duplicated efforts to maintain both drivers;
> >> 	- It is hard to sync a kernel driver with an userspace driver,
> >> as you've pointed.
> >>
> >> So, we're between (1) or (2). 
> >>
> >> Moving the solution entirely to userspace will have, additionally, the
> >> problem of having two applications trying to access the same hardware
> >> using two different userspace instances (for example, an incoming videoconf
> >> call while Gphoto is opened, assuming that such videoconf call would also
> >> have an userspace driver).
> > 
> > Yes, that kind of thing is an obvious problem. Actually, though, it may be 
> > that this had just better not happen. For some of the hardware that I know 
> > of, it could be a real problem no matter what approach would be taken. For 
> > example, certain specific dual-mode cameras will delete all data stored on 
> > the camera if the camera is fired up in webcam mode. To drop Gphoto 
> > suddenly in order to do the videoconf call would, on such cameras, result 
> > in the automatic deletion of all photos on the camera even if those photos 
> > had not yet been downloaded. Presumably, one would not want to do that. 
> 

Some of the sq905 cameras in particular will do this. It depends upon the 
firmware version. Indeed, for those which do, the same USB command which 
starts streaming is exploited in the Gphoto driver for deletion of all 
photos stored on the camera. For the other firmware versions, there is in 
fact no way to delete all the photos, except to push buttons on the camera 
case. This is by the way a typical example of the very rudimentary, 
minimalist interface of some of these cheap cameras.

> So, in other words, the Kernel driver should return -EBUSY if on such
> cameras, if there are photos stored on them, and someone tries to stream.

Probably, this should work the other way around, too. If not, then there 
is the question of closing the streaming in some kind of orderly fashion.

> 
> >> IMO, the right solution is to work on a proper snapshot mode, in kernelspace,
> >> and moving the drivers that have already a kernelspace out of Gphoto.
> > 
> > Well, the problem with that is, a still camera and a webcam are entirely 
> > different beasts. Still photos stored in the memory of an external device, 
> > waiting to be downloaded, are not snapshots. Thus, access to those still 
> > photos is not access to snapshots. Things are not that simple.
> 
> Yes, stored photos require a different API, as Hans pointed. 

Yes again. His observations seem to me to be saying exactly the same thing 
that I did.

> I think that some cameras
> just export them as a USB storage. For those, we may eventually need some sort of locking
> between the USB storage and V4L.

I can imagine that this could be the case. Also, to be entirely logical, 
one might imagine that a PTP camera could be fired up in streaming mode, 
too. I myself do not know of any cameras which are both USB storage and 
streaming cameras. In fact, as I understand the USB classes, such a thing 
would be in principle forbidden. However, the practical consequence could 
be that sooner or later someone is going to do just that and that deviant 
hardware is going to sell like hotcakes and we are going to get pestered. 

> 
> >> That's said, there is a proposed topic for snapshot buffer management. Maybe
> >> it may cover the remaining needs for taking high quality pictures in Kernel.
> > 
> > Again, when downloading photo images which are _stored_ on the camera one 
> > is not "taking high quality pictures." Different functionality is 
> > involved. This may involve, for example, a different Altsetting for the 
> > USB device and may also require the use of Bulk transport instead of 
> > Isochronous transport. 
> 
> Ok. The gspca driver supports it already. All we need to do is to implement a
> proper API for retrieving still photos.

Yes, I believe that Hans has some idea to do something like this:

1. kernel module creates a stillcam device as well as a /dev/video, for 
those cameras for which it is appropriate

2. libgphoto2 driver is modified so as to access /dev/camera through the 
kernel, instead of talking to the camera through libusb.

Hans has written some USB Mass Storage digital picture frame drivers for 
Gphoto, which do something similar. 

> 
> >> The hole idea is to allocate additional buffers for snapshots, imagining that
> >> the camera may be streaming in low quality/low resolution, and, once snapshot
> >> is requested, it will take one high quality/high resolution picture.
> > 
> > The ability to "take" a photo is present on some still cameras and not on 
> > others. "Some still cameras" includes some dual-mode cameras. For 
> > dual-mode cameras which can be requested to "take" a photo while running 
> > in webcam mode, the ability to do so is, generally speaking, present in 
> > the kernel driver.
> > 
> > To present the problem more simply, a webcam is, essentially, a device of 
> > USB class Video (even if the device uses proprietary protocols, this is at 
> > least conceptually true). This is true because a webcam streams 
> > video data. However, a still camera is, in its essence as a 
> > computer peripheral, a USB mass storage device (even if the device has a 
> > proprietary protocol and even if it will not do everything one would 
> > expect from a normal mass storage device). That is, a still camera can be 
> > considered as a device which contains data, and one needs to get the data 
> > from there to the computer, and then to process said data. It is when the 
> > two different kinds of device are married together in one piece of 
> > physical hardware, with the same USB Vendor:Product code, that trouble 
> > follows. 
> 
> We'll need to split the problem on all possible alternatives, as the solution
> may be different for each.

That, I think, is true.

> 
> If I understood you well, there are 4 possible ways:
> 
> 1) UVC + USB mass storage;
> 2) UVC + Vendor Class mass storage;

The two above are probably precluded by the USB specs. Which might mean 
that somebody is going to do that anyway, of course. So far, in the rare 
cases that such a thing has come up, the device itself is a "good citizen" 
in that it has two Vendor:Product codes, not just one, and something has 
to be done (pushing physical buttons, or so) to make it be seen as the 
"other kind of device" when it is plugged to the computer. 

> 3) Vendor Class video + USB mass storage;

Probably the same as the two items above.

> 4) Vendor Class video + Vendor Class mass storage.

This one is where practically all of the trouble occurs. Vendor Class 
means exactly that the manufacturer can do whatever seems clever, or 
cheap, and they do.

> 
> For (1) and (3), it doesn't make sense to re-implement USB mass storage 
> on V4L. We may just need some sort of resource locking, if the device 
> can't provide both ways at the same time.
> 
> For (2) and (4), we'll need an extra API like what Hans is proposing, 
> plus a resource locking schema.

As I said, it is difficult for me to imagine how all four cases can or 
will come up in practice. But it probably is good to include them, at 
least conceptually.

> 
> That's said, "resource locking" is currently one big problem we need to 
> solve on the media subsystem.
> 
> We have already some problems like that on devices that implement both 
> V4L and DVB API's. For example, you can't use the same tuner to watch 
> analog and digital TV at the same time. Also, several devices have I2C 
> switches. You can't, for example, poll for a RC code while the I2C 
> switch is opened for tuner access.
> 
> This is the same kind of problem, for example, that happens with 3G 
> modems that can work either as USB storage or as modem.

Yes. It does. And the matter has given similar headaches to the 
mass-storage people, which, I understand, are at least partially 
addressed. But this underscores one of my original points: this 
is a general problem, not exclusively confined to cameras or to media 
support. The fundamental problem is to deal with hardware which sits in 
two categories and does two different things. 

> 
> This sounds to be a good theme for the Workshop, or even to KS/2011.

Thanks. Do you recall when and where is KS/2011 going to take place?

Theodore Kilgore
