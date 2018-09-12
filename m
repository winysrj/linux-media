Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:39180 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726555AbeILOUZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 10:20:25 -0400
Subject: Re: [Xen-devel][PATCH v2 1/1] cameraif: add ABI for para-virtual
 camera
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, konrad.wilk@oracle.com,
        jgross@suse.com, boris.ostrovsky@oracle.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        koji.matsuoka.xm@renesas.com
Cc: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180911082952.23322-1-andr2000@gmail.com>
 <20180911082952.23322-2-andr2000@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <fda62804-a193-a45c-9047-133d347a39b3@xs4all.nl>
Date: Wed, 12 Sep 2018 11:16:39 +0200
MIME-Version: 1.0
In-Reply-To: <20180911082952.23322-2-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/18 10:29, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> 
> This is the ABI for the two halves of a para-virtualized
> camera driver which extends Xen's reach multimedia capabilities even
> farther enabling it for video conferencing, In-Vehicle Infotainment,
> high definition maps etc.
> 
> The initial goal is to support most needed functionality with the
> final idea to make it possible to extend the protocol if need be:
> 
> 1. Provide means for base virtual device configuration:
>  - pixel formats
>  - resolutions
>  - frame rates
> 2. Support basic camera controls:
>  - contrast
>  - brightness
>  - hue
>  - saturation
> 3. Support streaming control
> 4. Support zero-copying use-cases
> 
> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> ---
>  xen/include/public/io/cameraif.h | 1263 ++++++++++++++++++++++++++++++
>  1 file changed, 1263 insertions(+)
>  create mode 100644 xen/include/public/io/cameraif.h
> 
> diff --git a/xen/include/public/io/cameraif.h b/xen/include/public/io/cameraif.h
> new file mode 100644
> index 000000000000..38b9b3741e75
> --- /dev/null
> +++ b/xen/include/public/io/cameraif.h
> @@ -0,0 +1,1263 @@
> +/******************************************************************************
> + * cameraif.h
> + *
> + * Unified camera device I/O interface for Xen guest OSes.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a copy
> + * of this software and associated documentation files (the "Software"), to
> + * deal in the Software without restriction, including without limitation the
> + * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
> + * sell copies of the Software, and to permit persons to whom the Software is
> + * furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
> + * DEALINGS IN THE SOFTWARE.
> + *
> + * Copyright (C) 2018 EPAM Systems Inc.
> + *
> + * Author: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> + */
> +
> +#ifndef __XEN_PUBLIC_IO_CAMERAIF_H__
> +#define __XEN_PUBLIC_IO_CAMERAIF_H__
> +
> +#include "ring.h"
> +#include "../grant_table.h"
> +
> +/*
> + ******************************************************************************
> + *                           Protocol version
> + ******************************************************************************
> + */
> +#define XENCAMERA_PROTOCOL_VERSION     "1"
> +
> +/*
> + ******************************************************************************
> + *                  Feature and Parameter Negotiation
> + ******************************************************************************
> + *
> + * Front->back notifications: when enqueuing a new request, sending a
> + * notification can be made conditional on xencamera_req (i.e., the generic
> + * hold-off mechanism provided by the ring macros). Backends must set
> + * xencamera_req appropriately (e.g., using RING_FINAL_CHECK_FOR_REQUESTS()).
> + *
> + * Back->front notifications: when enqueuing a new response, sending a
> + * notification can be made conditional on xencamera_resp (i.e., the generic
> + * hold-off mechanism provided by the ring macros). Frontends must set
> + * xencamera_resp appropriately (e.g., using RING_FINAL_CHECK_FOR_RESPONSES()).
> + *
> + * The two halves of a para-virtual camera driver utilize nodes within
> + * XenStore to communicate capabilities and to negotiate operating parameters.
> + * This section enumerates these nodes which reside in the respective front and
> + * backend portions of XenStore, following the XenBus convention.
> + *
> + * All data in XenStore is stored as strings. Nodes specifying numeric
> + * values are encoded in decimal. Integer value ranges listed below are
> + * expressed as fixed sized integer types capable of storing the conversion
> + * of a properly formatted node string, without loss of information.
> + *
> + ******************************************************************************
> + *                        Example configuration
> + ******************************************************************************
> + *
> + * This is an example of backend and frontend configuration:
> + *
> + *--------------------------------- Backend -----------------------------------
> + *
> + * /local/domain/0/backend/vcamera/1/0/frontend-id = "1"
> + * /local/domain/0/backend/vcamera/1/0/frontend = "/local/domain/1/device/vcamera/0"
> + * /local/domain/0/backend/vcamera/1/0/state = "4"
> + * /local/domain/0/backend/vcamera/1/0/versions = "1,2"
> + *
> + *--------------------------------- Frontend ----------------------------------
> + *
> + * /local/domain/1/device/vcamera/0/backend-id = "0"
> + * /local/domain/1/device/vcamera/0/backend = "/local/domain/0/backend/vcamera/1"
> + * /local/domain/1/device/vcamera/0/state = "4"
> + * /local/domain/1/device/vcamera/0/version = "1"
> + * /local/domain/1/device/vcamera/0/be-alloc = "1"
> + *
> + *---------------------------- Device 0 configuration -------------------------
> + *
> + * /local/domain/1/device/vcamera/0/controls = "contrast,hue"
> + * /local/domain/1/device/vcamera/0/formats/YUYV/640x480/frame-rates = "30/1,15/1"
> + * /local/domain/1/device/vcamera/0/formats/YUYV/1920x1080/frame-rates = "15/2"
> + * /local/domain/1/device/vcamera/0/formats/BGRA/640x480/frame-rates = "15/1,15/2"
> + * /local/domain/1/device/vcamera/0/formats/BGRA/1200x720/frame-rates = "15/2"
> + * /local/domain/1/device/vcamera/0/unique-id = "0"
> + * /local/domain/1/device/vcamera/0/req-ring-ref = "2832"
> + * /local/domain/1/device/vcamera/0/req-event-channel = "15"
> + * /local/domain/1/device/vcamera/0/evt-ring-ref = "387"
> + * /local/domain/1/device/vcamera/0/evt-event-channel = "16"
> + *
> + *---------------------------- Device 1 configuration -------------------------
> + *
> + * /local/domain/1/device/vcamera/1/controls = "brightness,saturation,hue"
> + * /local/domain/1/device/vcamera/1/formats/YUYV/640x480/frame-rates = "30/1,15/2"
> + * /local/domain/1/device/vcamera/1/formats/YUYV/1920x1080/frame-rates = "15/2"
> + * /local/domain/1/device/vcamera/1/unique-id = "1"
> + * /local/domain/1/device/vcamera/1/req-ring-ref = "2833"
> + * /local/domain/1/device/vcamera/1/req-event-channel = "17"
> + * /local/domain/1/device/vcamera/1/evt-ring-ref = "388"
> + * /local/domain/1/device/vcamera/1/evt-event-channel = "18"

One thing I haven't paid attention to are inputs: how do you handle devices with
multiple inputs, but you can only stream from one input at a time.

Typically found with surveillance cards that have multiple inputs and you can
cycle through those inputs. But also HDMI capture boards with multiple inputs
(just like a TV). The vivid driver can emulate this if you want to test this.



> + *
> + ******************************************************************************
> + *                            Backend XenBus Nodes
> + ******************************************************************************
> + *
> + *----------------------------- Protocol version ------------------------------
> + *
> + * versions
> + *      Values:         <string>
> + *
> + *      List of XENCAMERA_LIST_SEPARATOR separated protocol versions supported
> + *      by the backend. For example "1,2,3".
> + *
> + ******************************************************************************
> + *                            Frontend XenBus Nodes
> + ******************************************************************************
> + *
> + *-------------------------------- Addressing ---------------------------------
> + *
> + * dom-id
> + *      Values:         <uint16_t>
> + *
> + *      Domain identifier.
> + *
> + * dev-id
> + *      Values:         <uint16_t>
> + *
> + *      Device identifier.
> + *
> + *      /local/domain/<dom-id>/device/vcamera/<dev-id>/...
> + *
> + *----------------------------- Protocol version ------------------------------
> + *
> + * version
> + *      Values:         <string>
> + *
> + *      Protocol version, chosen among the ones supported by the backend.
> + *
> + *------------------------- Backend buffer allocation -------------------------
> + *
> + * be-alloc
> + *      Values:         "0", "1"
> + *
> + *      If value is set to "1", then backend will be the buffer
> + *      provider/allocator for this domain during XENCAMERA_OP_BUF_CREATE
> + *      operation.
> + *      If value is not "1" or omitted frontend must allocate buffers itself.
> + *
> + *------------------------------- Camera settings -----------------------------
> + *
> + * unique-id
> + *      Values:         <string>
> + *
> + *      After device instance initialization each camera is assigned a
> + *      unique ID, so it can be identified by the backend by this ID.
> + *      This can be UUID or such.
> + *
> + * controls
> + *      Values:         <list of string>
> + *
> + *      List of supported camera controls separated by XENCAMERA_LIST_SEPARATOR.
> + *      Camera controls are expressed as a list of string values w/o any
> + *      ordering requirement.
> + *
> + * formats
> + *      Values:         <format, char[4]>
> + *
> + *      Formats are organized as a set of directories one per each
> + *      supported pixel format. The name of the directory is the
> + *      corresponding FOURCC string label. The next level of
> + *      the directory under <formats> represents supported resolutions.
> + *
> + * resolution
> + *      Values:         <width, uint32_t>x<height, uint32_t>
> + *
> + *      Resolutions are organized as a set of directories one per each
> + *      supported resolution under corresponding <formats> directory.
> + *      The name of the directory is the supported width and height
> + *      of the camera resolution in pixels.
> + *
> + * frame-rates
> + *      Values:         <numerator, uint32_t>/<denominator, uint32_t>
> + *
> + *      List of XENCAMERA_FRAME_RATE_SEPARATOR separated supported frame rates
> + *      of the camera expressed as numerator and denominator of the
> + *      corresponding frame rate.
> + *
> + *------------------- Camera Request Transport Parameters ---------------------
> + *
> + * This communication path is used to deliver requests from frontend to backend
> + * and get the corresponding responses from backend to frontend,
> + * set up per virtual camera device.
> + *
> + * req-event-channel
> + *      Values:         <uint32_t>
> + *
> + *      The identifier of the Xen camera's control event channel
> + *      used to signal activity in the ring buffer.
> + *
> + * req-ring-ref
> + *      Values:         <uint32_t>
> + *
> + *      The Xen grant reference granting permission for the backend to map
> + *      a sole page of camera's control ring buffer.
> + *
> + *-------------------- Camera Event Transport Parameters ----------------------
> + *
> + * This communication path is used to deliver asynchronous events from backend
> + * to frontend, set up per virtual camera device.
> + *
> + * evt-event-channel
> + *      Values:         <uint32_t>
> + *
> + *      The identifier of the Xen camera's event channel
> + *      used to signal activity in the ring buffer.
> + *
> + * evt-ring-ref
> + *      Values:         <uint32_t>
> + *
> + *      The Xen grant reference granting permission for the backend to map
> + *      a sole page of camera's event ring buffer.
> + */
> +
> +/*
> + ******************************************************************************
> + *                               STATE DIAGRAMS
> + ******************************************************************************
> + *
> + * Tool stack creates front and back state nodes with initial state
> + * XenbusStateInitialising.
> + * Tool stack creates and sets up frontend camera configuration
> + * nodes per domain.
> + *
> + *-------------------------------- Normal flow --------------------------------
> + *
> + * Front                                Back
> + * =================================    =====================================
> + * XenbusStateInitialising              XenbusStateInitialising
> + *                                       o Query backend device identification
> + *                                         data.
> + *                                       o Open and validate backend device.
> + *                                                |
> + *                                                |
> + *                                                V
> + *                                      XenbusStateInitWait
> + *
> + * o Query frontend configuration
> + * o Allocate and initialize
> + *   event channels per configured
> + *   camera.
> + * o Publish transport parameters
> + *   that will be in effect during
> + *   this connection.
> + *              |
> + *              |
> + *              V
> + * XenbusStateInitialised
> + *
> + *                                       o Query frontend transport parameters.
> + *                                       o Connect to the event channels.
> + *                                                |
> + *                                                |
> + *                                                V
> + *                                      XenbusStateConnected
> + *
> + *  o Create and initialize OS
> + *    virtual camera as per
> + *    configuration.
> + *              |
> + *              |
> + *              V
> + * XenbusStateConnected
> + *
> + *                                      XenbusStateUnknown
> + *                                      XenbusStateClosed
> + *                                      XenbusStateClosing
> + * o Remove virtual camera device
> + * o Remove event channels
> + *              |
> + *              |
> + *              V
> + * XenbusStateClosed
> + *
> + *------------------------------- Recovery flow -------------------------------
> + *
> + * In case of frontend unrecoverable errors backend handles that as
> + * if frontend goes into the XenbusStateClosed state.
> + *
> + * In case of backend unrecoverable errors frontend tries removing
> + * the virtualized device. If this is possible at the moment of error,
> + * then frontend goes into the XenbusStateInitialising state and is ready for
> + * new connection with backend. If the virtualized device is still in use and
> + * cannot be removed, then frontend goes into the XenbusStateReconfiguring state
> + * until either the virtualized device is removed or backend initiates a new
> + * connection. On the virtualized device removal frontend goes into the
> + * XenbusStateInitialising state.
> + *
> + * Note on XenbusStateReconfiguring state of the frontend: if backend has
> + * unrecoverable errors then frontend cannot send requests to the backend
> + * and thus cannot provide functionality of the virtualized device anymore.
> + * After backend is back to normal the virtualized device may still hold some
> + * state: configuration in use, allocated buffers, client application state etc.
> + * In most cases, this will require frontend to implement complex recovery
> + * reconnect logic. Instead, by going into XenbusStateReconfiguring state,
> + * frontend will make sure no new clients of the virtualized device are
> + * accepted, allow existing client(s) to exit gracefully by signaling error
> + * state etc.
> + * Once all the clients are gone frontend can reinitialize the virtualized
> + * device and get into XenbusStateInitialising state again signaling the
> + * backend that a new connection can be made.
> + *
> + * There are multiple conditions possible under which frontend will go from
> + * XenbusStateReconfiguring into XenbusStateInitialising, some of them are OS
> + * specific. For example:
> + * 1. The underlying OS framework may provide callbacks to signal that the last
> + *    client of the virtualized device has gone and the device can be removed
> + * 2. Frontend can schedule a deferred work (timer/tasklet/workqueue)
> + *    to periodically check if this is the right time to re-try removal of
> + *    the virtualized device.
> + * 3. By any other means.
> + *
> + ******************************************************************************
> + *                             REQUEST CODES
> + ******************************************************************************
> + */
> +#define XENCAMERA_OP_CONFIG_SET        0x00
> +#define XENCAMERA_OP_CONFIG_GET        0x01
> +#define XENCAMERA_OP_BUF_REQUEST       0x02
> +#define XENCAMERA_OP_BUF_CREATE        0x03
> +#define XENCAMERA_OP_BUF_DESTROY       0x04
> +#define XENCAMERA_OP_BUF_QUEUE         0x05
> +#define XENCAMERA_OP_BUF_DEQUEUE       0x06
> +#define XENCAMERA_OP_CTRL_ENUM         0x07
> +#define XENCAMERA_OP_CTRL_SET          0x08
> +#define XENCAMERA_OP_CTRL_GET          0x09
> +#define XENCAMERA_OP_STREAM_START      0x0a
> +#define XENCAMERA_OP_STREAM_STOP       0x0b
> +
> +#define XENCAMERA_CTRL_BRIGHTNESS      0
> +#define XENCAMERA_CTRL_CONTRAST        1
> +#define XENCAMERA_CTRL_SATURATION      2
> +#define XENCAMERA_CTRL_HUE             3
> +
> +/* Number of supported controls. */
> +#define XENCAMERA_MAX_CTRL             4
> +
> +/* Control is read-only. */
> +#define XENCAMERA_CTRL_FLG_RO          (1 << 0)
> +/* Control is write-only. */
> +#define XENCAMERA_CTRL_FLG_WO          (1 << 1)
> +/* Control's value is volatile. */
> +#define XENCAMERA_CTRL_FLG_VOLATILE    (1 << 2)
> +
> +/* Supported color spaces. */
> +#define XENCAMERA_COLORSPACE_SMPTE170M 0
> +#define XENCAMERA_COLORSPACE_REC709    1
> +#define XENCAMERA_COLORSPACE_SRGB      2
> +#define XENCAMERA_COLORSPACE_ADOBERGB  3
> +#define XENCAMERA_COLORSPACE_BT2020    4
> +#define XENCAMERA_COLORSPACE_DCI_P3    5
> +#define XENCAMERA_COLORSPACE_RAW       6

I think you can drop COLORSPACE_RAW. It basically means that you get the
raw sensor data and the driver has no idea what standard they follow (if
any). It is expected that userspace knows this.

It makes no sense that this is exposed through xencamera: either the
backend has to transform the data to something that frontends can handle,
or it just replaces RAW with SRGB and hope for the best.

Regards,

	Hans
