Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:55398 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3HBEbG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 00:31:06 -0400
MIME-Version: 1.0
In-Reply-To: <51C38F82.1040507@gmail.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-7-git-send-email-arun.kk@samsung.com>
	<51C38F82.1040507@gmail.com>
Date: Fri, 2 Aug 2013 10:01:05 +0530
Message-ID: <CALt3h7-VfbxxHnitQFgZ3hbTv-X9T09aJznTvu2qNqGbXnftdw@mail.gmail.com>
Subject: Re: [RFC v2 06/10] exynos5-fimc-is: Adds isp subdev
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Fri, Jun 21, 2013 at 4:55 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 05/31/2013 03:03 PM, Arun Kumar K wrote:
>>
>> fimc-is driver takes video data input from the ISP video node
>> which is added in this patch. This node accepts Bayer input
>> buffers which is given from the IS sensors.
>>
>> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
>> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
>> ---
>>   drivers/media/platform/exynos5-is/fimc-is-isp.c |  438
>> +++++++++++++++++++++++
>>   drivers/media/platform/exynos5-is/fimc-is-isp.h |   89 +++++
>>   2 files changed, 527 insertions(+)
>>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-isp.c
>>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-isp.h
>>

[snip]

>> + * Video node ioctl operations
>> + */
>> +static int isp_querycap_output(struct file *file, void *priv,
>> +                                       struct v4l2_capability *cap)
>> +{
>> +       strncpy(cap->driver, ISP_DRV_NAME, sizeof(cap->driver) - 1);
>> +       strncpy(cap->card, ISP_DRV_NAME, sizeof(cap->card) - 1);
>> +       strncpy(cap->bus_info, ISP_DRV_NAME, sizeof(cap->bus_info) - 1);
>> +       cap->capabilities = V4L2_CAP_STREAMING |
>> V4L2_CAP_VIDEO_OUTPUT_MPLANE;
>> +       cap->device_caps = V4L2_CAP_STREAMING |
>> V4L2_CAP_VIDEO_OUTPUT_MPLANE;
>
>
>         cap->capabilities = V4L2_CAP_STREAMING;
>
>         cap->device_caps = V4L2_CAP_STREAMING |
> V4L2_CAP_VIDEO_OUTPUT_MPLANE;
>
> This should be:
>
>         cap->device_caps = V4L2_CAP_STREAMING;
>         cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>
> Media Controller device nodes must not use V4L2_CAP_VIDEO_{OUTPUT,
> CAPTURE}_(_MPLANE)
> capability flags.
>

If I dont provide any video capabilities, the v4l2-compliance tool
gives a fail :

     fail: v4l2-compliance.cpp(298) : node->is_video && !(dcaps & video_caps)
test VIDIOC_QUERYCAP: FAIL

This error doesn't come if I give V4L2_CAP_VIDEO_OUTPUT_MPLANE capability.

One more related error compliance tool gives is :

   fail: v4l2-test-formats.cpp(286): Video Output Multiplanar cap not
set, but Video Output Multiplanar formats defined
test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: FAIL

Shall these errors be ignored?

Regards
Arun
