Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:61594 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3JQWyx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 18:54:53 -0400
Received: by mail-wg0-f48.google.com with SMTP id b13so2971738wgh.27
        for <linux-media@vger.kernel.org>; Thu, 17 Oct 2013 15:54:51 -0700 (PDT)
Message-ID: <52606AB7.7020200@gmail.com>
Date: Fri, 18 Oct 2013 00:54:47 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: John Sheu <sheu@google.com>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	m.chehab@samsung.com, Kamil Debski <k.debski@samsung.com>,
	pawel@osciak.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: Fwd: [PATCH 3/6] [media] s5p-mfc: add support for VIDIOC_{G,S}_CROP
 to encoder
References: <1381362589-32237-1-git-send-email-sheu@google.com> <1381362589-32237-4-git-send-email-sheu@google.com> <52564DE6.6090709@xs4all.nl> <CAErgknA-3bk1BoYa6KJAfO+863DBTi_5U8i_hh7F8O+mXfyNWg@mail.gmail.com> <CAErgknA-ZgSzeeaaEuYKFZ0zonCt=10tBX7FeOT16-yQLZVnZw@mail.gmail.com> <52590184.5030806@xs4all.nl> <CAErgknAXZzbBMm0JeASOVzsXNNyu7Af32hd0t_fR8VkPeVrx4A@mail.gmail.com> <526001DF.9040309@samsung.com> <CAErgknCu2UeEQeY+taSXAbC6F4i=FMTz8t=MhSLUdfQRZXQgAg@mail.gmail.com> <CAErgknDhiSg0v_4KvMuoTX4Xcy9t+d2=+QWJu0riM1B0kQVMcg@mail.gmail.com>
In-Reply-To: <CAErgknDhiSg0v_4KvMuoTX4Xcy9t+d2=+QWJu0riM1B0kQVMcg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/18/2013 12:25 AM, John Sheu wrote:
> On Thu, Oct 17, 2013 at 2:46 PM, John Sheu<sheu@google.com>  wrote:
>> >  Sweet.  Thanks for spelling things out explicitly like this.  The fact
>> >  that the CAPTURE and OUTPUT queues "invert" their sense of "crop-ness"
>> >  when used in a m2m device is definitely all sorts of confusing.
>
> Just to double-check: this means that we have another bug.
>
> In drivers/media/v4l2-core/v4l2-ioctl.c, in v4l_s_crop and v4l_g_crop,
> we "simulate" a G_CROP or S_CROP, if the entry point is not defined
> for that device, by doing the appropriate S_SELECTION or G_SELECTION.
> Unfortunately then, for M2M this is incorrect then.
>
> Am I reading this right?

You are right, John. Firstly a clear specification needs to be written,
something along the lines of Tomasz's explanation in this thread, once
all agree to that the ioctl code should be corrected if needed.

It seems this [1] RFC is an answer exactly to your question.

Exact meaning of the selection ioctl is only part of the problem, also
interaction with VIDIOC_S_FMT is not currently defined in the V4L2 spec.

[1] http://www.spinics.net/lists/linux-media/msg56078.html

Regards,
Sylwester
