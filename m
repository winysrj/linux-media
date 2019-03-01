Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40932C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 10:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0443F2083D
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 10:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbfCAKTR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 05:19:17 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:35438 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfCAKTR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Mar 2019 05:19:17 -0500
Received: from [IPv6:2001:983:e9a7:1:28f6:efa6:3b03:d09a] ([IPv6:2001:983:e9a7:1:28f6:efa6:3b03:d09a])
        by smtp-cloud8.xs4all.net with ESMTPA
        id zfFygpezA4HFnzfFzgWtAy; Fri, 01 Mar 2019 11:19:13 +0100
Subject: Re: [PATCH v2] media: vim2m: better handle cap/out buffers with
 different sizes
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
References: <8d0a822ce02e1eb95f4a59cc9aabceb5a5661dda.1551202576.git.mchehab+samsung@kernel.org>
 <84696204-2b3a-74ed-f470-52cc54fa201b@xs4all.nl>
 <20190228110914.0b2613eb@coco.lan>
 <4cc0d8e1-7e25-1b9d-8bfe-921716522909@xs4all.nl>
 <20190228122139.6ac6c25d@coco.lan>
 <170efbf2-794a-7314-179d-d5c4af4d7e57@xs4all.nl>
 <20190228143124.3953adff@coco.lan>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <01f029cc-1e2b-524c-5db8-4cd87c18b669@xs4all.nl>
Date:   Fri, 1 Mar 2019 11:19:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190228143124.3953adff@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfLQpijgxnyviIrzzVnn50g9J1a2GZACi+bP70PwRD3A6pIMR8KOVu4w1K4YZe/+BmwE5EW4JqtsXgwkHvlK0uY3MDZqxEpuIsr8PxtMCNWa2vBZOsi4S
 o4rBxYw1goah87if60fcaEunNwDmkMYlOVghArwaJm3rr/njnX9t2zgUtfCDrCjDHcpQyadq/VR9TE+MkEW3+IpLaIqztlHS8M5YhJHOJEVPlm59TBsZsqXq
 aba6U/8E9lp9XZ/0UQkP/NQKUFget1+zbx0w+UjnKq78v+Hmgd3GYRAtjgeQb6VXiURrZ3or9AMAw2GQrzfQ+VG6TMLGT6JccaWTRIubSdtLR+CIhIiKdcvM
 Jt9LZeHWiFOm/1C6wvzu60guMi1vD4TfY/LFJXNbmLTFJlovLfZeHhoG6w7rFiHjJluPzTXB
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/28/19 6:31 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 28 Feb 2019 16:42:28 +0100
> Hans Verkuil <hverkuil-cisco@xs4all.nl> escreveu:
> 
>> On 2/28/19 4:21 PM, Mauro Carvalho Chehab wrote:
>>> Em Thu, 28 Feb 2019 15:35:07 +0100
>>> Hans Verkuil <hverkuil-cisco@xs4all.nl> escreveu:
>>>   
>>>> On 2/28/19 3:09 PM, Mauro Carvalho Chehab wrote:  
>>>>> Em Thu, 28 Feb 2019 13:30:49 +0100
>>>>> Hans Verkuil <hverkuil-cisco@xs4all.nl> escreveu:
>>>>>     
>>>>>> On 2/26/19 6:36 PM, Mauro Carvalho Chehab wrote:    
>>>>>>> The vim2m driver doesn't enforce that the capture and output
>>>>>>> buffers would have the same size. Do the right thing if the
>>>>>>> buffers are different, zeroing the buffer before writing,
>>>>>>> ensuring that lines will be aligned and it won't write past
>>>>>>> the buffer area.      
>>>>>>
>>>>>> I don't really like this. Since the vimc driver doesn't scale it shouldn't
>>>>>> automatically crop either. If you want to crop/compose, then the
>>>>>> selection API should be implemented.
>>>>>>
>>>>>> That would be the right approach to allowing capture and output
>>>>>> formats (we're talking formats here, not buffer sizes) with
>>>>>> different resolutions.    
>>>>>
>>>>> The original vim2m implementation assumes that this driver would
>>>>> "scale" and do format conversions (except that it didn't do neither).    
>>>>
>>>> I'm not sure we should assume anything about the original implementation.
>>>> It had lots of issues. I rather do this right then keep supporting hacks.  
>>>
>>> True, but we are too close to the merge window. That's why I opted on
>>> solving the bug, and not changing the behavior.  
>>
>> Then that should be documented in the commit log: i.e. it is a temporary
>> fix until we have a better solution. I'm fine with that.
> 
> Ok, I'll add it at version 3.
> 
>>
>>>   
>>>>  
>>>>> While I fixed the format conversion on a past patchset, vim2m
>>>>> still allows a "free" image size on both sides of the pipeline.
>>>>>
>>>>> I agree with you that the best would be to implement a scaler
>>>>> (and maybe crop/compose), but for now, we need to solve an issue that
>>>>> vim2m is doing a very poor job to confine the image at the destination
>>>>> buffer's resolution.
>>>>>
>>>>> Also, as far as I remember, the first M2M devices have scalers, so
>>>>> existing apps likely assume that such devices will do scaling.    
>>>>
>>>> Most m2m devices are codecs and codecs do not do scaling (at least,
>>>> I'm not aware of any).  
>>>
>>> At least on GStreamer, codecs are implemented on a separate logic.
>>> GStreamer checks it using the FOURCC types. If one of the sides is
>>> compressed, it is either an encoder or a decoder. Otherwise, it is
>>> a transform device.
>>>
>>> From what I understood from the code (and from my tests), it
>>> assumes that scaler is supported for transform devices.  
>>
>> I find it hard to believe that it assumes a transform device can always
>> scale. Nicolas?
> 
> Provided that you have gst-plugins-good compiled with --enable-v4l2-probe
> (needed in order to enable M2M support), you can easily test it with:
> 
> $ gst-launch-1.0 videotestsrc num-buffers=120 ! video/x-raw,format=RGB,width=322,height=200 ! v4l2convert disable-passthrough=1 ! video/x-raw,width=428,height=400 ! videoconvert ! xvimagesink
> 
> At dmesg, you'll see:
> 
> [246685.031750] vim2m vim2m.0: vidioc_s_fmt: Format for type Output: 322x200 (24 bpp), fmt: RGB3
> [246685.032300] vim2m vim2m.0: vidioc_s_fmt: Format for type Capture: 428x400 (24 bpp), fmt: RGB3
> 
> Note: that's the Gstreamer 1.5.x syntax. "v4l2convert" has a different
> name on version 1.4.x.. There, you should use "v4l2video0convert" instead:
> 
> $ gst-launch-1.0 videotestsrc num-buffers=120 ! video/x-raw,format=RGB,width=322,height=200 ! v4l2video0convert disable-passthrough=1 ! video/x-raw,width=428,height=400 ! videoconvert ! xvimagesink

But you explicitly set different resolutions for source and sink.
What happens in gstreamer if the driver doesn't support scaling? Will
gstreamer continue with wrong values? Give an error?

> 
>>
>>>   
>>>> I don't think there are many m2m devices that do scaling: most do
>>>> format conversion of one type or another (codecs, deinterlacers,
>>>> yuv-rgb converters). Scalers tend to be integrated into a video
>>>> pipeline. The only m2m drivers I found that also scale are
>>>> exynos-gsc, ti-vpe, mtk-mdp and possibly sti/bdisp.  
>>>
>>> Well, the M2M API was added with Exynos. 
>>>   
>>>>>
>>>>> So, a non-scaling M2M device is something that, in thesis, we don't
>>>>> support[1].
>>>>>
>>>>> [1] Very likely we have several ones that don't do scaling, but the
>>>>> needed API bits for apps to detect if scaling is supported or not
>>>>> aren't implemented.
>>>>>
>>>>> The problem of enforcing the resolution to be identical on both capture
>>>>> and output buffers is that the V4L2 API doesn't really have
>>>>> a way for userspace apps to identify that it won't scale until
>>>>> too late.
>>>>>
>>>>> How do you imagine an application negotiating the image resolution?
>>>>>
>>>>> I mean, application A may set first the capture buffer to, let's say,
>>>>> 320x200 and then try to set the output buffer. 
>>>>>
>>>>> Application B may do the reverse, e. g. set first the output buffer
>>>>> to 320x200 and then try to set the capture buffer.
>>>>>
>>>>> Application C could try to initialize with some default for both 
>>>>> capture and output buffers and only later decide what resolution
>>>>> it wants and try to set both sides.
>>>>>
>>>>> Application D could have setup both sides, started streaming at 
>>>>> 320x200. Then, it stopped streaming and changed the capture 
>>>>> resolution to, let's say 640x480, without changing the resolution
>>>>> of the output buffer.
>>>>>
>>>>> For all the above scenarios, the app may either first set both
>>>>> sides and then request the buffer for both, or do S_FMT/REQBUFS
>>>>> for one side and then to the other side.
>>>>>
>>>>> What I mean is that, wit just use the existing ioctls and flags, I 
>>>>> can't see any way for all the above scenarios work on devices that
>>>>> don't scale.    
>>>>
>>>> If the device cannot scale, then setting the format on either capture
>>>> or output will modify the format on the other side as well.  
>>>
>>> That's one way to handle it, but what happens if buffers were already
>>> allocated at one side?  
>>
>> Then trying to change the format on the other side will simply return
>> the current format.
> 
> That's one way to handle that, but it somewhat violates the V4L2 API,
> as this kind of thing was never enforced.

I don't see how this violates the spec. There is never any guarantee that
the format that you set is also the format that it returned.

> 
>>
>>  If the buffer is USERPTR, this is even worse,
>>> as the size may not fit the image anymore.  
>>
>> That's why you shouldn't remove the check in buf_prepare :-)
> 
> Yeah, sure.
> 
>>
>>>
>>> Also, changing drivers to this new behavior could break some stuff.  
>>
>> I'm not at all certain if all m2m drivers are safe when in comes to this.
>> The v4l2-compliance testing for m2m devices has always lagged behind the
>> testing for non-m2m devices, so we don't do in-depth tests. Otherwise we'd
>> found this vim2m issue a long time ago.
> 
> Yes. Btw, this kind of test is a good candidate for v4l2-compliance,
> once we define the proper behavior.
> 
>>
>> And I don't think it is new behavior. When it comes to m2m devices
>> they just behave according to the standard v4l2 behavior: the driver
>> always tries to fulfill the last ioctl to the best of its ability.
> 
> Yes, but in this case, it violates a basic concept: it is overriding
> the resolution that was set before for a separate part of the pipeline.
> 
> I doubt any application would expect this kind of behavior and re-check.
> 
> I'm not saying I'm against it, but it doesn't look right to do that on
> my eyes. Yet, not sure what other options we would have.

I went through the spec to see where we need to improve the documentation.

There are several levels of ioctls that can influence others:

S_INPUT/OUTPUT: these should come first since changing input or output
can reset everything else.

This is clearly stated for ioctls.

Next are S_STD and S_DV_TIMINGS: these can change the format and any
cropping/composing rectangles. Neither makes any mention of this.

This should be fixed.

Note that the Data Formats section (1.22) makes implicit mention of this
("A video standard change ... can invalidate the selected image format.").
But that isn't quite right: it doesn't invalidate it, it only changes it.
As an aside, there are more issues with this section since it says that
setting the format 'assigns a logical stream exclusively to one file
descriptor', but that's wrong. It is when buffers are allocated that this
happens.

S_FMT and S_SELECTION (and S_CROP): sadly only S_CROP makes any mention
that changing the crop rectangle can also change the format.

In practice changing for the format can change any existing crop/compose
rectangles and vice versa. This is so dependent on hardware constraints
that it is hard to say anything specific.

The general rule is that the driver will do its best to satisfy the
request. It's mentioned in section 1.22.1: "Negotiation means the
application asks for a particular format and the driver selects and
reports the best the hardware can do to satisfy the request."

Unfortunately it is not clear from the text that crop/compose is part
of the negotiation and follows the same rule.

> 
>> That said, this has never been made explicit in the spec.
> 
> Well, we need to make it clear, and a way for userspace to know if
> it will scale or just override the last setting.
> 
>>> (with this particular matter, changing vim2m code doesn't count as a
>>> change, as this driver should not be used in production - but if any
>>> other driver is doing something different, then we're limited to do
>>> such change)
>>>   
>>>>
>>>> If the device also support cropping and composing, then it becomes
>>>> more complicated, but the basics remain the same.
>>>>  
>>>
>>> I suspect that the above are just assumptions (and perhaps the current
>>> implementation on most drivers). At least, I was unable to find any mention
>>> about the M2M chapter at the V4L2 specs.
>>>   
>>>> It would certainly be nice if there was a scaling capability. I suspect
>>>> one reason that nobody requested this is that you usually know what
>>>> you are doing when you use an m2m device.  
>>>
>>> And that's a bad assumption, as it prevents having generic apps
>>> using it. The expected behavior for having and not having scaler
>>> should be described, and we need to be able to cope with legacy stuff.  
>>
>> We should likely write up something similar as what we are doing for
>> the codec documentation, but then for m2m transform devices.
> 
> Yes.
> 
>>
>>>   
>>>>  
>>>>> One solution would be to filter the output of ENUM_FMT, TRY_FMT,
>>>>> G_FMT and S_FMT when one of the sides of the M2M buffer is set,
>>>>> but that would break some possible real usecases.    
>>>>
>>>> Not sure what you mean here.  
>>>
>>> I mean that one possible solution would be that, if one side sets 
>>> resolution, the answer for the ioctls on the other side would be
>>> different. IMHO, that's a bad idea.
>>>   
>>>>>
>>>>> I suspect that the option that it would work best is to have a
>>>>> flag to indicate that a M2M device has scalers.
>>>>>
>>>>> In any case, this should be discussed and properly documented
>>>>> before we would be able to implement a non-scaling M2M device.    
>>>>
>>>> I don't know where you get the idea that most m2m devices scale.
>>>> The reverse is true, very few m2m devices have a scaler.  
>>>
>>> No, I didn't say that most m2m devices scale. I said that the initial
>>> M2M implementations scale, and that's probably one of the reasons why 
>>> this is the behavior that Gstreamer expects scales on transform devices.  
>>
>> Well, it doesn't really matter. The fact is that gstreamer apparently
>> makes assumptions that are not in general valid.
>>
>> And all this is made worse by insufficiently detailed documentation and
>> insufficient compliance testing.
> 
> Well, any change now would break an existing userspace app, and this is
> something we shouldn't do. Worse than that, I suspect that Gstreamer is
> actually used on several custom platform-dependent media applications.
> 
>> Patches are welcome.
> 
> I know. Need to think a little bit more about what would be the best
> solution for it though. We have very few space at VIDIOC_QUERYCAP, and
> I'm not sure if a "HAVE_SCALER" flag would belong there.

We have a u32 reserved[3] for QUERYCAP, so we have room for many more
capabilities.

What I would like to see are these flags:

V4L2_CAP_HAS_DEVICE_CAPS2: indicate that there is a device_caps2 capability
field.

And add these defines for the device_caps2 field:

V4L2_CAP2_VIDEO_CAPTURE_HAS_CROP
V4L2_CAP2_VIDEO_CAPTURE_HAS_COMPOSE
V4L2_CAP2_VIDEO_CAPTURE_HAS_SCALER
V4L2_CAP2_VIDEO_OUTPUT_HAS_CROP
V4L2_CAP2_VIDEO_OUTPUT_HAS_COMPOSE
V4L2_CAP2_VIDEO_OUTPUT_HAS_SCALER
V4L2_CAP2_VIDEO_M2M_HAS_SCALER

The main problem is what to do with drivers that do not explicitly set
these capabilities. Applications need to know whether the driver never
sets the capabilities, or that it is not capable of these features.

Perhaps the best way is to add these caps:

V4L2_CAP2_VIDEO_CAPTURE_FIXED
V4L2_CAP2_VIDEO_OUTPUT_FIXED
V4L2_CAP2_VIDEO_M2M_FIXED

that are set when the driver is incapable of cropping/composing/scaling.

If all bits are 0, then you don't know and you have to test for these
features (i.e. the current situation). You want to have a nice macro
to test this.

v4l2-compliance can easily use these caps to verify if the driver isn't
lying to the user, so that is a nice bonus.

What do you think about this?

I can make an RFC PATCH if you think this is the right direction.

Regards,

	Hans

> 
>> Regarding this vim2m patch: I'm fine with this patch if it is clear that
>> it is a temporary fix and that it should really implement a real scaler
>> instead of cropping.
> 
> OK!
> 
> Btw, I found another problem that version 3 will also fix: the 
> "fast track" copy (used when no conversion is needed) is also broken
> if resolutions are different. While it could likely be solved, for
> now, I'll just default to the slower copy logic.
> 
> Such change will also make easier once we add a scaler there.
> 
> Thanks,
> Mauro
> 

