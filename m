Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:40555 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725949AbeICTqN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Sep 2018 15:46:13 -0400
Subject: Re: [Xen-devel][PATCH 1/1] cameraif: add ABI for para-virtual camera
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com
Cc: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180731093142.3828-1-andr2000@gmail.com>
 <20180731093142.3828-2-andr2000@gmail.com>
 <99cd131d-85ae-bbfb-61ef-fdc0401727f6@suse.com>
 <5505e5af-5b64-b317-a0d8-09c11317926f@gmail.com>
 <345d7ec3-3ca3-e8fe-28a0-ba299196b5e4@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ecfe2b61-deb8-5c3d-3cf4-706c23b47afc@xs4all.nl>
Date: Mon, 3 Sep 2018 17:25:25 +0200
MIME-Version: 1.0
In-Reply-To: <345d7ec3-3ca3-e8fe-28a0-ba299196b5e4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oleksandr,

On 09/03/2018 12:16 PM, Oleksandr Andrushchenko wrote:
> On 08/21/2018 08:54 AM, Oleksandr Andrushchenko wrote:
>> On 08/14/2018 11:30 AM, Juergen Gross wrote:
>>> On 31/07/18 11:31, Oleksandr Andrushchenko wrote:
>>>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>>
>>>> This is the ABI for the two halves of a para-virtualized
>>>> camera driver which extends Xen's reach multimedia capabilities even
>>>> farther enabling it for video conferencing, In-Vehicle Infotainment,
>>>> high definition maps etc.
>>>>
>>>> The initial goal is to support most needed functionality with the
>>>> final idea to make it possible to extend the protocol if need be:
>>>>
>>>> 1. Provide means for base virtual device configuration:
>>>>   - pixel formats
>>>>   - resolutions
>>>>   - frame rates
>>>> 2. Support basic camera controls:
>>>>   - contrast
>>>>   - brightness
>>>>   - hue
>>>>   - saturation
>>>> 3. Support streaming control
>>>> 4. Support zero-copying use-cases
>>>>
>>>> Signed-off-by: Oleksandr Andrushchenko 
>>>> <oleksandr_andrushchenko@epam.com>
>>> Some style issues below...
>> Will fix all the below, thank you!
>>
>> I would like to draw some attention of the Linux/V4L community to this
>> protocol as the plan is that once it is accepted for Xen we plan to
>> upstream a Linux camera front-end kernel driver which will be based
>> on this work and will be a V4L2 device driver (this is why I have sent
>> this patch not only to Xen, but to the corresponding Linux mailing list
>> as well)
> ping

Sorry, this got buried in my mailbox, I only came across it today. I'll try
to review this this week, if not, just ping me again.

I had one high-level question, though:

What types of hardware do you intend to target? This initial version targets
(very) simple webcams, but what about HDMI or SDTV receivers? Or hardware
codecs? Or complex embedded video pipelines?

In other words, where are you planning to draw the line?

Even with just simple cameras there is a difference between regular UVC
webcams and cameras used with embedded systems: for the latter you often
need to provide more control w.r.t. white-balancing etc., things that a
UVC webcam will generally do for you in the webcam's firmware.

Regards,

	Hans
