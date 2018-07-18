Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f44.google.com ([209.85.208.44]:42619 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbeGRNiv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 09:38:51 -0400
Received: by mail-ed1-f44.google.com with SMTP id r4-v6so4164081edp.9
        for <linux-media@vger.kernel.org>; Wed, 18 Jul 2018 06:01:00 -0700 (PDT)
Subject: Re: Devices with a front and back webcam represented as a single UVC
 device
To: Carlos Garnacho <carlosg@gnome.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <8804dcb3-1aca-3679-6a96-bbe554f188d0@redhat.com>
 <5105002.ahX3nrg0vu@avalon>
 <CAEiaqW3i4OM5C3srSi8E_3MSOmMjkTq-nNGB=FqSVOHjdYL5NA@mail.gmail.com>
 <2208320.5nHJhHVTzE@avalon> <1a5ac0f3-9acd-1b8f-7354-b2147aa5636f@redhat.com>
 <CAEiaqW19WyYLQFV8MyRPB=FFy_GYYLXajK2yJ7m7nWBcfCS8TQ@mail.gmail.com>
 <b1a78ae4-8d12-5093-1e2e-bc646419e1be@redhat.com>
 <CAEiaqW14DKgq7ShSYXB=boHiza=xsM9wOQTF1Cu+k5MyHCACaA@mail.gmail.com>
 <3fa89302-51ba-ecfb-cdfd-72e075acf2f0@redhat.com>
 <CAEiaqW2QBjbwkKmARAs6eiC4rPMG=PKNPEi5wps3+C3aoDpQ7g@mail.gmail.com>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <45aabea2-63e7-8b96-171a-3bca3f1b532b@redhat.com>
Date: Wed, 18 Jul 2018 15:00:58 +0200
MIME-Version: 1.0
In-Reply-To: <CAEiaqW2QBjbwkKmARAs6eiC4rPMG=PKNPEi5wps3+C3aoDpQ7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 18-07-18 13:53, Carlos Garnacho wrote:
> Hey,
> 
> On Wed, Jul 11, 2018 at 9:51 PM, Hans de Goede <hdegoede@redhat.com> wrote:
>> Hi,
>>
>>
>> On 11-07-18 20:26, Carlos Garnacho wrote:
>>>
>>> Hi!,
>>>
>>> On Wed, Jul 11, 2018 at 7:41 PM, Hans de Goede <hdegoede@redhat.com>
>>> wrote:
>>>>
>>>> Hi,
>>>>
>>>>
>>>> On 11-07-18 18:07, Carlos Garnacho wrote:
>>>>>
>>>>>
>>>>> Hi!,
>>>>>
>>>>> On Wed, Jul 11, 2018 at 2:41 PM, Hans de Goede <hdegoede@redhat.com>
>>>>> wrote:
>>>>>>
>>>>>>
>>>>>> HI,
>>>>>>
>>>>>>
>>>>>> On 11-07-18 14:08, Laurent Pinchart wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Hi Carlos,
>>>>>>>
>>>>>>> On Wednesday, 11 July 2018 14:36:48 EEST Carlos Garnacho wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> On Wed, Jul 11, 2018 at 1:00 PM, Laurent Pinchart wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On Wednesday, 11 July 2018 11:37:14 EEST Hans de Goede wrote:
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Hi Laurent,
>>>>>>>>>>
>>>>>>>>>> At Guadec Carlos (in the Cc) told me that on his Acer 2-in-1 only
>>>>>>>>>> the frontcam is working and it seems both are represented by a
>>>>>>>>>> single UVC USB device. I've told him to check for some v4l control
>>>>>>>>>> to flip between front and back.
>>>>>>>>>>
>>>>>>>>>> Carlos, as I mentioned you can try gtk-v4l
>>>>>>>>>> ("sudo dnf install gtk-v4l") or qv4l2
>>>>>>>>>> ("sudo dnf install qv4l2") these will both show
>>>>>>>>>> you various controls for the camera. One of those might do the
>>>>>>>>>> trick.
>>>>>>>>>>
>>>>>>>>>> But I recently bought a 2nd second hand Cherry Trail based HP
>>>>>>>>>> X2 2-in-1 and much to my surprise that is actually using an UVC
>>>>>>>>>> cam, rather then the usual ATOMISP crap and it has the same issue.
>>>>>>>>>>
>>>>>>>>>> This device does not seem to have a control to flip between the
>>>>>>>>>> 2 cams, instead it registers 2 /dev/video? nodes but the second
>>>>>>>>>> node does not work
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> The second node is there to expose metadata to userspace, not image
>>>>>>>>> data.
>>>>>>>>> That's a recent addition to the uvcvideo driver.
>>>>>>>>>
>>>>>>>>>> and dmesg contains:
>>>>>>>>>>
>>>>>>>>>> [   26.079868] uvcvideo: Found UVC 1.00 device HP TrueVision HD
>>>>>>>>>> (05c8:03a3)
>>>>>>>>>> [   26.095485] uvcvideo 1-4.2:1.0: Entity type for entity Extension
>>>>>>>>>> 4
>>>>>>>>>> was
>>>>>>>>>> not initialized!
>>>>>>>>>> [   26.095492] uvcvideo 1-4.2:1.0: Entity type for entity
>>>>>>>>>> Processing
>>>>>>>>>> 2
>>>>>>>>>> was
>>>>>>>>>> not initialized!
>>>>>>>>>> [   26.095496] uvcvideo 1-4.2:1.0: Entity type for entity Camera 1
>>>>>>>>>> was
>>>>>>>>>> not
>>>>>>>>>> initialized!
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> You can safely ignore those messages. I need to submit a patch to
>>>>>>>>> get
>>>>>>>>> rid
>>>>>>>>> of them.
>>>>>>>>>
>>>>>>>>>> Laurent, I've attached lsusb -v output so that you can check the
>>>>>>>>>> descriptors.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Thank you.
>>>>>>>>>
>>>>>>>>> It's funny how UVC specifies a standard way to describe a device
>>>>>>>>> with
>>>>>>>>> two
>>>>>>>>> camera sensors with dynamic selection of one of them at runtime, and
>>>>>>>>> vendors instead implement vendor-specific crap :-(
>>>>>>>>>
>>>>>>>>> The interesting part in the descriptors is
>>>>>>>>>
>>>>>>>>>           VideoControl Interface Descriptor:
>>>>>>>>>             bLength                27
>>>>>>>>>             bDescriptorType        36
>>>>>>>>>             bDescriptorSubtype      6 (EXTENSION_UNIT)
>>>>>>>>>             bUnitID                 4
>>>>>>>>>             guidExtensionCode
>>>>>>>>> {1229a78c-47b4-4094-b0ce-db07386fb938}
>>>>>>>>>             bNumControl             2
>>>>>>>>>             bNrPins                 1
>>>>>>>>>             baSourceID( 0)          2
>>>>>>>>>             bControlSize            2
>>>>>>>>>             bmControls( 0)       0x00
>>>>>>>>>             bmControls( 1)       0x06
>>>>>>>>>             iExtension              0
>>>>>>>>>
>>>>>>>>> The extension unit exposes two controls (bmControls is a bitmask).
>>>>>>>>> They
>>>>>>>>> can be accessed from userspace through the UVCIOC_CTRL_QUERY ioctl,
>>>>>>>>> or
>>>>>>>>> mapped to V4L2 controls through the UVCIOC_CTRL_MAP ioctl, in which
>>>>>>>>> case
>>>>>>>>> they will be exposed to standard V4L2 applications.
>>>>>>>>>
>>>>>>>>> If you want to experiment with this, I would advise querying both
>>>>>>>>> controls
>>>>>>>>> with UVCIOC_CTRL_QUERY. You can use the UVC_GET_CUR, UVC_GET_MIN,
>>>>>>>>> UVC_GET_MAX, UVC_GET_DEF and UVC_GET_RES requests to get the control
>>>>>>>>> current, minimum, maximum, default and resolution values, and
>>>>>>>>> UVC_GET_LEN
>>>>>>>>> and UVC_GET_INFO to get the control size (in bytes) and flags. Based
>>>>>>>>> on
>>>>>>>>> that you can start experimenting with UVC_SET_CUR to set semi-random
>>>>>>>>> values.
>>>>>>>>>
>>>>>>>>> I'm however worried that those two controls would be a register
>>>>>>>>> address
>>>>>>>>> and a register value, for indirect access to all hardware registers
>>>>>>>>> in
>>>>>>>>> the device. In that case, you would likely need information from the
>>>>>>>>> device vendor, or possibly a USB traffic dump from a Windows machine
>>>>>>>>> when
>>>>>>>>> switching between the front and back cameras.
>>>>>>>>>
>>>>>>>>>> Carlos, it might be good to get Laurent your descriptors too, to do
>>>>>>>>>> this do "lsusb", note what is the <vid>:<pid> for your camera and
>>>>>>>>>> then
>>>>>>>>>> run:
>>>>>>>>>>
>>>>>>>>>> sudo lsusb -v -d <vid>:<pid>  > lsusb.log
>>>>>>>>>>
>>>>>>>>>> And send Laurent a mail with the generated lsusb
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> That would be appreciated, but I expect the same issue :-(
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> Please find it attached. IIUC your last email, it might not be the
>>>>>>>> exact same issue, but you can definitely judge better.
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Your device is similar in the sense that it doesn't use the standard
>>>>>>> UVC
>>>>>>> support for multiple camera sensors. It instead exposes two extension
>>>>>>> units:
>>>>>>>
>>>>>>>           VideoControl Interface Descriptor:
>>>>>>>             bLength                27
>>>>>>>             bDescriptorType        36
>>>>>>>             bDescriptorSubtype      6 (EXTENSION_UNIT)
>>>>>>>             bUnitID                 4
>>>>>>>             guidExtensionCode
>>>>>>> {1229a78c-47b4-4094-b0ce-db07386fb938}
>>>>>>>             bNumControl             2
>>>>>>>             bNrPins                 1
>>>>>>>             baSourceID( 0)          2
>>>>>>>             bControlSize            2
>>>>>>>             bmControls( 0)       0x00
>>>>>>>             bmControls( 1)       0x06
>>>>>>>             iExtension              0
>>>>>>>           VideoControl Interface Descriptor:
>>>>>>>             bLength                29
>>>>>>>             bDescriptorType        36
>>>>>>>             bDescriptorSubtype      6 (EXTENSION_UNIT)
>>>>>>>             bUnitID                 6
>>>>>>>             guidExtensionCode
>>>>>>> {26b8105a-0713-4870-979d-da79444bb68e}
>>>>>>>             bNumControl             9
>>>>>>>             bNrPins                 1
>>>>>>>             baSourceID( 0)          4
>>>>>>>             bControlSize            4
>>>>>>>             bmControls( 0)       0x1f
>>>>>>>             bmControls( 1)       0x01
>>>>>>>             bmControls( 2)       0x38
>>>>>>>             bmControls( 3)       0x00
>>>>>>>             iExtension              6 Realtek Extended Controls Unit
>>>>>>>
>>>>>>> The first one is identical to Hans', and I expect it to offer indirect
>>>>>>> access
>>>>>>> to internal device registers. The second one exposes 9 controls, and I
>>>>>>> expect
>>>>>>> at least some of those to have direct effects on the device. What they
>>>>>>> do
>>>>>>> and
>>>>>>> how they operate is unfortunately unknown.
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> Laurent, thank you for your input on this. I thought it was a bit weird
>>>>>> that
>>>>>> the cam on my HP X2 only had what appears to be the debug controls, so
>>>>>> I
>>>>>> opened it up and as I suspect (after your analysis) it is using a USB
>>>>>> module
>>>>>> for the front camera, but the back camera is a sensor directly hooked
>>>>>> with
>>>>>> its
>>>>>> CSI/MIPI bus to the PCB, so very likely it is using the ATOMISP stuff.
>>>>>>
>>>>>> So I think that we can consider this "solved" for my 2-in-1.
>>>>>>
>>>>>> Carlos, your Acer is using a Core CPU (not an Atom) right ? And the
>>>>>> front
>>>>>
>>>>>
>>>>>
>>>>> Indeed, it is an i5...
>>>>>
>>>>>> and
>>>>>> rear cams are both centered at the same edge I guess ?  (mine had one
>>>>>> in
>>>>>> the
>>>>>> corner and the other centered which already was a hint)
>>>>>
>>>>>
>>>>>
>>>>> ...but now that you mention this, I have front camera centered and
>>>>> rear camera on a corner too. Is there any other info I may need to
>>>>> fetch? I assume ATOMISP is irrelevant here.
>>>>
>>>>
>>>>
>>>> Skylake and kabylake also have an ATOMISP like device. What is the
>>>> output of lspci ?  And what is your CPU model number? (cat /proc/cpuinfo)
>>>
>>>
>>> Oh I see, this is Skylake indeed, so I guess the issue is similar.
>>
>>
>> I think that your CPU does have integrated camera support, but that does
>> not necessarily mean it is used. If it is used it should show up in
>> lspci.
>>
>> Can you provide lspci output ?   And is there any output for:
> 
> Sorry for the late reply. lspci -vvv output is attached.
> 
>>
>> lsmod | grep ipu3
> 
> There indeed is:
> 
> $ lsmod |grep ipu3
> ipu3_cio2              36864  0
> v4l2_fwnode            20480  1 ipu3_cio2
> videobuf2_dma_sg       16384  1 ipu3_cio2
> videobuf2_v4l2         28672  2 uvcvideo,ipu3_cio2
> videobuf2_common       53248  3 uvcvideo,ipu3_cio2,videobuf2_v4l2
> videodev              208896  5
> v4l2_fwnode,uvcvideo,videobuf2_common,ipu3_cio2,videobuf2_v4l2
> media                  45056  3 uvcvideo,videodev,ipu3_cio2
> 
> In lspci output I seem to see "Device 9d32" used by ipu3_cio2, you
> probably mean that one?

Yes, so that means that your device also uses one UVC camera
+ one connected directly to the SoC.

The ipu3_cio2 support is in slightly better state then the
ATOMISP support, but still it will not work out of the box.

Regards,

Hans
