Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:48287 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab1JGKWL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2011 06:22:11 -0400
Message-ID: <4E8ED2CF.70302@mlbassoc.com>
Date: Fri, 07 Oct 2011 04:22:07 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Javier Martinez Canillas <martinez.javier@gmail.com>
CC: Enrico <ebutera@users.berlios.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: omap3-isp status
References: <CA+2YH7t+cHNoV_oNF6cOyTjr+OFbWAAoKCujFwfNHjvijoD8pw@mail.gmail.com> <CAAwP0s0Z+EaRfY_9c0QLm0ZpyfG5Dy1qb9pFq=PRxzOOTwKTJw@mail.gmail.com> <CAAwP0s1tK5XjmJmtvRFJ2+ADvoMP1ihf3z0UaJAfXOoJ=UrVqg@mail.gmail.com> <4E8DB490.7000403@mlbassoc.com> <CAAwP0s0ddOYAnC7rknLVzcN10iKAwnuOawznpKy9z6B2yWRdCg@mail.gmail.com> <CAAwP0s0tOHmdG6eWuY_QDZ6ReVFXg9S6-MSbX7s4GNEX60U2mQ@mail.gmail.com> <4E8DCD79.3060507@mlbassoc.com> <CAAwP0s15c_AgwisQvNFx-_aR44ijEz+vcB_Su3Rmiob3pPo4sw@mail.gmail.com> <4E8EC793.9010001@mlbassoc.com> <CAAwP0s0-kDjfNGPKRzGVEPuwbbVhGtPpPhK7qPitU-jWyfp1kA@mail.gmail.com>
In-Reply-To: <CAAwP0s0-kDjfNGPKRzGVEPuwbbVhGtPpPhK7qPitU-jWyfp1kA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-10-07 04:08, Javier Martinez Canillas wrote:
> On Fri, Oct 7, 2011 at 11:34 AM, Gary Thomas<gary@mlbassoc.com>  wrote:
>> On 2011-10-06 10:11, Javier Martinez Canillas wrote:
>>>
>>> On Thu, Oct 6, 2011 at 5:47 PM, Gary Thomas<gary@mlbassoc.com>    wrote:
>>>>
>>>> On 2011-10-06 08:50, Javier Martinez Canillas wrote:
>>>>>
>>>>> On Thu, Oct 6, 2011 at 4:29 PM, Javier Martinez Canillas
>>>>> <martinez.javier@gmail.com>      wrote:
>>>>>>
>>>>>> On Thu, Oct 6, 2011 at 4:00 PM, Gary Thomas<gary@mlbassoc.com>
>>>>>>   wrote:
>>>>>>>
>>>>>>> On 2011-10-06 01:51, Javier Martinez Canillas wrote:
>>>>>>>>
>>>>>>>> On Wed, Oct 5, 2011 at 7:43 PM, Javier Martinez Canillas
>>>>>>>> <martinez.javier@gmail.com>        wrote:
>>>>>>>>>
>>>>>>>>> On Wed, Oct 5, 2011 at 6:28 PM, Enrico<ebutera@users.berlios.de>
>>>>>>>>>   wrote:
>>>>>>>>>>
>>>>>>>>>> Hi all,
>>>>>>>>>>
>>>>>>>>>> since we are all interested in this driver (and tvp5150) i'll try
>>>>>>>>>> to
>>>>>>>>>> make a summary of the current situation and understand what is
>>>>>>>>>> needed
>>>>>>>>>> to finally get it into the main tree instead of having to apply a
>>>>>>>>>> dozen patches manually.
>>>>>>>>>>
>>>>>>>>>> The current status of git repositories/branches is:
>>>>>>>>>>
>>>>>>>>>> - main tree: working (i suppose) but no support for bt656 input
>>>>>>>>>>
>>>>>>>>>> - pinchartl/media:
>>>>>>>>>>   * omap3isp-omap3isp-next: i think it's in sync with linuxtv master
>>>>>>>>>> (for the omap3-isp parts)
>>>>>>>>>>   * omap3isp-omap3isp-yuv: like ..next but with some additional
>>>>>>>>>> format
>>>>>>>>>> patches
>>>>>>>>>>
>>>>>>>>>> "Floating" patches:
>>>>>>>>>>
>>>>>>>>>> - Deepthy: sent patches (against mainline) to add bt656 support
>>>>>>>>>>
>>>>>>>>>> Laurent made some comments, i haven't seen a v2 to be applied
>>>>>>>>>>
>>>>>>>>>> - Javier: sent patches for tvp5150, currently discussed on
>>>>>>>>>> linux-media; possible patches/fixes for omap3-isp
>>>>>>>>>>
>>>>>>>>
>>>>>>>> Hello,
>>>>>>>>
>>>>>>>> Since the patches are not against mainline I can't post for reviewing
>>>>>>>> but can be found in one of our development trees [1]. Comments are
>>>>>>>> highly appreciated.
>>>>>>>>
>>>>>>>> The tree is a 2.6.37 that already contain Deepthy patch. I rebased my
>>>>>>>> changes on top of that to correctly support both BT656 an non-BT656
>>>>>>>> video data processing.
>>>>>>>>
>>>>>>>> [1]:
>>>>>>>>
>>>>>>>>
>>>>>>>> http://git.igep.es/?p=pub/scm/linux-omap-2.6.git;a=shortlog;h=refs/heads/linux-2.6.37.y-next
>>>>>>>
>>>>>>> Any chance of rebasing these against a more up to date kernel, e.g.
>>>>>>> 3.2-working
>>>>>>> with the patches Laurent sent today?
>>>>>>>
>>>>>>
>>>>>> Sure, but I won't have time to do it neither today nor tomorrow. But
>>>>>> will do it during the weekend.
>>>>>>
>>>>>>>>>
>>>>>>>>> I will find some free time slots to resolve the issues called out by
>>>>>>>>> Sakari, Hans and Mauro and resend the patch-set for the tvp5151.
>>>>>>>>>
>>>>>>>>> Also I can send the patches of the modifications I made to the ISP
>>>>>>>>> driver. Right now I'm working on top of Deepthy patches.
>>>>>>>>>
>>>>>>>>> I can either send on top of that patch or rebase to mainline,
>>>>>>>>> whatever
>>>>>>>>> you think is better for reviewing.
>>>>>>>>>
>>>>>>>>>> Now what can we all do to converge to a final solution? I think
>>>>>>>>>> this
>>>>>>>>>> is also blocking the possible development/test of missing features,
>>>>>>>>>> like the recently-discussed resizer and cropping ones.
>>>>>>>>>>
>>>>>>>>>> Enrico
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Right now I have a working the tvp5151 with the ISP. I can capture
>>>>>>>>> ITU-R BT656 video both in PAL-M and NTSC standard. Also, the whole
>>>>>>>>> pipeline is configured automatically with the video standard
>>>>>>>>> detected
>>>>>>>>> by the tvp5151. Also, I'm using the CCDC to crop the frames and only
>>>>>>>>> capture the active lines for each standard (576 for PAL and 480 for
>>>>>>>>> NTSC) using the CCDC to crop the image.
>>>>>>>>>
>>>>>>>>
>>>>>>>> As I told you before video capturing is working for both PAL and NTSC
>>>>>>>> using standard V4L2 application (i.e: gstreamer) but the video still
>>>>>>>> shows some motion artifacts. Capturing YUV frames and looking at them
>>>>>>>> I realized that there does exist a pattern, the sequence 2 frames
>>>>>>>> correct and 3 frames with interlacing effects always repeats.
>>>>>>>
>>>>>>> I think I've seen this as well.  Could you provide a short video
>>>>>>> which shows the artefacts?
>>>>>>>
>>>>>>
>>>>>> Yes, I've attached a 16-frame video file. It is a PAL-M video
>>>>>> (720x576) in YUV 4:22 data format. Please let me know if it is OK for
>>>>>> you.
>>>>>>
>>>>>
>>>>> Sorry, I didn't notice the size of the image (13 MB) and got a lot of
>>>>> rejects from your MTAs. I uploaded the file to my personal github
>>>>> account [1].
>>>>>
>>>>> [1]:
>>>>> https://github.com/martinezjavier/omap3isp_tvp5151/blob/master/pal.yuv
>>>>
>>>> Very interesting.  What was your source (camera type, etc)?
>>>
>>> A samsung HD video camera connected to the TVP with its RCA video
>>> connector. But the artifact its independent of the analog input data,
>>> I've tried with an Sony Cybershot camera and other input sources.
>>>
>>>> How are you looking (or extracting) individual frames for analysis?
>>>>
>>>
>>> I'm using gstreamer to capture RAW YUV data and MPEG encoded video
>>> using the DSP.
>>>
>>> This are my pipelines:
>>>
>>> YUV:
>>>
>>> gst-launch-0.10 -v v4l2src device=/dev/video2 queue-size=16
>>> num-buffers=16 ! video/x-raw-yuv,format=\(fourcc\)UYVY ! filesink
>>> location=capture.out
>>>
>>> MPEG:
>>>
>>> gst-launch-0.10 -v v4l2src device=/dev/video2 queue-size=8 !
>>> video/x-raw-yuv,format=\(fourcc\)UYVY ! TIVidenc1 codecName=mpeg4enc
>>> engineName=codecServer ! qtmux ! filesink location=capture.m4v
>>>
>>>> I see much the same sort of artefacts as you are.  An example is at
>>>>   http://www.mlbassoc.com/misc/untitled.m2t
>>>> This is a little example I put together using kdenlive.  The first
>>>> segment
>>>> is the raw video from my camera, imported via USB.  The second is roughly
>>>> the same video captured using my OMAP board and converted to MP4 on the
>>>> fly
>>>> by this command:
>>>>   ffmpeg -r 30/1 -pix_fmt uyvy422 -s 720x524 -f video4linux2 -i
>>>> /dev/video2
>>>> -qscale 1 -f mp4 test1.mp4
>>>> I think there are some aspect ratio issues with these but what bothers me
>>>> the most is how much the captured data tears whenever there is a lot of
>>>> motion in the video.
>>
>> I figured out how to split your raw video into individual frames.  The
>> problems
>> don't look like only interlace issues to me.  Take a look at
>>   http://www.mlbassoc.com/misc/UYVY_examples/PAL_from_JavierMartinezCanillas/
>> especially image #9 which shows some very serious ghosting.
>>
>
> Yes, I don't know if this is because I'm not copying the sub-frame in
> the correct buffer or another.
>
>> I see the same behaviour here and it bothers me quite a lot.  I do hope that
>> we can figure out what's causing it - we have a number of customers that are
>> wanting to do analogue video capture using the OMAP+TVP5150, so it's pretty
>> important to us.
>>
>> Thanks for your time
>
> Yes, we are in the same situation. I did my best to fix this but I
> couldn't. I minimized the effect with those changes but there still
> exists.

Do we know for sure that these problems are happening in the ISP itself
or could they possibly be in the TVP5150?  Does anyone have experience
with a different analogue encoder?

>
> I hope as Enrico says that Laurent, Sakari (who im cc'ing here) or
> Deepthy that know better the ISP can enter the discussion. So we can
> all work together to resolve this issue.
>
> Best regards,
>

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
