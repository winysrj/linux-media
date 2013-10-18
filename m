Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:53575 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3JRADN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 20:03:13 -0400
Received: by mail-qc0-f175.google.com with SMTP id v2so2460503qcr.20
        for <linux-media@vger.kernel.org>; Thu, 17 Oct 2013 17:03:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52606AB7.7020200@gmail.com>
References: <1381362589-32237-1-git-send-email-sheu@google.com>
	<1381362589-32237-4-git-send-email-sheu@google.com>
	<52564DE6.6090709@xs4all.nl>
	<CAErgknA-3bk1BoYa6KJAfO+863DBTi_5U8i_hh7F8O+mXfyNWg@mail.gmail.com>
	<CAErgknA-ZgSzeeaaEuYKFZ0zonCt=10tBX7FeOT16-yQLZVnZw@mail.gmail.com>
	<52590184.5030806@xs4all.nl>
	<CAErgknAXZzbBMm0JeASOVzsXNNyu7Af32hd0t_fR8VkPeVrx4A@mail.gmail.com>
	<526001DF.9040309@samsung.com>
	<CAErgknCu2UeEQeY+taSXAbC6F4i=FMTz8t=MhSLUdfQRZXQgAg@mail.gmail.com>
	<CAErgknDhiSg0v_4KvMuoTX4Xcy9t+d2=+QWJu0riM1B0kQVMcg@mail.gmail.com>
	<52606AB7.7020200@gmail.com>
Date: Thu, 17 Oct 2013 17:03:12 -0700
Message-ID: <CAErgknBEJmVwjG6xs8Es3C8ZkjuDgnM6NUUx07me+Rf2bKdzZg@mail.gmail.com>
Subject: Re: Fwd: [PATCH 3/6] [media] s5p-mfc: add support for
 VIDIOC_{G,S}_CROP to encoder
From: John Sheu <sheu@google.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	m.chehab@samsung.com, Kamil Debski <k.debski@samsung.com>,
	pawel@osciak.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 17, 2013 at 3:54 PM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 10/18/2013 12:25 AM, John Sheu wrote:
>> On Thu, Oct 17, 2013 at 2:46 PM, John Sheu<sheu@google.com>  wrote:
>>> >  Sweet.  Thanks for spelling things out explicitly like this.  The fact
>>> >  that the CAPTURE and OUTPUT queues "invert" their sense of "crop-ness"
>>> >  when used in a m2m device is definitely all sorts of confusing.
>>
>> Just to double-check: this means that we have another bug.
>>
>> In drivers/media/v4l2-core/v4l2-ioctl.c, in v4l_s_crop and v4l_g_crop,
>> we "simulate" a G_CROP or S_CROP, if the entry point is not defined
>> for that device, by doing the appropriate S_SELECTION or G_SELECTION.
>> Unfortunately then, for M2M this is incorrect then.
>>
>> Am I reading this right?
>
> You are right, John. Firstly a clear specification needs to be written,
> something along the lines of Tomasz's explanation in this thread, once
> all agree to that the ioctl code should be corrected if needed.
>
> It seems this [1] RFC is an answer exactly to your question.
>
> Exact meaning of the selection ioctl is only part of the problem, also
> interaction with VIDIOC_S_FMT is not currently defined in the V4L2 spec.
>
> [1] http://www.spinics.net/lists/linux-media/msg56078.html

I think the "inversion" behavior is confusing and we should remove it
if at all possible.

I took a look through all the drivers in linux-media which implement
S_CROP.  Most of them are either OUTPUT or CAPTURE/OVERLAY-only.  Of
those that aren't:

* drivers/media/pci/zoran/zoran_driver.c : this driver explicitly accepts both
  OUTPUT and CAPTURE queues in S_CROP, but they both configure the same state.
  No functional difference.
* drivers/media/platform/davinci/vpfe_capture.c : this driver doesn't specify
  the queue, but is a CAPTURE-only device.  Probably an (unrelated) bug.
* drivers/media/platform/exynos4-is/fimc-m2m.c : this driver is a m2m driver
  with both OUTPUT and CAPTURE queues.  It has uninverted behavior:
  S_CROP(CAPTURE) -> source
  S_CROP(OUTPUT) -> destination
* drivers/media/platform/s5p-g2d/g2d.c : this driver is a m2m driver with both
  OUTPUT and CAPTURE queues.  It has inverted behavior:
  S_CROP(CAPTURE) -> destination
  S_CROP(OUTPUT) -> source

The last two points above are the most relevant.  So we already have
at least one broken driver, regardless of whether we allow inversion
or not; I'd think this grants us a certain freedom to redefine the
specification to be more logical.  Can we do this please?

-John Sheu
