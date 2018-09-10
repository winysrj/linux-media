Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr60075.outbound.protection.outlook.com ([40.107.6.75]:26272
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727488AbeIJN1M (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 09:27:12 -0400
Subject: Re: [Xen-devel][PATCH 1/1] cameraif: add ABI for para-virtual camera
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Oleksandr Andrushchenko <andr2000@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com
Cc: Artem Mygaiev <Artem_Mygaiev@epam.com>
References: <20180731093142.3828-1-andr2000@gmail.com>
 <20180731093142.3828-2-andr2000@gmail.com>
 <99cd131d-85ae-bbfb-61ef-fdc0401727f6@suse.com>
 <5505e5af-5b64-b317-a0d8-09c11317926f@gmail.com>
 <345d7ec3-3ca3-e8fe-28a0-ba299196b5e4@gmail.com>
 <ecfe2b61-deb8-5c3d-3cf4-706c23b47afc@xs4all.nl>
 <53189190-ffe0-9795-b01c-01de8db83acb@gmail.com>
 <641cd785-c5e7-7552-dc4b-35249f1f1985@xs4all.nl>
 <de866c33-69ec-8811-a51f-3dcef88033a9@gmail.com>
 <ed2c1ba0-632b-315f-b7d4-2b3ac3de7487@xs4all.nl>
From: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>
Message-ID: <52db2924-224f-a24f-3205-43eca7e4169c@epam.com>
Date: Mon, 10 Sep 2018 11:34:03 +0300
MIME-Version: 1.0
In-Reply-To: <ed2c1ba0-632b-315f-b7d4-2b3ac3de7487@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/2018 11:14 AM, Hans Verkuil wrote:
> On 09/10/2018 07:59 AM, Oleksandr Andrushchenko wrote:
>> Hi, Hans!
>>
>> On 09/09/2018 01:42 PM, Hans Verkuil wrote:
>>> On 09/04/2018 08:56 AM, Oleksandr Andrushchenko wrote:
>>>> On 09/03/2018 06:25 PM, Hans Verkuil wrote:
>>>>> Hi Oleksandr,
>>>>>
>>>>> On 09/03/2018 12:16 PM, Oleksandr Andrushchenko wrote:
>>>>>> On 08/21/2018 08:54 AM, Oleksandr Andrushchenko wrote:
>>>>>>> On 08/14/2018 11:30 AM, Juergen Gross wrote:
>>>>>>>> On 31/07/18 11:31, Oleksandr Andrushchenko wrote:
>>>>>>>>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>>>>>>>
>>>>>>>>> This is the ABI for the two halves of a para-virtualized
>>>>>>>>> camera driver which extends Xen's reach multimedia capabilities even
>>>>>>>>> farther enabling it for video conferencing, In-Vehicle Infotainment,
>>>>>>>>> high definition maps etc.
>>>>>>>>>
>>>>>>>>> The initial goal is to support most needed functionality with the
>>>>>>>>> final idea to make it possible to extend the protocol if need be:
>>>>>>>>>
>>>>>>>>> 1. Provide means for base virtual device configuration:
>>>>>>>>>      - pixel formats
>>>>>>>>>      - resolutions
>>>>>>>>>      - frame rates
>>>>>>>>> 2. Support basic camera controls:
>>>>>>>>>      - contrast
>>>>>>>>>      - brightness
>>>>>>>>>      - hue
>>>>>>>>>      - saturation
>>>>>>>>> 3. Support streaming control
>>>>>>>>> 4. Support zero-copying use-cases
>>>>>>>>>
>>>>>>>>> Signed-off-by: Oleksandr Andrushchenko
>>>>>>>>> <oleksandr_andrushchenko@epam.com>
>>>>>>>> Some style issues below...
>>>>>>> Will fix all the below, thank you!
>>>>>>>
>>>>>>> I would like to draw some attention of the Linux/V4L community to this
>>>>>>> protocol as the plan is that once it is accepted for Xen we plan to
>>>>>>> upstream a Linux camera front-end kernel driver which will be based
>>>>>>> on this work and will be a V4L2 device driver (this is why I have sent
>>>>>>> this patch not only to Xen, but to the corresponding Linux mailing list
>>>>>>> as well)
>>>>>> ping
>>>>> Sorry, this got buried in my mailbox, I only came across it today. I'll try
>>>>> to review this this week, if not, just ping me again.
>>>> Thank you for your time
>>>>> I had one high-level question, though:
>>>>>
>>>>> What types of hardware do you intend to target? This initial version targets
>>>>> (very) simple webcams, but what about HDMI or SDTV receivers? Or hardware
>>>>> codecs? Or complex embedded video pipelines?
>>>>>
>>>>> In other words, where are you planning to draw the line?
>>>>>
>>>>> Even with just simple cameras there is a difference between regular UVC
>>>>> webcams and cameras used with embedded systems: for the latter you often
>>>>> need to provide more control w.r.t. white-balancing etc., things that a
>>>>> UVC webcam will generally do for you in the webcam's firmware.
>>>> The use-cases we want to implement are mostly in automotive/embedded domain,
>>>> so there are many performance restrictions apply.
>>>> We are not targeting virtualizing very complex hardware and have no
>>>> intention
>>>> to make a 1:1 mapping of the real hardware: for that one can pass-through
>>>> a real HW device to a virtual machine (VM). The goal is to share a single
>>>> camera device to multiple virtual machines, no codecs, receivers etc.
>>>>
>>>> Controlling the same HW device from different VMs doesn't look feasible:
>>>> what if the same control is set to different values from different VMs?
>>> You can do this, actually: in V4L2 you can get an event when another process
>>> changes a control, and update your own GUI/internal state accordingly.
>>>
>>> So in this case if one VM changes a control, an event is sent to all others
>>> that the control has changed value.
>> Well, technically this can be done by introducing one more
>> event for such a notification. But, from system partitioning
>> POV, I am still not convinced this should be done: I would prefer
>> that a single VM owns such a control and even which control and which
>> VM is decided while configuring the whole system.
>> So, I would like to keep it as is.
> Well, I am not convinced you can avoid this: some controls are set by drivers
> when something happens and so applications will subscribe to the control and
> wait for changes in their values. While this is for more advanced use-cases
> (certainly more than what you propose today), I would suggest that it is wise
> to at least think on how this can be added in the future.
>
> Controls and control events are a key part of V4L2.
>
ok, then I'll add
#define XENCAMERA_EVT_CTRL_CHANGE      0x02

>>>> Of course, this can be achieved if the corresponding backend can
>>>> post-process
>>>> original camera image with GPU, for example, thus applying different filters
>>>> for different VMs effectively emulating camera controls.
>>>> But this requires additional CPU/GPU power which we try to avoid.
>>>>
>>>> System partitioning (camera and controls assignment) is done at
>>>> configuration
>>>> time (remember we are in automotive/embedded world, so most of the time
>>>> the set
>>>> of VMs requiring cameras is known at this stage and the configuration
>>>> remains
>>>> static at run-time). So, when para-virtualized (PV) approach is used then we
>>>> only implement very basic controls (those found in the protocol), so one can
>>>> assign set of controls (all or some) to one of the VMs (main or mission
>>>> critical
>>>> VM or whatever) allowing that VM to adjusts those for all VMs at once.
>>>> For other
>>>> VMs think of it as firmware implemented adjustment. And the backend still
>>>> controls the rest of the controls of the real HW camera you mention.
>>>>
>>>> Just an example of automotive use-case (we can imagine many more):
>>>> 1. Driver Domain - owns real camera HW and runs the camera backend.
>>>>       Uses camera output for mission critical tasks, e.g. parking assistance.
>>>> 2. In-Vehicle Infotainment domain - uses PV camera for infotainment
>>>> purposes,
>>>>       e.g. taking pictures while in motion.
>>>> 3. Navigation domain - uses PV camera for high definition maps
>>>>
>>>> Hope, this helps understanding the possible uses of the proposed
>>>> protocol, its
>>>> intention and restrictions.
>>> Right, so in this scenario you probably do not want hotpluggable
>>> sources in the Driver Domain. So support for fixed camera's only.
>> Well, some sort of hotplug can already be implemented, please
>> see [1], [2] as it is done for virtual display: this is
>> achieved as a response to the backend's state change,
>> e.g. whenever backend decides to unplug the virtual device
>> it changes its state accordingly.
>>> If this is indeed the case, then this should be made very clear in
>>> the API specification.
>> As I described above this is already assumed by the state
>> machine of a xenbus_driver
>>> One additional thing to consider: cameras can break. So what should be
>>> done if that happens? We as media developers have ideas about that, but
>>> nothing has been implemented (yet).
>>>
>>> If the HW is simple (one camera is driven by a single driver instance),
>>> then if it breaks, there simply won't be a video device. But if you have
>>> multiple cameras all controlled through the same driver instance, then today
>>> if a single camera breaks, all are gone.
>> Please see above
> I'm not convinced this is sufficient. But it really would have to be tested
> with an actual HDMI source.
>
> A key difference between supporting a video input connector such as HDMI
> compared to a fixed camera or video output is that you do not control what
> you receive. I've been working with this for many years, and it is amazing
> what problems you can get due to this.
>
> So received frames can be corrupt (make sure you can handle the
> V4L2_BUF_FLAG_ERROR flag as result of a VIDIOC_DQBUF!) or the DMA engine can get
> into a bad state, requiring you to stop streaming and reconfigure (EIO returned
> by VIDIOC_(D)QBUF).
This all seems to be a backend problem: if a frame is corrupt
then backend can simply drop this frame and don't even report
it to the frontends, e.g. we assume that all this is handled
by the backend and this is its responsibility to always deliver
"good" frames.
Another issue is with "requiring you to stop streaming and reconfigure 
(EIO returned
by VIDIOC_(D)QBUF)". If the error is not recoverable then
backend can go into XenbusStateClosed and destroy the virtual
camera, otherwise it can try recovering making it all transparent
for the frontend.
> A good driver to test such errors with is vivid, which can emulate webcams, SDTV or
> an HDMI receiver and has error injection to test these scenarios. See here for
> extensive documentation of this driver:
>
> https://hverkuil.home.xs4all.nl/spec/v4l-drivers/vivid.html
>
> I would recommend that you use this driver as a test HW driver since it can
> be configured in many different ways and is representative of actual HW.
>
> Exception is for HDMI where connect/disconnect is not properly emulated yet.
> If you need that, let me know.
>
> Regards,
>
> 	Hans
>
>>> We have ideas on how to address that, but as I said, nothing is implemented
>>> yet. Basically we need to allow for partial bring-up and inform userspace
>>> what is and what is not running.
>>>
>>> But this is likely something you also need to consider in this API, given
>>> the use-case you are looking at.
>>>
>>> Regards,
>>>
>>> 	Hans
>> Thank you for your valuable comments,
>> Oleksandr
>>
>> [1]
>> https://elixir.bootlin.com/linux/v4.19-rc3/source/drivers/gpu/drm/xen/xen_drm_front.c#L721
>> [2]
>> https://elixir.bootlin.com/linux/v4.19-rc3/source/drivers/gpu/drm/xen/xen_drm_front.c#L582
>>
