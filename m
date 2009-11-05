Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-roam2.Stanford.EDU ([171.67.219.89]:41525 "EHLO
	smtp-roam.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751123AbZKEAWZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 19:22:25 -0500
Message-ID: <4AF218C9.5070103@stanford.edu>
Date: Wed, 04 Nov 2009 16:14:01 -0800
From: Eino-Ville Talvala <talvala@stanford.edu>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Neil Johnson <realdealneil@gmail.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: still image capture with video preview
References: <3d7d5c150911040913i5486bd07r3a465a2f7d2d5a3e@mail.gmail.com>	 <A69FA2915331DC488A831521EAE36FE40155833B30@dlee06.ent.ti.com> <3d7d5c150911041124r4b952303hf9c0a9e11897621d@mail.gmail.com>
In-Reply-To: <3d7d5c150911041124r4b952303hf9c0a9e11897621d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Been meaning to write a note about this for a bit - this seems like a 
good time.

I'm one of the students working on the Frankencamera at Stanford 
University (https://graphics.stanford.edu/projects/camera-2.0/), in 
collaboration with Nokia and others.  Having a live viewfinder stream 
and then quickly switching to capture one (or typically many in our 
case) full-frame images is a very basic requirement for our project.

This general use case - basic to the operation of any point-and-shoot 
camera - is one of our few frustrations with the current V4L2 
infrastructure that is very hard to work around without rearchitecting 
quite a bit of code.  Perhaps a userptr still image buffer will be a bit 
faster, but there's still quite a bit of overhead in the entire 
'streamoff-reconfigure-rebuffer-streamon' pipeline, especially if 
'streamoff/streamon', as it typically would, resets (maybe even powers 
off) and reconfigures the whole imager chip.

Our current camera is also OMAP3530 based, using the MT9P031 Aptina 
sensor via the Elphel 10338 camera tile 
(http://www3.elphel.com/importwiki?title=10338).  We have our own 
MT9P031 driver using the v4l2-int-device method (since the OMAP3 ISP 
driver we have hasn't moved to v4l2-sub-device yet), which can change 
just fine between 640x480 and 5 MP modes using the above method, but the 
latency to the user is substantial - the 'shutter lag' is very poor.  
The sensor itself can trivially switch resolutions on every frame 
boundary, as far as the datasheet claims at least (it's hard to test 
this without the software infrastructure yet), and it can certainly 
handle switching subsampling modes or the region of interest on every 
frame.  So we expect resolution switching to work just as well.

There are some hardware restrictions here as well - the OMAP3 ISP 
preview pipeline does need to know the resolution of the incoming image, 
if it is used for demosaicing/white balance/etc.  We haven't tried to 
modify the existing ISP driver (our version is behind the latest version 
by quite a bit) to see how fast it could switch sections on an off - for 
our purposes, we'd much rather capture raw Bayer data when dealing with 
the 5 MP full frames.  However, the input CCDC pipe seems to not care 
about resolution at all, so it should be able to handle an input stream 
that, say, alternates between 640x480 and 5MP on every other frame.  The 
rest of the software architecture won't, of course.

I don't know what a clear solution to this would be, at the V4L2 level.  
For the single special case of  live viewfinder->snapshot->live 
viewfinder, one could just have a 5 MP alternate buffer associated with 
the device and a vctrl that triggers the driver to store a full frame to it.

A more general approach would be to allow the V4L2 buffers to change 
size dynamically (presumably allocated from some sort of memmapped pool 
defined by the app) so that a stream of varying-resolution frames could 
be handled. This would likely complicate things for all the people who 
don't care about this sort of thing, of course.

I'm sure people more familiar with V4L2 have a better idea on how 
something like this could be implemented, and I'd be very interested in 
hearing about it - we'll likely have to try to hack a solution for 
ourselves at some point in the near future, and if anyone has a 
suggestion on the cleanest way to go about it, I'd love to know.  Our 
current plan is to use what Neil mentioned - allocate 5 MP buffers, but 
in viewfinder mode, only fill 640x480 worth of pixels, and trust our app 
to deal with it right.

While I'm at it, a second feature we'd love to see in V4L2 is some way 
to pass the sensor settings that were used for a given captured frame 
along with the buffer.  The spec currently doesn't (and can't) say 
anything about what the latency between setting the exposure vctrl, and 
receiving frames with the new exposure setting is, so writing routines 
such as autoexposure becomes much more frustrating.  The capture driver 
is the only place that might know about that relationship between 
settings and frames, and should have some way of letting the user space 
know.  We hacked up something repurposing the 'input' field as such an 
indicator, but it's very much a hack.

Thanks,

Eino-Ville (Eddy) Talvala
Camera 2.0 Project, Computer Graphics Lab
Stanford University


On 11/4/2009 11:24 AM, Neil Johnson wrote:
> Hi Murali,
>
> On Wed, Nov 4, 2009 at 11:31 AM, Karicheri, Muralidharan
> <m-karicheri2@ti.com>  wrote:
>    
>> Hi Neil,
>>
>> Interesting use case. I am thinking of doing the same for
>> vpfe capture drive and here is what I am thinking of doing.
>>      
> I started my testing with the DaVinci 6446 (using the DVEVM from TI),
> using the LeopardImaging add-on board, but we made a hardware switch
> to the OMAP3530 because of its size and low-heat characteristics.
> I've been trying to leverage existing code on the DaVinci when
> possible, but the drivers have diverged a bit.  (especially in the
> VPFE vs Camera ISP)
>
>    
>> 1) sensor driver MT9P031 configures either full capture(2592x1944)
>> (No skipping or binning) and video mode (VGA or 480p or any other
>> resolution through skipping&  binning) through S_FMT. MT9T031
>> driver in kernel is doing this already (except for supporting
>> a specific frame rate) and MT9P031 driver may do the same.
>>      
> At this point I have hard-coded the kernel to either do full capture
> or VGA/480P-sized capture.  I've been able to take full-sized still
> images when the kernel is configured that way (camera isp and sensor
> must both be configured).  I can also compile the kernel such that I
> capture 30 fps VGA or 480P (both isp and sensor configured again).
> However, when I configure the kernel to capture full-sized images
> (2592x1944), the isp gets configured upon the call to open(), so the
> previewer/resizer buffers are huge.  Then, I can configure the sensor
> to capture at a smaller resolution, but the frame rate gets reduced to
> about 5 fps.
>
> Ideally, I wouldn't allocate such large buffers if I were just
> capturing video.  I may be doing something wrong with the sensor
> configuration, so I'm exploring that.
>
>    
>> 2) Application switch the video node between these two modes (video
>> vs still capture)
>>
>> For video (may use 3 or more VGA buffers)
>>
>> using S_FMT, REQBUF, QUERYBUF (optional), mmap (optional)
>> QBUF, STREAMON...
>>
>> When ready for still capture, application do switching to still capture
>> by doing STREAMOFF, S_FMT, REQBUF (use USERPTR),
>> QBUF (one 5M buffer) and STREAMON. When finished, switch back to video
>> again. Here the switching time is critical and to be optimized.
>>      
> I'm considering this, too.  However, up to this point, all my attempts
> to use USERPTR have failed.  I need to revisit that and see where
> exactly it's failing and why.  I'm not sure that my driver fully
> supports it, and the documentation on USERPTR has been a bit scarce,
> so I may not be doing it properly.
>
>    
>> BTW, are you planning to send the mt9p031 driver for review? I was looking
>> to see if I can re-use the same in vpfe capture.
>>      
> My kernel source tree is a bit of an amalgamation from a variety of
> sources.  So, it doesn't lend itself well to creating a patch and
> sending it upstream for review.  What base should I work off of so
> that I can submit a good patch?
>
>
>    
>> Also Are you configuring video mode in sensor driver at a specific frame rate? and finally are>  you using Snapshot mode in sensor for still capture?
>>      
> I have tuned the vertical and horizontal blanking to output 720x480 at
> 30 fps.  I am using the OMAP-generated cam_clk at 36 MHz.  I have done
> some experimentation using snapshot mode, but only to test that a
> mechanical shutter opens and closes based on strobe pulses, not
> actually capturing mechanically-shuttered images yet...hopefully I'll
> be doing that soon.
>
>    
>> Thanks.
>>
>> Murali Karicheri
>> Software Design Engineer
>> Texas Instruments Inc.
>> Germantown, MD 20874
>> email: m-karicheri2@ti.com
>>
>>      
>>> -----Original Message-----
>>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>>> owner@vger.kernel.org] On Behalf Of Neil Johnson
>>> Sent: Wednesday, November 04, 2009 12:13 PM
>>> To: linux-media@vger.kernel.org
>>> Subject: still image capture with video preview
>>>
>>> linux-media,
>>>
>>> I previously posted this on the video4linux-list, but linux-media
>>> seems a more appropriate place.
>>>
>>> I am developing on the OMAP3 system using a micron/aptina mt9p031
>>> 5-megapixel imager.  This CMOs imager supports full image capture
>>> (2592x1944 pixels) or you can capture subregions using skipping and
>>> binning.  We have proven both capabilities, but would like to be able
>>> to capture both VGA sized video and still images without using
>>> separate drivers.
>>>
>>> So far, I have not found any support for capturing large images and
>>> video through a single driver interface.  Does such a capability exist
>>> within v4l2?  One possible way to solve the problem is to allocate N
>>> buffers of the full 5-megapixel size (they end up being 10-MB for each
>>> buffer since I'm using 16-bits per pixel), and then using a small
>>> portion of that for video.  This is less desirable since when I'm
>>> capturing video, I only need 640x480 size buffers, and I should only
>>> need one snapshot buffer at a time (I'm not streaming them in, just
>>> take a snapshot and go back to live video capture).  Is there a way to
>>> allocate a side-buffer for the 5-megapixel image and also allocate
>>> "normal" sized buffers for video within the same driver?  Any
>>> recommendations on how to accomplish such a thing?  I would think that
>>> camera-phones using linux would have run up against this.  Thanks,
>>>
>>> Neil Johnson
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>        
>>
>>      
>
>
>    

