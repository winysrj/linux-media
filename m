Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:60129 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726597AbeIIPbX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Sep 2018 11:31:23 -0400
Subject: Re: [Xen-devel][PATCH 1/1] cameraif: add ABI for para-virtual camera
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com
Cc: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Artem Mygaiev <Artem_Mygaiev@epam.com>
References: <20180731093142.3828-1-andr2000@gmail.com>
 <20180731093142.3828-2-andr2000@gmail.com>
 <99cd131d-85ae-bbfb-61ef-fdc0401727f6@suse.com>
 <5505e5af-5b64-b317-a0d8-09c11317926f@gmail.com>
 <345d7ec3-3ca3-e8fe-28a0-ba299196b5e4@gmail.com>
 <ecfe2b61-deb8-5c3d-3cf4-706c23b47afc@xs4all.nl>
 <53189190-ffe0-9795-b01c-01de8db83acb@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <641cd785-c5e7-7552-dc4b-35249f1f1985@xs4all.nl>
Date: Sun, 9 Sep 2018 12:42:04 +0200
MIME-Version: 1.0
In-Reply-To: <53189190-ffe0-9795-b01c-01de8db83acb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/04/2018 08:56 AM, Oleksandr Andrushchenko wrote:
> On 09/03/2018 06:25 PM, Hans Verkuil wrote:
>> Hi Oleksandr,
>>
>> On 09/03/2018 12:16 PM, Oleksandr Andrushchenko wrote:
>>> On 08/21/2018 08:54 AM, Oleksandr Andrushchenko wrote:
>>>> On 08/14/2018 11:30 AM, Juergen Gross wrote:
>>>>> On 31/07/18 11:31, Oleksandr Andrushchenko wrote:
>>>>>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>>>>
>>>>>> This is the ABI for the two halves of a para-virtualized
>>>>>> camera driver which extends Xen's reach multimedia capabilities even
>>>>>> farther enabling it for video conferencing, In-Vehicle Infotainment,
>>>>>> high definition maps etc.
>>>>>>
>>>>>> The initial goal is to support most needed functionality with the
>>>>>> final idea to make it possible to extend the protocol if need be:
>>>>>>
>>>>>> 1. Provide means for base virtual device configuration:
>>>>>>    - pixel formats
>>>>>>    - resolutions
>>>>>>    - frame rates
>>>>>> 2. Support basic camera controls:
>>>>>>    - contrast
>>>>>>    - brightness
>>>>>>    - hue
>>>>>>    - saturation
>>>>>> 3. Support streaming control
>>>>>> 4. Support zero-copying use-cases
>>>>>>
>>>>>> Signed-off-by: Oleksandr Andrushchenko
>>>>>> <oleksandr_andrushchenko@epam.com>
>>>>> Some style issues below...
>>>> Will fix all the below, thank you!
>>>>
>>>> I would like to draw some attention of the Linux/V4L community to this
>>>> protocol as the plan is that once it is accepted for Xen we plan to
>>>> upstream a Linux camera front-end kernel driver which will be based
>>>> on this work and will be a V4L2 device driver (this is why I have sent
>>>> this patch not only to Xen, but to the corresponding Linux mailing list
>>>> as well)
>>> ping
>> Sorry, this got buried in my mailbox, I only came across it today. I'll try
>> to review this this week, if not, just ping me again.
> Thank you for your time
>>
>> I had one high-level question, though:
>>
>> What types of hardware do you intend to target? This initial version targets
>> (very) simple webcams, but what about HDMI or SDTV receivers? Or hardware
>> codecs? Or complex embedded video pipelines?
>>
>> In other words, where are you planning to draw the line?
>>
>> Even with just simple cameras there is a difference between regular UVC
>> webcams and cameras used with embedded systems: for the latter you often
>> need to provide more control w.r.t. white-balancing etc., things that a
>> UVC webcam will generally do for you in the webcam's firmware.
> The use-cases we want to implement are mostly in automotive/embedded domain,
> so there are many performance restrictions apply.
> We are not targeting virtualizing very complex hardware and have no 
> intention
> to make a 1:1 mapping of the real hardware: for that one can pass-through
> a real HW device to a virtual machine (VM). The goal is to share a single
> camera device to multiple virtual machines, no codecs, receivers etc.
> 
> Controlling the same HW device from different VMs doesn't look feasible:
> what if the same control is set to different values from different VMs?

You can do this, actually: in V4L2 you can get an event when another process
changes a control, and update your own GUI/internal state accordingly.

So in this case if one VM changes a control, an event is sent to all others
that the control has changed value.

> Of course, this can be achieved if the corresponding backend can 
> post-process
> original camera image with GPU, for example, thus applying different filters
> for different VMs effectively emulating camera controls.
> But this requires additional CPU/GPU power which we try to avoid.
> 
> System partitioning (camera and controls assignment) is done at 
> configuration
> time (remember we are in automotive/embedded world, so most of the time 
> the set
> of VMs requiring cameras is known at this stage and the configuration 
> remains
> static at run-time). So, when para-virtualized (PV) approach is used then we
> only implement very basic controls (those found in the protocol), so one can
> assign set of controls (all or some) to one of the VMs (main or mission 
> critical
> VM or whatever) allowing that VM to adjusts those for all VMs at once. 
> For other
> VMs think of it as firmware implemented adjustment. And the backend still
> controls the rest of the controls of the real HW camera you mention.
> 
> Just an example of automotive use-case (we can imagine many more):
> 1. Driver Domain - owns real camera HW and runs the camera backend.
>     Uses camera output for mission critical tasks, e.g. parking assistance.
> 2. In-Vehicle Infotainment domain - uses PV camera for infotainment 
> purposes,
>     e.g. taking pictures while in motion.
> 3. Navigation domain - uses PV camera for high definition maps
> 
> Hope, this helps understanding the possible uses of the proposed 
> protocol, its
> intention and restrictions.

Right, so in this scenario you probably do not want hotpluggable
sources in the Driver Domain. So support for fixed camera's only.

If this is indeed the case, then this should be made very clear in
the API specification.

One additional thing to consider: cameras can break. So what should be
done if that happens? We as media developers have ideas about that, but
nothing has been implemented (yet).

If the HW is simple (one camera is driven by a single driver instance),
then if it breaks, there simply won't be a video device. But if you have
multiple cameras all controlled through the same driver instance, then today
if a single camera breaks, all are gone.

We have ideas on how to address that, but as I said, nothing is implemented
yet. Basically we need to allow for partial bring-up and inform userspace
what is and what is not running.

But this is likely something you also need to consider in this API, given
the use-case you are looking at.

Regards,

	Hans
