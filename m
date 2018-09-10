Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f181.google.com ([209.85.208.181]:42597 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbeIJNRk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 09:17:40 -0400
Received: by mail-lj1-f181.google.com with SMTP id f1-v6so17096888ljc.9
        for <linux-media@vger.kernel.org>; Mon, 10 Sep 2018 01:24:43 -0700 (PDT)
Subject: Re: [Xen-devel][PATCH 1/1] cameraif: add ABI for para-virtual camera
To: Hans Verkuil <hverkuil@xs4all.nl>, xen-devel@lists.xenproject.org,
        konrad.wilk@oracle.com, jgross@suse.com,
        boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com
Cc: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180731093142.3828-1-andr2000@gmail.com>
 <20180731093142.3828-2-andr2000@gmail.com>
 <73b69e31-d36d-d89f-20d6-d59dbefe395e@xs4all.nl>
 <fc78ee17-412f-8a74-ecc8-b8ab55189e1b@gmail.com>
 <7134b3ad-9fcf-0139-41b3-67a3dbc8224d@xs4all.nl>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <51f97715-454a-0242-b381-29944d77d5b5@gmail.com>
Date: Mon, 10 Sep 2018 11:24:40 +0300
MIME-Version: 1.0
In-Reply-To: <7134b3ad-9fcf-0139-41b3-67a3dbc8224d@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/2018 10:53 AM, Hans Verkuil wrote:
> Hi Oleksandr,
>
> On 09/10/2018 09:16 AM, Oleksandr Andrushchenko wrote:
>> Hi, Hans!
>>
>> On 09/09/2018 01:31 PM, Hans Verkuil wrote:
>>> Hi Oleksandr,
>>>
>>> Sorry for the delay in reviewing, I missed this patch until you pinged me, and
>>> I was very busy after that as well.
>> I do appreciate you spending time on this!
>>> On 07/31/2018 11:31 AM, Oleksandr Andrushchenko wrote:
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
>>>>    - pixel formats
>>>>    - resolutions
>>>>    - frame rates
>>>> 2. Support basic camera controls:
>>>>    - contrast
>>>>    - brightness
>>>>    - hue
>>>>    - saturation
>>>> 3. Support streaming control
>>>> 4. Support zero-copying use-cases
>>>>
>>>> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>> ---
>>>>    xen/include/public/io/cameraif.h | 981 +++++++++++++++++++++++++++++++
>>>>    1 file changed, 981 insertions(+)
>>>>    create mode 100644 xen/include/public/io/cameraif.h
>>>>
>>>> diff --git a/xen/include/public/io/cameraif.h b/xen/include/public/io/cameraif.h
>>>> new file mode 100644
>>>> index 000000000000..bdc6a1262fcf
>>>> --- /dev/null
>>>> +++ b/xen/include/public/io/cameraif.h
>>>> @@ -0,0 +1,981 @@
>>>> +/******************************************************************************
>>>> + * cameraif.h
>>>> + *
>>>> + * Unified camera device I/O interface for Xen guest OSes.
>>>> + *
>>>> + * Permission is hereby granted, free of charge, to any person obtaining a copy
>>>> + * of this software and associated documentation files (the "Software"), to
>>>> + * deal in the Software without restriction, including without limitation the
>>>> + * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
>>>> + * sell copies of the Software, and to permit persons to whom the Software is
>>>> + * furnished to do so, subject to the following conditions:
>>>> + *
>>>> + * The above copyright notice and this permission notice shall be included in
>>>> + * all copies or substantial portions of the Software.
>>>> + *
>>>> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>>>> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>>>> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>>>> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>>>> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
>>>> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
>>>> + * DEALINGS IN THE SOFTWARE.
>>>> + *
>>>> + * Copyright (C) 2018 EPAM Systems Inc.
>>>> + *
>>>> + * Author: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>> + */
>>> Use SPDX tag instead of copying the license text.
>> This is yet a Xen header which belongs to Xen project and
>> all the rest of the protocols have the same license header.
>> If Xen community decides to use SPDX then I'll definitely follow.
> Ah, yes, I was reviewing this as a kernel header, I hadn't realized
> that this isn't a kernel header. Since it isn't a kernel header, you
> can disregard my comments about style and naming conventions, since
> you have your own.
>
>> Konrad, do you think this is the right time for such a move?
>>>> +
>>>> +#ifndef __XEN_PUBLIC_IO_CAMERAIF_H__
>>>> +#define __XEN_PUBLIC_IO_CAMERAIF_H__
>>>> +
>>>> +#include "ring.h"
>>>> +#include "../grant_table.h"
>>>> +
>>>> +/*
>>>> + ******************************************************************************
>>>> + *                           Protocol version
>>>> + ******************************************************************************
>>>> + */
>>>> +#define XENCAMERA_PROTOCOL_VERSION     "1"
>>>> +
>>>> +/*
>>>> + ******************************************************************************
>>>> + *                  Feature and Parameter Negotiation
>>>> + ******************************************************************************
>>>> + *
>>>> + * Front->back notifications: when enqueuing a new request, sending a
>>>> + * notification can be made conditional on xencamera_req (i.e., the generic
>>>> + * hold-off mechanism provided by the ring macros). Backends must set
>>>> + * xencamera_req appropriately (e.g., using RING_FINAL_CHECK_FOR_REQUESTS()).
>>>> + *
>>>> + * Back->front notifications: when enqueuing a new response, sending a
>>>> + * notification can be made conditional on xencamera_resp (i.e., the generic
>>>> + * hold-off mechanism provided by the ring macros). Frontends must set
>>>> + * xencamera_resp appropriately (e.g., using RING_FINAL_CHECK_FOR_RESPONSES()).
>>>> + *
>>>> + * The two halves of a para-virtual camera driver utilize nodes within
>>>> + * XenStore to communicate capabilities and to negotiate operating parameters.
>>>> + * This section enumerates these nodes which reside in the respective front and
>>>> + * backend portions of XenStore, following the XenBus convention.
>>>> + *
>>>> + * All data in XenStore is stored as strings. Nodes specifying numeric
>>>> + * values are encoded in decimal. Integer value ranges listed below are
>>>> + * expressed as fixed sized integer types capable of storing the conversion
>>>> + * of a properly formatted node string, without loss of information.
>>>> + *
>>>> + ******************************************************************************
>>>> + *                        Example configuration
>>>> + ******************************************************************************
>>>> + *
>>>> + * This is an example of backend and frontend configuration:
>>>> + *
>>>> + *--------------------------------- Backend -----------------------------------
>>>> + *
>>>> + * /local/domain/0/backend/vcamera/1/0/frontend-id = "1"
>>>> + * /local/domain/0/backend/vcamera/1/0/frontend = "/local/domain/1/device/vcamera/0"
>>>> + * /local/domain/0/backend/vcamera/1/0/state = "4"
>>>> + * /local/domain/0/backend/vcamera/1/0/versions = "1,2"
>>> Why vcamera instead of just camera? If 'v' stands for 'video', then that seems
>>> superfluous to me.
>> 'v' stands for 'virtual'. I am following Xen convention used
>> for all other virtual device protocols here.
>>>> + *
>>>> + *--------------------------------- Frontend ----------------------------------
>>>> + *
>>>> + * /local/domain/1/device/vcamera/0/backend-id = "0"
>>>> + * /local/domain/1/device/vcamera/0/backend = "/local/domain/0/backend/vcamera/1"
>>>> + * /local/domain/1/device/vcamera/0/state = "4"
>>>> + * /local/domain/1/device/vcamera/0/version = "1"
>>>> + * /local/domain/1/device/vcamera/0/be-alloc = "1"
>>>> + *
>>>> + *---------------------------- Device 0 configuration -------------------------
>>>> + *
>>>> + * /local/domain/1/device/vcamera/0/controls = "contrast,hue"
>>>> + * /local/domain/1/device/vcamera/0/formats/YUYV/640x480 = "30/1,15/1,15/2"
>>>> + * /local/domain/1/device/vcamera/0/formats/YUYV/1920x1080 = "15/2"
>>>> + * /local/domain/1/device/vcamera/0/formats/BGRA/640x480 = "15/1,15/2"
>>>> + * /local/domain/1/device/vcamera/0/formats/BGRA/1200x720 = "15/2"
>>>> + * /local/domain/1/device/vcamera/0/unique-id = "0"
>>>> + * /local/domain/1/device/vcamera/0/req-ring-ref = "2832"
>>>> + * /local/domain/1/device/vcamera/0/req-event-channel = "15"
>>>> + * /local/domain/1/device/vcamera/0/evt-ring-ref = "387"
>>>> + * /local/domain/1/device/vcamera/0/evt-event-channel = "16"
>>>> + *
>>>> + *---------------------------- Device 1 configuration -------------------------
>>>> + *
>>>> + * /local/domain/1/device/vcamera/1/controls = "brightness,saturation,hue"
>>>> + * /local/domain/1/device/vcamera/1/formats/YUYV/640x480 = "30/1,15/1,15/2"
>>>> + * /local/domain/1/device/vcamera/1/formats/YUYV/1920x1080 = "15/2"
>>>> + * /local/domain/1/device/vcamera/1/unique-id = "1"
>>>> + * /local/domain/1/device/vcamera/1/req-ring-ref = "2833"
>>>> + * /local/domain/1/device/vcamera/1/req-event-channel = "17"
>>>> + * /local/domain/1/device/vcamera/1/evt-ring-ref = "388"
>>>> + * /local/domain/1/device/vcamera/1/evt-event-channel = "18"
>>>> + *
>>>> + ******************************************************************************
>>>> + *                            Backend XenBus Nodes
>>>> + ******************************************************************************
>>>> + *
>>>> + *----------------------------- Protocol version ------------------------------
>>>> + *
>>>> + * versions
>>>> + *      Values:         <string>
>>>> + *
>>>> + *      List of XENCAMERA_LIST_SEPARATOR separated protocol versions supported
>>>> + *      by the backend. For example "1,2,3".
>>>> + *
>>>> + ******************************************************************************
>>>> + *                            Frontend XenBus Nodes
>>>> + ******************************************************************************
>>>> + *
>>>> + *-------------------------------- Addressing ---------------------------------
>>>> + *
>>>> + * dom-id
>>>> + *      Values:         <uint16_t>
>>>> + *
>>>> + *      Domain identifier.
>>>> + *
>>>> + * dev-id
>>>> + *      Values:         <uint16_t>
>>>> + *
>>>> + *      Device identifier.
>>>> + *
>>>> + *      /local/domain/<dom-id>/device/vcamera/<dev-id>/...
>>>> + *
>>>> + *----------------------------- Protocol version ------------------------------
>>>> + *
>>>> + * version
>>>> + *      Values:         <string>
>>>> + *
>>>> + *      Protocol version, chosen among the ones supported by the backend.
>>>> + *
>>>> + *------------------------- Backend buffer allocation -------------------------
>>>> + *
>>>> + * be-alloc
>>> I thought that 'be' referred to 'big-endian', but apparently not. Perhaps it
>>> is better to just write 'backend-alloc'.
>> Well, 'be' and 'fe' are commonly used in Xen for backend
>> and frontend, so I'll probably stick to that convention for now.
>>>> + *      Values:         "0", "1"
>>>> + *
>>>> + *      If value is set to "1", then backend will be the buffer
>>>> + *      provider/allocator for this domain during XENCAMERA_OP_BUF_CREATE
>>>> + *      operation.
>>>> + *      If value is not "1" or omitted frontend must allocate buffers itself.
>>>> + *
>>>> + *------------------------------- Camera settings -----------------------------
>>>> + *
>>>> + * unique-id
>>>> + *      Values:         <string>
>>>> + *
>>>> + *      After device instance initialization each camera is assigned a
>>>> + *      unique ID, so it can be identified by the backend by this ID.
>>>> + *      This can be UUID or such.
>>>> + *
>>>> + * controls
>>>> + *      Values:         <list of string>
>>>> + *
>>>> + *      List of supported camera controls separated by XENCAMERA_LIST_SEPARATOR.
>>>> + *      Camera controls are expressed as a list of string values w/o any
>>>> + *      ordering requirement.
>>>> + *
>>>> + * formats
>>>> + *      Values:         <format, char[4]>
>>>> + *
>>>> + *      Formats are organized as a set of directories one per each
>>>> + *      supported pixel format. The name of the directory is an upper case
>>>> + *      string of the corresponding FOURCC string label. The next level of
>>>> + *      the directory under <formats> represents supported resolutions.
>>> Lower-case characters are also use in pixelformats, so I'd just keep this as-is.
>> Ok, no problem - will remove the 'upper case' from the definition
>>> In addition it is common to set bit 31 of the fourcc to 1 if the format is
>>> big-endian (see v4l2_fourcc_be macro). When v4l utilities print this format we
>>> add a -BE suffix, so V4L2_PIX_FMT_ARGB555X becomes "AR15-BE". You might want to
>>> keep that convention.
>> I'll think about it, thank you
>>>> + *
>>>> + * resolution
>>>> + *      Values:         <width, uint32_t>x<height, uint32_t>
>>>> + *
>>>> + *      Resolutions are organized as a set of directories one per each
>>>> + *      supported resolution under corresponding <formats> directory.
>>>> + *      The name of the directory is the supported width and height
>>>> + *      of the camera resolution in pixels.
>>> What if you are dealing with an HDMI input? Not unreasonable for media
>>> systems. There can be a lot of resolutions/framerates, and the resolution
>>> can change on the fly, or of course disappear.
>> Well, this is a part of the system configuration done
>> before we actually run the VMs, e.g. at system design
>> and configuration time. Most of the time you do know which
>> resolutions, frame rates etc. you want to assign and these
>> settings remain static for the whole lifetime of that VM.
>> If you are designing a system which needs these resolutions
>> to change at run-time then this can be done:
>> 1. Backend changes the state of the frontend to XenbusStateClosed state
>> 2. Xen (xl/libxl) or backend change the configuration in XenStore
>> 3. Backend re-initializes the frontend which reads new configuration
>>> What is also missing here is a way to report pixel aspect ratio: PAL and
>>> NTSC-based video material doesn't have square pixels.
>> Hm, indeed, thank you. I'll put this as a fraction under
>> the corresponding 'resolution':
>>
>> Now:
>> /local/domain/2/device/vcamera/0/formats/YUYV/640x480 = "30/1,15/1,15/2"
>> /local/domain/2/device/vcamera/0/formats/YUYV/1280x1024 = "015/2"
>>
>> Will change to:
>> /local/domain/2/device/vcamera/0/formats/YUYV/640x480/framerates/ =
>> "30/1,15/1,15/2"
>> /local/domain/2/device/vcamera/0/formats/YUYV/640x480/aspectratio = "1/1"
> You need to be more precise: aspectratio can refer to the display aspect
> ratio or the pixel aspect ratio, and you can calculate one from the other.
>
> So this is either pixelaspectratio or displayaspectratio.
>
> Even though V4L2 provides a pixelaspectratio, I would recommend that you
> choose to export it as a displayaspectratio. It's easier for applications
> to handle.
ok, then "display-aspect-ratio"
>
> Please note that in the case of DVD/BluRay source material the same
> resolution can have different display aspect ratios: e.g. PAL can be
> 4:3 or 16:9, depending on whether it is widescreen or not.
>
ok
>> /local/domain/2/device/vcamera/0/formats/YUYV/1280x1024/framerates = "015/2"
>> /local/domain/2/device/vcamera/0/formats/YUYV/1280x1024/aspectratio =
>> "59/58"
>>
>>> It's important to decide whether or not you want to support video sources
>>> like that (HDMI, Composite/S-Video inputs, USB ports where users can connect
>>> or disconnect webcams) or if you stick to fixed camera pipelines.
>> I believe that this is all hidden from the frontend by the
>> backend, so I se nothing we have to put in the protocol
>> with this respect.
>>> The big difference is that you don't control what someone can connect as
>>> external sources, so you will have to be a lot more careful and robust.
>>>
>>> I suspect that you likely will want to support such sources eventually, so
>>> it pays to design this with that in mind.
>> Again, I think that this is the backend to hide these
>> use-cases from the frontend.
> I'm not sure you can: say you are playing a bluray connected to the system
> with HDMI, then if there is a resolution change, what do you do? You can tear
> everything down and build it up again, or you can just tell frontends that
> something changed and that they have to look at the new vcamera configuration.
>
> The latter seems to be more sensible to me. It is really not much that you
> need to do: all you really need is an event signalling that something changed.
> In V4L2 that's the V4L2_EVENT_SOURCE_CHANGE.
well, this complicates things a lot as I'll have to
re-allocate buffers - right?
But anyways, I can add
#define XENCAMERA_EVT_CFG_CHANGE       0x01
in the protocol, so we can address this use-case
>
>>>> + *
>>>> + * frame-rates
>>>> + *      Values:         <numerator, uint32_t>/<denominator, uint32_t>
>>>> + *
>>>> + *      List of XENCAMERA_FRAME_RATE_SEPARATOR separated supported frame rates
>>>> + *      of the camera expressed as numerator and denominator of the
>>>> + *      corresponding frame rate.
>>>> + *
>>>> + * The format of the <formats> directory tree with resolutions and frame rates
>>>> + * must be structured in the following format:
>>>> + *
>>>> + * .../vcamera/<dev-id>/<format[i]>/<resolution[j]>/<frame-rates[k]>
>>>> + *
>>>> + * where
>>>> + *  i - i-th supported pixel format
>>>> + *  j - j-th supported resolution for i-th pixel format
>>>> + *  k - k-th supported frame rate for i-th pixel format and j-th
>>>> + *      resolution> + *
>>>> + *------------------- Camera Request Transport Parameters ---------------------
>>>> + *
>>>> + * This communication path is used to deliver requests from frontend to backend
>>>> + * and get the corresponding responses from backend to frontend,
>>>> + * set up per virtual camera device.
>>>> + *
>>>> + * req-event-channel
>>>> + *      Values:         <uint32_t>
>>>> + *
>>>> + *      The identifier of the Xen camera's control event channel
>>>> + *      used to signal activity in the ring buffer.
>>>> + *
>>>> + * req-ring-ref
>>>> + *      Values:         <uint32_t>
>>>> + *
>>>> + *      The Xen grant reference granting permission for the backend to map
>>>> + *      a sole page of camera's control ring buffer.
>>>> + *
>>>> + *-------------------- Camera Event Transport Parameters ----------------------
>>>> + *
>>>> + * This communication path is used to deliver asynchronous events from backend
>>>> + * to frontend, set up per virtual camera device.
>>>> + *
>>>> + * evt-event-channel
>>>> + *      Values:         <uint32_t>
>>>> + *
>>>> + *      The identifier of the Xen camera's event channel
>>>> + *      used to signal activity in the ring buffer.
>>>> + *
>>>> + * evt-ring-ref
>>>> + *      Values:         <uint32_t>
>>>> + *
>>>> + *      The Xen grant reference granting permission for the backend to map
>>>> + *      a sole page of camera's event ring buffer.
>>>> + */
>>>> +
>>>> +/*
>>>> + ******************************************************************************
>>>> + *                               STATE DIAGRAMS
>>>> + ******************************************************************************
>>>> + *
>>>> + * Tool stack creates front and back state nodes with initial state
>>>> + * XenbusStateInitialising.
>>>> + * Tool stack creates and sets up frontend camera configuration
>>>> + * nodes per domain.
>>>> + *
>>>> + *-------------------------------- Normal flow --------------------------------
>>>> + *
>>>> + * Front                                Back
>>>> + * =================================    =====================================
>>>> + * XenbusStateInitialising              XenbusStateInitialising
>>>> + *                                       o Query backend device identification
>>>> + *                                         data.
>>>> + *                                       o Open and validate backend device.
>>>> + *                                                |
>>>> + *                                                |
>>>> + *                                                V
>>>> + *                                      XenbusStateInitWait
>>>> + *
>>>> + * o Query frontend configuration
>>>> + * o Allocate and initialize
>>>> + *   event channels per configured
>>>> + *   camera.
>>>> + * o Publish transport parameters
>>>> + *   that will be in effect during
>>>> + *   this connection.
>>>> + *              |
>>>> + *              |
>>>> + *              V
>>>> + * XenbusStateInitialised
>>>> + *
>>>> + *                                       o Query frontend transport parameters.
>>>> + *                                       o Connect to the event channels.
>>>> + *                                                |
>>>> + *                                                |
>>>> + *                                                V
>>>> + *                                      XenbusStateConnected
>>>> + *
>>>> + *  o Create and initialize OS
>>>> + *    virtual camera as per
>>>> + *    configuration.
>>>> + *              |
>>>> + *              |
>>>> + *              V
>>>> + * XenbusStateConnected
>>>> + *
>>>> + *                                      XenbusStateUnknown
>>>> + *                                      XenbusStateClosed
>>>> + *                                      XenbusStateClosing
>>>> + * o Remove virtual camera device
>>>> + * o Remove event channels
>>>> + *              |
>>>> + *              |
>>>> + *              V
>>>> + * XenbusStateClosed
>>>> + *
>>>> + *------------------------------- Recovery flow -------------------------------
>>>> + *
>>>> + * In case of frontend unrecoverable errors backend handles that as
>>>> + * if frontend goes into the XenbusStateClosed state.
>>>> + *
>>>> + * In case of backend unrecoverable errors frontend tries removing
>>>> + * the virtualized device. If this is possible at the moment of error,
>>>> + * then frontend goes into the XenbusStateInitialising state and is ready for
>>>> + * new connection with backend. If the virtualized device is still in use and
>>>> + * cannot be removed, then frontend goes into the XenbusStateReconfiguring state
>>>> + * until either the virtualized device is removed or backend initiates a new
>>>> + * connection. On the virtualized device removal frontend goes into the
>>>> + * XenbusStateInitialising state.
>>>> + *
>>>> + * Note on XenbusStateReconfiguring state of the frontend: if backend has
>>>> + * unrecoverable errors then frontend cannot send requests to the backend
>>>> + * and thus cannot provide functionality of the virtualized device anymore.
>>>> + * After backend is back to normal the virtualized device may still hold some
>>>> + * state: configuration in use, allocated buffers, client application state etc.
>>>> + * In most cases, this will require frontend to implement complex recovery
>>>> + * reconnect logic. Instead, by going into XenbusStateReconfiguring state,
>>>> + * frontend will make sure no new clients of the virtualized device are
>>>> + * accepted, allow existing client(s) to exit gracefully by signaling error
>>>> + * state etc.
>>>> + * Once all the clients are gone frontend can reinitialize the virtualized
>>>> + * device and get into XenbusStateInitialising state again signaling the
>>>> + * backend that a new connection can be made.
>>>> + *
>>>> + * There are multiple conditions possible under which frontend will go from
>>>> + * XenbusStateReconfiguring into XenbusStateInitialising, some of them are OS
>>>> + * specific. For example:
>>>> + * 1. The underlying OS framework may provide callbacks to signal that the last
>>>> + *    client of the virtualized device has gone and the device can be removed
>>>> + * 2. Frontend can schedule a deferred work (timer/tasklet/workqueue)
>>>> + *    to periodically check if this is the right time to re-try removal of
>>>> + *    the virtualized device.
>>>> + * 3. By any other means.
>>>> + *
>>>> + ******************************************************************************
>>>> + *                             REQUEST CODES
>>>> + ******************************************************************************
>>>> + */
>>>> +#define XENCAMERA_OP_SET_CONFIG        0x00
>>>> +#define XENCAMERA_OP_GET_BUF_DETAILS   0x01
>>>> +#define XENCAMERA_OP_BUF_CREATE        0x02
>>>> +#define XENCAMERA_OP_BUF_DESTROY       0x03
>>>> +#define XENCAMERA_OP_STREAM_START      0x04
>>>> +#define XENCAMERA_OP_STREAM_STOP       0x05
>>>> +#define XENCAMERA_OP_GET_CTRL_DETAILS  0x06
>>>> +#define XENCAMERA_OP_SET_CTRL          0x07
>> I am thinking about extending the command set a bit as it already
>> has some flaws, e.g. there is no way for a VM to tell the backend
>> that the buffer is not in use anymore and can be given back
>> to the real HW driver, e.g. queue/dequeue in V4L2 terms:
>>
>> #define XENCAMERA_OP_SET_FORMAT        0x00
>> - will be used to set format: pixel format, resolution
>>
>> #define XENCAMERA_OP_SET_FRAME_RATE    0x01
>> - used to set the frame rate
>>
>> #define XENCAMERA_OP_BUF_REQUEST       0x02
>> - asks backend to allocate the given number of buffers,
>> backend replies with real number of those to be used
>>
>> #define XENCAMERA_OP_BUF_CREATE        0x03
>> - create a shared buffer
>>
>> #define XENCAMERA_OP_BUF_DESTROY       0x04
>> - destroy a shared buffer
>>
>> #define XENCAMERA_OP_BUF_QUEUE         0x05
>> - VM tells the backend that it has access to the shared buffer
>> and the buffer cannot be sent back to real HW driver
>>
>> #define XENCAMERA_OP_BUF_DEQUEUE       0x06
>> - VM tells the backend that the shared buffer is not in use and
>> can be sent to real HW driver
> This is the wrong way around: QUEUE would queue the shared buffer to
> the backend for use with the real HW driver, DEQUEUE would dequeue it
> for use in the VM.
Indeed, thank you for spotting this
>
>> #define XENCAMERA_OP_CTRL_ENUM         0x07
>> - get i-th control ranges and settings
>>
>> #define XENCAMERA_OP_CTRL_GET          0x08
>> - get control value
>>
>> #define XENCAMERA_OP_CTRL_SET          0x09
>> - set control value
>>
>> #define XENCAMERA_OP_STREAM_START      0x0a
>> - start streaming
>>
>> #define XENCAMERA_OP_STREAM_STOP       0x0b
>> - stop ctreaming
>>
>>
>>>> +
>>>> +#define XENCAMERA_CTRL_BRIGHTNESS      0x00
>>>> +#define XENCAMERA_CTRL_CONTRAST        0x01
>>>> +#define XENCAMERA_CTRL_SATURATION      0x02
>>>> +#define XENCAMERA_CTRL_HUE             0x03
>>>> +
>>>> +/*
>>>> + ******************************************************************************
>>>> + *                                 EVENT CODES
>>>> + ******************************************************************************
>>>> + */
>>>> +#define XENCAMERA_EVT_FRAME_AVAIL      0x00
>>>> +
>>>> +/*
>>>> + ******************************************************************************
>>>> + *               XENSTORE FIELD AND PATH NAME STRINGS, HELPERS
>>>> + ******************************************************************************
>>>> + */
>>>> +#define XENCAMERA_DRIVER_NAME          "vcamera"
>>> Ah, that's where vcamera comes from. How about calling this xen-camera or
>>> virt-camera? With a preference for xen-camera, since that's what you use for the
>>> defines as well.
>>>
>>> Or perhaps pv-camera?
>>>
>>> Is this driver going to be xen-specific, or more a general approach that everyone
>>> can use? Obviously, the latter would be preferable.
>> As I have already replied to the cover letter with explanations:
>> 'v' stands for 'virtual' and there is a convention to name the
>> Xen virtual devices starting with 'v': vif, vkbd etc.
> Yeah, ignore my comment.
>
>>> BTW, I am not sure if you are aware of this, but the V4L2 API also has support for
>>> radio and RDS hardware. Contact me if this is of interest to Xen to support this as
>>> well given the automotive use-case.
>> Yes, thank you, but at this stage we are targeting camera only.
>> Radio can be another topic if time allows ;) And most probably
>> it will be a dedicated 'vradio' protocol then...
>>>> +
>>>> +#define XENCAMERA_LIST_SEPARATOR       ","
>>>> +#define XENCAMERA_RESOLUTION_SEPARATOR "x"
>>>> +#define XENCAMERA_FRAME_RATE_SEPARATOR "/"
>>>> +
>>>> +#define XENCAMERA_FIELD_BE_VERSIONS    "versions"
>>>> +#define XENCAMERA_FIELD_FE_VERSION     "version"
>>>> +#define XENCAMERA_FIELD_REQ_RING_REF   "req-ring-ref"
>>>> +#define XENCAMERA_FIELD_REQ_CHANNEL    "req-event-channel"
>>>> +#define XENCAMERA_FIELD_EVT_RING_REF   "evt-ring-ref"
>>>> +#define XENCAMERA_FIELD_EVT_CHANNEL    "evt-event-channel"
>>>> +#define XENCAMERA_FIELD_CONTROLS       "controls"
>>>> +#define XENCAMERA_FIELD_FORMATS        "formats"
>>>> +#define XENCAMERA_FIELD_BE_ALLOC       "be-alloc"
>>>> +#define XENCAMERA_FIELD_UNIQUE_ID      "unique-id"
>>>> +
>>>> +#define XENCAMERA_CTRL_BRIGHTNESS_STR  "brightness"
>>>> +#define XENCAMERA_CTRL_CONTRAST_STR    "contrast"
>>>> +#define XENCAMERA_CTRL_SATURATION_STR  "saturation"
>>>> +#define XENCAMERA_CTRL_HUE_STR         "hue"
>>>> +
>>>> +/* Maximum number of buffer planes supported. */
>>>> +#define XENCAMERA_MAX_PLANE            4
>>>> +
>>>> +/*
>>>> + ******************************************************************************
>>>> + *                          STATUS RETURN CODES
>>>> + ******************************************************************************
>>>> + *
>>>> + * Status return code is zero on success and -XEN_EXX on failure.
>>>> + *
>>>> + ******************************************************************************
>>>> + *                              Assumptions
>>>> + ******************************************************************************
>>>> + *
>>>> + * - usage of grant reference 0 as invalid grant reference:
>>>> + *   grant reference 0 is valid, but never exposed to a PV driver,
>>>> + *   because of the fact it is already in use/reserved by the PV console.
>>>> + * - all references in this document to page sizes must be treated
>>>> + *   as pages of size XEN_PAGE_SIZE unless otherwise noted.
>>>> + *
>>>> + ******************************************************************************
>>>> + *       Description of the protocol between frontend and backend driver
>>>> + ******************************************************************************
>>>> + *
>>>> + * The two halves of a Para-virtual camera driver communicate with
>>>> + * each other using shared pages and event channels.
>>>> + * Shared page contains a ring with request/response packets.
>>>> + *
>>>> + * All reserved fields in the structures below must be 0.
>>>> + *
>>>> + * For all request/response/event packets:
>>>> + *   - frame rate parameter is represented as a pair of 4 octet long
>>>> + *     numerator and denominator:
>>>> + *       - frame_rate_numer - uint32_t, numerator of the frame rate
>>>> + *       - frame_rate_denom - uint32_t, denominator of the frame rate
>>>> + *     The corresponding frame rate (Hz) is calculated as:
>>>> + *       frame_rate = frame_rate_numer / frame_rate_denom
>>>> + *   - buffer index is a zero based index of the buffer. Must be less than
>>>> + *     the value of XENCAMERA_OP_SET_CONFIG.num_bufs response:
>>>> + *       - index - uint8_t, index of the buffer.
>>>> + *
>>>> + *
>>>> + *---------------------------------- Requests ---------------------------------
>>>> + *
>>>> + * All request packets have the same length (64 octets).
>>>> + * All request packets have common header:
>>>> + *         0                1                 2               3        octet
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |               id                |    operation   |   reserved     | 4
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             reserved                              | 8
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + *   id - uint16_t, private guest value, echoed in response.
>>>> + *   operation - uint8_t, operation code, XENCAMERA_OP_XXX.
>>>> + *
>>>> + *
>>>> + * Request configuration set/reset - request to set or reset.
>>>> + * the configuration/mode of the camera:
>>>> + *         0                1                 2               3        octet
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |               id                | _OP_SET_CONFIG |   reserved     | 4
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             reserved                              | 8
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                            pixel format                           | 12
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                               width                               | 16
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                               height                              | 20
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                          frame_rate_numer                         | 24
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                          frame_rate_denom                         | 28
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |    num_bufs    |                     reserved                     | 32
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              reserved                             | 36
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              reserved                             | 64
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + *
>>>> + * Pass all zeros to reset, otherwise command is treated as configuration set.
>>>> + *
>>>> + * pixel_format - uint32_t, pixel format to be used, FOURCC code.
>>>> + * width - uint32_t, width in pixels.
>>>> + * height - uint32_t, height in pixels.
>>>> + * frame_rate_numer - uint32_t, numerator of the frame rate.
>>>> + * frame_rate_denom - uint32_t, denominator of the frame rate.
>>> If you have to support HDMI/SDTV inputs as well, then you also need to know
>>> the interlaced format, unless you have no plans to support that.
>>>
>>>> + * num_bufs - uint8_t, desired number of buffers to be used.
>>> Huh? What has that to do with the format? Why would you need this here?
>> Well, the operation name is 'set_config', not 'set_format',
>> so I thought we can have such a cumulative command assembling
>> all the parameters of the configuration. But now I am looking at
>> turning this single 'set_config' command to 3 different commands,
>> which is more practical and aligned with V4L2 in particular (please
>> see above in the command set):
>> 1. set format command:
>>    * pixel_format - uint32_t, pixel format to be used, FOURCC code.
>>    * width - uint32_t, width in pixels.
>>    * height - uint32_t, height in pixels.
>>
>> 2. Set frame rate command:
>>    + * frame_rate_numer - uint32_t, numerator of the frame rate.
>>    + * frame_rate_denom - uint32_t, denominator of the frame rate.
>>
>> 3. Set/request num bufs:
>>    * num_bufs - uint8_t, desired number of buffers to be used.
> I like this much better. 1+2 could be combined, but 3 should definitely remain
> separate.
ok, then 1+2 combined + 3 separate.
Do you think we can still name 1+2 as "set_format" or "set_config"
will fit better?
>
>>>> + *
>>>> + * See response format for this request.
>>>> + *
>>>> + * Notes:
>>>> + *  - frontend must check the corresponding response in order to see
>>>> + *    if the values reported back by the backend do match the desired ones
>>>> + *    and can be accepted.
>>>> + *  - frontend may send multiple XENCAMERA_OP_SET_CONFIG requests before
>>>> + *    sending XENCAMERA_OP_STREAM_START request to update or tune the
>>>> + *    configuration.
>>>> + */
>>>> +struct xencamera_config {
>>>> +    uint32_t pixel_format;
>>>> +    uint32_t width;
>>>> +    uint32_t height;
>>>> +    uint32_t frame_rate_nom;
>>>> +    uint32_t frame_rate_denom;
>>>> +    uint8_t num_bufs;
>>>> +};
>>>> +
>>>> +/*
>>>> + * Request buffer details - request camera buffer's memory layout.
>>>> + * detailed description:
>>>> + *         0                1                 2               3        octet
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |               id                |_GET_BUF_DETAILS|   reserved     | 4
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              reserved                             | 8
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              reserved                             | 64
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + *
>>>> + * See response format for this request.
>>>> + *
>>>> + *
>>>> + * Request camera buffer creation:
>>>> + *         0                1                 2               3        octet
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |               id                | _OP_BUF_CREATE |   reserved     | 4
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             reserved                              | 8
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |      index     |                     reserved                     | 12
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                           gref_directory                          | 16
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             reserved                              | 20
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             reserved                              | 64
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + *
>>>> + * An attempt to create multiple buffers with the same index is an error.
>>>> + * index can be re-used after destroying the corresponding camera buffer.
>>>> + *
>>>> + * index - uint8_t, index of the buffer to be created.
>>>> + * gref_directory - grant_ref_t, a reference to the first shared page
>>>> + *   describing shared buffer references. The size of the buffer is equal to
>>>> + *   XENCAMERA_OP_GET_BUF_DETAILS.size response. At least one page exists. If
>>>> + *   shared buffer size exceeds what can be addressed by this single page,
>>>> + *   then reference to the next shared page must be supplied (see
>>>> + *   gref_dir_next_page below).
>>> It might be better to allocate all buffers in one go, i.e. what VIDIOC_REQBUFS
>>> does.
>> Well, I still think it is better to have a per buffer interface
>> in the protocol as it is done for other Xen virtual devices.
>> So, I'll keep this as is for now: VIDIOC_REQBUFS can still do
>> what it does internally in the frontend driver
> I may have misunderstood the original API. The newly proposed XENCAMERA_OP_BUF_REQUEST
> maps to REQBUFS, right? And then BUF_CREATE/DESTROY just set up the shared buffer
> mappings for the buffers created by REQBUFS. If that's the sequence, then it makes
> sense. I'm not sure about the naming.
>
> You might want to make it clear that XENCAMERA_OP_BUF_REQUEST allocates the buffers
> on the backend, and so can fail. Also, the actual number of allocated buffers in
> case of success can be more or less than what was requested.
The buffers can be allocated and shared by either backend or frontend: see
"be-alloc" configuration option telling which domain (VM) shares
the Xen grant references to the pages of the buffer: either frontend
or backend.

So, I was more thinking that in case of V4L2 based frontend driver:
1. Frontend serves REQBUFS ioctl and asks the backend with 
XENCAMERA_OP_BUF_REQUEST
if it can handle that many buffers and gets number of buffers to be used
and buffer structure (number of planes, sizes, offsets etc.) as the reply
to that request
2. Frontend creates n buffers with XENCAMERA_OP_BUF_CREATE
3. Frontend returns from REQBUFS ioctl with actual number of buffers
allocated
>>>> + *
>>>> + * If XENCAMERA_FIELD_BE_ALLOC configuration entry is set, then backend will
>>>> + * allocate the buffer with the parameters provided in this request and page
>>>> + * directory is handled as follows:
>>>> + *   Frontend on request:
>>>> + *     - allocates pages for the directory (gref_directory,
>>>> + *       gref_dir_next_page(s)
>>>> + *     - grants permissions for the pages of the directory to the backend
>>>> + *     - sets gref_dir_next_page fields
>>>> + *   Backend on response:
>>>> + *     - grants permissions for the pages of the buffer allocated to
>>>> + *       the frontend
>>>> + *     - fills in page directory with grant references
>>>> + *       (gref[] in struct xencamera_page_directory)
>>>> + */
>>>> +struct xencamera_buf_create_req {
>>>> +    uint8_t index;
>>>> +    uint8_t reserved[3];
>>>> +    grant_ref_t gref_directory;
>>>> +};
>>>> +
>>>> +/*
>>>> + * Shared page for XENCAMERA_OP_BUF_CREATE buffer descriptor (gref_directory in
>>>> + * the request) employs a list of pages, describing all pages of the shared
>>>> + * data buffer:
>>>> + *         0                1                 2               3        octet
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                        gref_dir_next_page                         | 4
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              gref[0]                              | 8
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              gref[i]                              | i*4+8
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             gref[N - 1]                           | N*4+8
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + *
>>>> + * gref_dir_next_page - grant_ref_t, reference to the next page describing
>>>> + *   page directory. Must be 0 if there are no more pages in the list.
>>>> + * gref[i] - grant_ref_t, reference to a shared page of the buffer
>>>> + *   allocated at XENCAMERA_OP_BUF_CREATE.
>>>> + *
>>>> + * Number of grant_ref_t entries in the whole page directory is not
>>>> + * passed, but instead can be calculated as:
>>>> + *   num_grefs_total = (XENCAMERA_OP_GET_BUF_DETAILS.size + XEN_PAGE_SIZE - 1) /
>>>> + *       XEN_PAGE_SIZE
>>>> + */
>>>> +struct xencamera_page_directory {
>>>> +    grant_ref_t gref_dir_next_page;
>>>> +    grant_ref_t gref[1]; /* Variable length */
>>>> +};
>>>> +
>>>> +/*
>>>> + * Request buffer destruction - destroy a previously allocated camera buffer:
>>>> + *         0                1                 2               3        octet
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |               id                | _OP_BUF_DESTROY|   reserved     | 4
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             reserved                              | 8
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |      index     |                     reserved                     | 12
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             reserved                              | 16
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             reserved                              | 64
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + *
>>>> + * index - uint8_t, index of the buffer to be destroyed.
>>>> + */
>>> There is no V4L2 ioctl to destroy specific buffers. You can only destroy all
>>> of them.
>> This is not specifically related to V4L2, but can be issued
>> in response to backend's state change etc.
>> So, we have a pair of commands to create and destroy buffers.
>> Even more, frontend can be a some-os-based-driver, not V4L2
>> based. Or even a user-space application if your will.
>>>> +
>>>> +struct xencamera_buf_destroy_req {
>>>> +    uint8_t index;
>>>> +};
>>>> +
>>>> +/*
>>>> + * Request camera capture stream start:
>>>> + *         0                1                 2               3        octet
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |               id                |_OP_STREAM_START|   reserved     | 4
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             reserved                              | 8
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             reserved                              | 64
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + *
>>>> + *
>>>> + * Request camera capture stream stop:
>>>> + *         0                1                 2               3        octet
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |               id                |_OP_STREAM_STOP |   reserved     | 4
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             reserved                              | 8
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             reserved                              | 64
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + *
>>>> + *
>>>> + * Request camera control details:
>>>> + *         0                1                 2               3        octet
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |               id                |GET_CTRL_DETAILS|   reserved     | 4
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |      index     |                     reserved                     | 12
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             reserved                              | 16
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             reserved                              | 64
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + *
>>>> + * See response format for this request.
>>>> + *
>>>> + * index - uint8_t, index of the control to be queried.
>>>> + */
>>>> +struct xencamera_get_ctrl_details_req {
>>>> +    uint8_t index;
>>>> +};
>>>> +
>>>> +/*
>>>> + *
>>>> + * Request camera control change:
>>>> + *         0                1                 2               3        octet
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |               id                |  _OP_SET_CTRL  |   reserved     | 4
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |      index     |                     reserved                     | 12
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                               value                               | 16
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             reserved                              | 20
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                             reserved                              | 64
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + *
>>>> + * See response format for this request.
>>>> + *
>>>> + * index - uint8_t, index of the control.
>>>> + * value - int32_t, new value of the control.
>>> I would recommend using a int64_t as the control value.
>> Good point, thank you
>>> Note that there are also controls with a payload (e.g. string controls).
>> Could you please give me an example of such a control?
>> Do you think such controls can be of use in a VM?
>> Can we avoid such controls if we target a simple virtual
>> camera device? If this is for radio use-case, then we'll
>> have such support in 'vradio' protocol if need be
> Right now all string controls are related to RDS receivers/transmitters. If you
> ever decide on a vradio protocol, then you need these (Programme Service name
> and Radio Text info). And there is an array of Alternate Frequencies, also RDS
> specific.
>
> There are some array controls in V4L2, those are used to control motion detection
> for surveillance cameras. And 'compound controls' (think of this as C structs) are
> appearing for HW codecs.
>
> I don't think any of these are likely to appear for cameras, at least not in a
> way that is relevant for Xen.
ok
>>> If there is ever interest in adding radio/RDS support, then that will become
>>> an issue.
>> You mean something like station names, ads etc?
> Yup.
>
>>>> + */
>>>> +struct xencamera_set_ctrl_req {
>>>> +    uint8_t index;
>>>> +    uint8_t reserved[3];
>>>> +    int32_t value;
>>>> +};
>>>> +
>>>> +/*
>>>> + *---------------------------------- Responses --------------------------------
>>>> + *
>>>> + * All response packets have the same length (64 octets).
>>>> + *
>>>> + * All response packets have common header:
>>>> + *         0                1                 2               3        octet
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |               id                |    operation   |    reserved    | 4
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              status                               | 8
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + *
>>>> + * id - uint16_t, copied from the request.
>>>> + * operation - uint8_t, XENCAMERA_OP_* - copied from request.
>>>> + * status - int32_t, response status, zero on success and -XEN_EXX on failure.
>>>> + *
>>>> + *
>>>> + * Set configuration response - response for XENCAMERA_OP_SET_CONFIG:
>>>> + *         0                1                 2               3        octet
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |               id                | _OP_SET_CONFIG |    reserved    | 4
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                               status                              | 8
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                            pixel format                           | 12
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                               width                               | 16
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                               height                              | 20
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                          frame_rate_numer                         | 24
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                          frame_rate_denom                         | 28
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |    num_bufs    |                     reserved                     | 32
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              reserved                             | 36
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              reserved                             | 64
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + *
>>>> + * Meaning of the corresponding values in this response is the same as for
>>>> + * XENCAMERA_OP_SET_CONFIG request.
>>>> + *
>>>> + *
>>>> + * Request buffer details response - response for XENCAMERA_OP_GET_BUF_DETAILS
>>>> + * request:
>>>> + *         0                1                 2               3        octet
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |               id                |_GET_BUF_DETAILS|    reserved    | 4
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                               status                              | 8
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                                size                               | 12
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |   num_planes   |                     reserved                     | 16
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                          plane_offset[0]                          | 20
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                          plane_offset[1]                          | 24
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                          plane_offset[2]                          | 28
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                          plane_offset[3]                          | 32
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                           plane_size[0]                           | 36
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                           plane_size[1]                           | 40
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                           plane_size[2]                           | 44
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                           plane_size[3]                           | 48
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |         plane_stride[0]         |         plane_stride[1]         | 52
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |         plane_stride[2]         |         plane_stride[3]         | 56
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              reserved                             | 60
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              reserved                             | 64
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + *
>>>> + * size - uint32_t, overall size of the buffer including sizes of the
>>>> + *   individual planes and padding if applicable.
>>>> + * num_planes - uint8_t, number of planes for this buffer.
>>>> + * plane_offset - array of uint32_t, offset of the corresponding plane
>>>> + *   in octets from the buffer start.
>>>> + * plane_size - array of uint32_t, size in octets of the corresponding plane
>>>> + *   including padding.
>>>> + * plane_stride - array of uint32_t, size in octets occupied by the
>>>> + *   corresponding single image line including padding if applicable.
>>> Nice!
>> Thank you
>>>> + */
>>>> +struct xencamera_buf_details_resp {
>>>> +    uint32_t size;
>>>> +    uint8_t num_planes;
>>>> +    uint8_t reserved[3];
>>>> +    uint32_t plane_offset[XENCAMERA_MAX_PLANE];
>>>> +    uint32_t plane_size[XENCAMERA_MAX_PLANE];
>>>> +    uint16_t plane_stride[XENCAMERA_MAX_PLANE];
>>>> +};
>>>> +
>>>> +/*
>>>> + * Get control details response - response for XENCAMERA_OP_GET_CTRL_DETAILS:
>>>> + *         0                1                 2               3        octet
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |               id                |GET_CTRL_DETAILS|    reserved    | 4
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                               status                              | 8
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |     index      |      type      |             reserved            | 12
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                                min                                | 16
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                                max                                | 20
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                                step                               | 24
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              def_val                              | 28
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              reserved                             | 36
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              reserved                             | 64
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + *
>>>> + * index - uint8_t, index of the camera control in response.
>>>> + * type - uint8_t, type of the control, one of the XENCAMERA_CTRL_XXX.
>>>> + * min - int32_t, minimum value of the control.
>>>> + * max - int32_t, maximum value of the control.
>>>> + * step - int32_t, minimum size in which control value can be changed.
>>>> + * def_val - int32_t, default value of the control.
>>> I'd go with 64 bit values for min/max/step/def_val.
>> Sure, good idea, thank you
>>> I would also add a flags field. Some controls are read-only, write-only
>>> or volatile, things userspace needs to know.
>> Then I'll also add numerical constants for such
>>> If you want to support menu controls, then you need a way to get the menu
>>> names as well (VIDIOC_QUERYMENU).
>>>
>>> None of this is needed for this initial use-case, but you need to think
>>> about this up-front.
>> Yes, thank you
>>>> + */
>>>> +struct xencamera_get_ctrl_details_resp {
>>>> +    uint8_t index;
>>>> +    uint8_t type;
>>>> +    uint8_t reserved[2];
>>>> +    int32_t min;
>>>> +    int32_t max;
>>>> +    int32_t step;
>>>> +    int32_t def_val;
>>>> +};
>>>> +
>>>> +/*
>>>> + *----------------------------------- Events ----------------------------------
>>>> + *
>>>> + * Events are sent via a shared page allocated by the front and propagated by
>>>> + *   evt-event-channel/evt-ring-ref XenStore entries.
>>>> + *
>>>> + * All event packets have the same length (64 octets).
>>>> + * All event packets have common header:
>>>> + *         0                1                 2               3        octet
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |               id                |      type      |   reserved     | 4
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              reserved                             | 8
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + *
>>>> + * id - uint16_t, event id, may be used by front.
>>>> + * type - uint8_t, type of the event.
>>>> + *
>>>> + *
>>>> + * Frame captured event - event from back to front when a new captured
>>>> + * frame is available:
>>>> + *         0                1                 2               3        octet
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |               id                |_EVT_FRAME_AVAIL|   reserved     | 4
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              reserved                             | 8
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |      index     |                     reserved                     | 12
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              used_sz                              | 16
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              reserved                             | 20
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/|
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + * |                              reserved                             | 64
>>>> + * +----------------+----------------+----------------+----------------+
>>>> + *
>>>> + * index - uint8_t, index of the buffer that contains new captured frame.
>>>> + * used_sz - uint32_t, number of octets this frame has. This can be less
>>>> + * than the XENCAMERA_OP_GET_BUF_DETAILS.size for compressed formats.
>>>> + */
>>>> +struct xencamera_frame_avail_evt {
>>>> +    uint8_t index;
>>>> +    uint8_t reserved[3];
>>>> +    uint32_t used_sz;
>>>> +};
>>>> +
>>>> +struct xencamera_req {
>>>> +    uint16_t id;
>>>> +    uint8_t operation;
>>>> +    uint8_t reserved[5];
>>>> +    union {
>>>> +        struct xencamera_config config;
>>>> +        struct xencamera_buf_create_req buf_create;
>>>> +	struct xencamera_buf_destroy_req buf_destroy;
>>>> +	struct xencamera_set_ctrl_req set_ctrl;
>>>> +        uint8_t reserved[56];
>>>> +    } req;
>>>> +};
>>>> +
>>>> +struct xencamera_resp {
>>>> +    uint16_t id;
>>>> +    uint8_t operation;
>>>> +    uint8_t reserved;
>>>> +    int32_t status;
>>>> +    union {
>>>> +        struct xencamera_config config;
>>>> +        struct xencamera_buf_details_resp buf_details;
>>>> +	struct xencamera_get_ctrl_details_resp ctrl_details;
>>>> +        uint8_t reserved1[56];
>>>> +    } resp;
>>>> +};
>>>> +
>>>> +struct xencamera_evt {
>>>> +    uint16_t id;
>>>> +    uint8_t type;
>>>> +    uint8_t reserved[5];
>>>> +    union {
>>>> +        struct xencamera_frame_avail_evt frame_avail;
>>>> +        uint8_t reserved[56];
>>>> +    } evt;
>>>> +};
>>>> +
>>>> +DEFINE_RING_TYPES(xen_cameraif, struct xencamera_req, struct xencamera_resp);
>>>> +
>>>> +/*
>>>> + ******************************************************************************
>>>> + *                        Back to front events delivery
>>>> + ******************************************************************************
>>>> + * In order to deliver asynchronous events from back to front a shared page is
>>>> + * allocated by front and its granted reference propagated to back via
>>>> + * XenStore entries (evt-ring-ref/evt-event-channel).
>>>> + * This page has a common header used by both front and back to synchronize
>>>> + * access and control event's ring buffer, while back being a producer of the
>>>> + * events and front being a consumer. The rest of the page after the header
>>>> + * is used for event packets.
>>>> + *
>>>> + * Upon reception of an event(s) front may confirm its reception
>>>> + * for either each event, group of events or none.
>>>> + */
>>>> +
>>>> +struct xencamera_event_page {
>>>> +    uint32_t in_cons;
>>>> +    uint32_t in_prod;
>>>> +    uint8_t reserved[56];
>>>> +};
>>>> +
>>>> +#define XENCAMERA_EVENT_PAGE_SIZE 4096
>>>> +#define XENCAMERA_IN_RING_OFFS (sizeof(struct xencamera_event_page))
>>>> +#define XENCAMERA_IN_RING_SIZE (XENCAMERA_EVENT_PAGE_SIZE - XENCAMERA_IN_RING_OFFS)
>>>> +#define XENCAMERA_IN_RING_LEN (XENCAMERA_IN_RING_SIZE / sizeof(struct xencamera_evt))
>>>> +#define XENCAMERA_IN_RING(page) \
>>>> +	((struct xencamera_evt *)((char *)(page) + XENCAMERA_IN_RING_OFFS))
>>>> +#define XENCAMERA_IN_RING_REF(page, idx) \
>>>> +	(XENCAMERA_IN_RING((page))[(idx) % XENCAMERA_IN_RING_LEN])
>>>> +
>>>> +#endif /* __XEN_PUBLIC_IO_CAMERAIF_H__ */
>>>> +
>>>> +/*
>>>> + * Local variables:
>>>> + * mode: C
>>>> + * c-file-style: "BSD"
>>>> + * c-basic-offset: 4
>>>> + * tab-width: 4
>>>> + * indent-tabs-mode: nil
>>>> + * End:
>>>> + */
>>>>
>>> I think the most important decision to make here is whether or not you want to support
>>> hotpluggable sources like HDMI. And an additional complication with that is HDCP.
>>> While V4L2 doesn't have an API for HDCP at the moment, Cisco is working on this and
>>> a patch series adding this is expected later this year/early next year. It might not
>>> be an issue in practice if these are all closed systems, but nevertheless, it is
>>> something to think about.
>> Yes, thank you for raising these questions, it is worth thinking
>> about such use-cases.
>>> Regards,
>>>
>>> 	Hans
>> Thank you so much for the comments,
>> Oleksandr
>>
> Regards,
>
> 	Hans
Thank you,
Oleksandr
