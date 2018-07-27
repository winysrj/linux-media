Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:34890 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729539AbeG0MTq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 08:19:46 -0400
Received: by mail-it0-f49.google.com with SMTP id q20-v6so6822902ith.0
        for <linux-media@vger.kernel.org>; Fri, 27 Jul 2018 03:58:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180625101024.2573892a@coco.lan>
References: <20180620203838.GA13372@amd> <b7707ec241d9d2d2966bdc32f7bb9bc55ac55c5d.camel@ndufresne.ca>
 <20180620211144.GA16945@amd> <da642773adac42a6966b9716f0d53444@ausx13mpc120.AMER.DELL.COM>
 <20180622034946.2ae51f1e@vela.lan> <db8d91a47971417da424df7bf67a5cca@ausx13mpc120.AMER.DELL.COM>
 <20180622060850.3941d9a7@vela.lan> <20180622064032.550f24cb@vela.lan>
 <FA6CF6692DF0B343ABE491A46A2CD0E76C6E491B@SHSMSX101.ccr.corp.intel.com> <20180625101024.2573892a@coco.lan>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Fri, 27 Jul 2018 12:58:21 +0200
Message-ID: <CABxcv=m7FL-H5QbJGTL1To03_fvvThLWUZ6_JHa0maezB2VhYQ@mail.gmail.com>
Subject: Re: Software-only image processing for Intel "complex" cameras
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mario.Limonciello@dell.com" <Mario.Limonciello@dell.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "nicolas@ndufresne.ca" <nicolas@ndufresne.ca>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "niklas.soderlund@ragnatech.se" <niklas.soderlund@ragnatech.se>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Jun 25, 2018 at 3:10 PM, Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
> Em Mon, 25 Jun 2018 09:48:56 +0000
> "Zheng, Jian Xu" <jian.xu.zheng@intel.com> escreveu:
>
>> Hi Mauro,
>>
>> > -----Original Message-----
>> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> > owner@vger.kernel.org] On Behalf Of Mauro Carvalho Chehab
>> > Sent: Friday, June 22, 2018 5:41 AM
>> > To: Mario.Limonciello@dell.com
>> > Cc: pavel@ucw.cz; nicolas@ndufresne.ca; linux-media@vger.kernel.org;
>> > sakari.ailus@linux.intel.com; niklas.soderlund@ragnatech.se; Hu, Jerry W
>> > <jerry.w.hu@intel.com>; Zheng, Jian Xu <jian.xu.zheng@intel.com>
>> > Subject: Re: Software-only image processing for Intel "complex" cameras
>> >
>> > Em Fri, 22 Jun 2018 06:08:50 +0900
>> > Mauro Carvalho Chehab <mchehab+samsung@kernel.org> escreveu:
>> >
>> > > Em Thu, 21 Jun 2018 18:58:37 +0000
>> > > <Mario.Limonciello@dell.com> escreveu:
>> > >
>> > Jerry/Jian,
>> >
>> > Could you please shed a light about how a Dell 5285 hardware would be
>> > detected by the IPU3 driver and what MC graph is created by the current
>> > driver?
>>
>> Sure, Mauro. I need to check the information on the Dell 5285.
>> IPU3 driver are detected by PCI vendor id and device id.
>>
>> IPU3 CIO2 MC graph is:
>> Sensor A -> IPU3 CSI2 0(subdev) -> IPU3 CIO2 0 (video node)
>> Sensor B -> IPU3 CSI2 1(subdev) -> IPU3 CIO2 1 (video node)
>

I don't think your questions below were answered. I'll try to answer
since I've been looking at this, but Sakari or others can correct me
if I got something wrong.

> How does it detect what driver should be loaded for Sensor A and B?
>

It depends on the firmware interface used to describe the hardware
topology, for ACPI the sensors are described in a DSDT table and match
using an entry in the struct acpi_device_id table in the camera
driver. For DT the sensors are described in a DT node with a
compatible string that matches an entry in the struct of_device_id
table, or an entry in the struct i2c_device_id table as a fallback.

> Does the ACPI table identifies the sensors? If so, how the driver
> associates an specific PCI vendor ID with the corresponding sensor
> settings?
>

Camera sensors are usually not PCI devices, but I2C devices. And yes,
these are described in an ACPI table (DSDT) as mentioned before. For
example in a laptop I've the following on an disassembled DSDT table:

        Device (CAM0)
        {
            Name (_ADR, Zero)  // _ADR: Address
            Name (_HID, "OVTI5648")  // _HID: Hardware ID
            Name (_CID, "OVTI5648")  // _CID: Compatible ID
            Name (_DDN, "OV5648-CRDD")  // _DDN: DOS Device Name
            Name (_UID, Zero)  // _UID: Unique ID
            Name (_DEP, Package (0x02)  // _DEP: Dependencies
            {
                PMI0,
                I2C4
            })

Now how the drivers get loaded / registered and how the media entities
are associated is somewhat orthogonal (although the information to do
both is usually encoded in the same place).

In the case of OF, the relation between the bridge device and the
sensors is encoded in the DT using the video interface / graph binding
[0, 1]. For ACPI, the same information is encoded in an ACPI table
using a _DSD extension [2], which is quite similar to the DT binding.

Since both hardware descriptions use the same properties (port,
endpoint, etc) and semantics, drivers can use the V4L2 fwnode kAPI to
parse this information regardless of the underlying firmware interface
used to encoded this relationship. This allows the same camera drivers
to be used with either DT or ACPI.

So a bridge driver will register a v4l2 async notifier on probe and
camera drivers will register the subdevices using the v4l2 async
interface. That way the v4l2 async layer can bind the two and call the
bridge device .bound (each time that a pending device is registered)
and .complete (when there are no pending devices remaining to be
registered) callbacks.

A problem I found though is that [2] is Linux specific, so the
firmware for a machine meant to be used with Windows (i.e: Microsoft
Surface 2-in-1 computers) will have a DSDT table that's not compatible
with the v4l2 fwnode layer. One option is to override [4] the DSDT
table with one that contains the information expected by Linux, for
example by having the table in the initramfs [5]. The problem is that
it seems the distros (at least in the Fedora case) don't want to get
into the business of shipping machine specific ACPI tables.

Another option could be to have a shim layer in the kernel that
translates the information in the DSDT as used by Windows to what's
expected by Linux. This is an option that I haven't investigated yet,
but wanted to know your opinion if this could be a feasible approach.
Or if you have any other suggestions on how we should proceed with
this.

[0]: https://www.kernel.org/doc/Documentation/devicetree/bindings/media/video-interfaces.txt
[1]: https://www.kernel.org/doc/Documentation/devicetree/bindings/graph.txt
[2]: https://www.kernel.org/doc/Documentation/acpi/dsd/graph.txt
[3]: https://linuxtv.org/downloads/v4l-dvb-apis/kapi/v4l2-fwnode.html
[4]: https://www.kernel.org/doc/Documentation/acpi/dsdt-override.txt
[5]: https://www.kernel.org/doc/Documentation/acpi/initrd_table_override.txt

Best regards,
Javier
