Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34426 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3HCVii (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Aug 2013 17:38:38 -0400
Message-ID: <51FD7859.1000401@gmail.com>
Date: Sat, 03 Aug 2013 23:38:33 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arunkk.samsung@gmail.com>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC v2 06/10] exynos5-fimc-is: Adds isp subdev
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com> <1370005408-10853-7-git-send-email-arun.kk@samsung.com> <51C38F82.1040507@gmail.com> <CALt3h7-VfbxxHnitQFgZ3hbTv-X9T09aJznTvu2qNqGbXnftdw@mail.gmail.com>
In-Reply-To: <CALt3h7-VfbxxHnitQFgZ3hbTv-X9T09aJznTvu2qNqGbXnftdw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 08/02/2013 06:31 AM, Arun Kumar K wrote:
[...]
>>> + * Video node ioctl operations
>>> + */
>>> +static int isp_querycap_output(struct file *file, void *priv,
>>> +                                       struct v4l2_capability *cap)
>>> +{
>>> +       strncpy(cap->driver, ISP_DRV_NAME, sizeof(cap->driver) - 1);
>>> +       strncpy(cap->card, ISP_DRV_NAME, sizeof(cap->card) - 1);
>>> +       strncpy(cap->bus_info, ISP_DRV_NAME, sizeof(cap->bus_info) - 1);
>>> +       cap->capabilities = V4L2_CAP_STREAMING |
>>> V4L2_CAP_VIDEO_OUTPUT_MPLANE;
>>> +       cap->device_caps = V4L2_CAP_STREAMING |
>>> V4L2_CAP_VIDEO_OUTPUT_MPLANE;
>>
>>
>>          cap->capabilities = V4L2_CAP_STREAMING;
>>
>>          cap->device_caps = V4L2_CAP_STREAMING |
>> V4L2_CAP_VIDEO_OUTPUT_MPLANE;
>>
>> This should be:
>>
>>          cap->device_caps = V4L2_CAP_STREAMING;
>>          cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>>
>> Media Controller device nodes must not use V4L2_CAP_VIDEO_{OUTPUT,
>> CAPTURE}_(_MPLANE) capability flags.
>
> If I dont provide any video capabilities, the v4l2-compliance tool
> gives a fail :
>
>       fail: v4l2-compliance.cpp(298) : node->is_video&&  !(dcaps&  video_caps)
> test VIDIOC_QUERYCAP: FAIL
>
> This error doesn't come if I give V4L2_CAP_VIDEO_OUTPUT_MPLANE capability.
>
> One more related error compliance tool gives is :
>
>     fail: v4l2-test-formats.cpp(286): Video Output Multiplanar cap not
> set, but Video Output Multiplanar formats defined
> test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: FAIL
>
> Shall these errors be ignored?

I think so, yes. The capability flags should be set by a driver-specific
user space library/middleware. Such a library would intercept 
VIDIOC_QUERYBUF
ioctl and set relevant capability flags. I believe v4l2-compliance should
not be used on the bare video device nodes your driver provides. It should
be used together with, e.g. libv4l2 plugin for this driver.

My colleague have been working on such a plugin for exynos4-is driver.
There is still on my todo list modifying FIMC video capture node driver
to allow video device open() even when no links to, e.g. sensor subdev
were created. This is needed because with libv4l2 video device open() must
succeed in order for the plugin to have its initialization routine called.
Then the plugin configures pipeline according to e.g. data stored in a
configuration file, and for some VIDIOC_* ioctls it does additional stuff
on involved subdevices to ensure VIDIOC_* ioctls work as if the /dev/video
would be plain V4L2 video node, without any subdev/MC stuff.

I think you're just using wrong tool for the purpose. v4l2-compliance is
just not suitable for testing MC video nodes without corresponding user
space library that would handle quirks of your device.

If you set the V4L2_CAP_VIDEO_OUTPUT_MPLANE capability standard
applications, e.g. v4l2-src GStreamer plugin (oh, it likely doesn't have
support for _MPLANE yet anyway) may get confused that this video node is
a regular capture video node and users would start filling in bug reports
thinking that your driver is crap because it doesn't work as expected. ;-)

Hans and Mauro may want to correct/add something to what is said above.

--
Thanks,
Sylwester
