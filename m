Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:38640 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbeGRMbd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 08:31:33 -0400
Received: by mail-ua0-f177.google.com with SMTP id o11-v6so2732465uak.5
        for <linux-media@vger.kernel.org>; Wed, 18 Jul 2018 04:53:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3fa89302-51ba-ecfb-cdfd-72e075acf2f0@redhat.com>
References: <8804dcb3-1aca-3679-6a96-bbe554f188d0@redhat.com>
 <5105002.ahX3nrg0vu@avalon> <CAEiaqW3i4OM5C3srSi8E_3MSOmMjkTq-nNGB=FqSVOHjdYL5NA@mail.gmail.com>
 <2208320.5nHJhHVTzE@avalon> <1a5ac0f3-9acd-1b8f-7354-b2147aa5636f@redhat.com>
 <CAEiaqW19WyYLQFV8MyRPB=FFy_GYYLXajK2yJ7m7nWBcfCS8TQ@mail.gmail.com>
 <b1a78ae4-8d12-5093-1e2e-bc646419e1be@redhat.com> <CAEiaqW14DKgq7ShSYXB=boHiza=xsM9wOQTF1Cu+k5MyHCACaA@mail.gmail.com>
 <3fa89302-51ba-ecfb-cdfd-72e075acf2f0@redhat.com>
From: Carlos Garnacho <carlosg@gnome.org>
Date: Wed, 18 Jul 2018 13:53:56 +0200
Message-ID: <CAEiaqW2QBjbwkKmARAs6eiC4rPMG=PKNPEi5wps3+C3aoDpQ7g@mail.gmail.com>
Subject: Re: Devices with a front and back webcam represented as a single UVC device
To: Hans de Goede <hdegoede@redhat.com>
Cc: Carlos Garnacho <carlosg@gnome.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000b38bf6057144b701"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--000000000000b38bf6057144b701
Content-Type: text/plain; charset="UTF-8"

Hey,

On Wed, Jul 11, 2018 at 9:51 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
>
> On 11-07-18 20:26, Carlos Garnacho wrote:
>>
>> Hi!,
>>
>> On Wed, Jul 11, 2018 at 7:41 PM, Hans de Goede <hdegoede@redhat.com>
>> wrote:
>>>
>>> Hi,
>>>
>>>
>>> On 11-07-18 18:07, Carlos Garnacho wrote:
>>>>
>>>>
>>>> Hi!,
>>>>
>>>> On Wed, Jul 11, 2018 at 2:41 PM, Hans de Goede <hdegoede@redhat.com>
>>>> wrote:
>>>>>
>>>>>
>>>>> HI,
>>>>>
>>>>>
>>>>> On 11-07-18 14:08, Laurent Pinchart wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> Hi Carlos,
>>>>>>
>>>>>> On Wednesday, 11 July 2018 14:36:48 EEST Carlos Garnacho wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On Wed, Jul 11, 2018 at 1:00 PM, Laurent Pinchart wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> On Wednesday, 11 July 2018 11:37:14 EEST Hans de Goede wrote:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Hi Laurent,
>>>>>>>>>
>>>>>>>>> At Guadec Carlos (in the Cc) told me that on his Acer 2-in-1 only
>>>>>>>>> the frontcam is working and it seems both are represented by a
>>>>>>>>> single UVC USB device. I've told him to check for some v4l control
>>>>>>>>> to flip between front and back.
>>>>>>>>>
>>>>>>>>> Carlos, as I mentioned you can try gtk-v4l
>>>>>>>>> ("sudo dnf install gtk-v4l") or qv4l2
>>>>>>>>> ("sudo dnf install qv4l2") these will both show
>>>>>>>>> you various controls for the camera. One of those might do the
>>>>>>>>> trick.
>>>>>>>>>
>>>>>>>>> But I recently bought a 2nd second hand Cherry Trail based HP
>>>>>>>>> X2 2-in-1 and much to my surprise that is actually using an UVC
>>>>>>>>> cam, rather then the usual ATOMISP crap and it has the same issue.
>>>>>>>>>
>>>>>>>>> This device does not seem to have a control to flip between the
>>>>>>>>> 2 cams, instead it registers 2 /dev/video? nodes but the second
>>>>>>>>> node does not work
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> The second node is there to expose metadata to userspace, not image
>>>>>>>> data.
>>>>>>>> That's a recent addition to the uvcvideo driver.
>>>>>>>>
>>>>>>>>> and dmesg contains:
>>>>>>>>>
>>>>>>>>> [   26.079868] uvcvideo: Found UVC 1.00 device HP TrueVision HD
>>>>>>>>> (05c8:03a3)
>>>>>>>>> [   26.095485] uvcvideo 1-4.2:1.0: Entity type for entity Extension
>>>>>>>>> 4
>>>>>>>>> was
>>>>>>>>> not initialized!
>>>>>>>>> [   26.095492] uvcvideo 1-4.2:1.0: Entity type for entity
>>>>>>>>> Processing
>>>>>>>>> 2
>>>>>>>>> was
>>>>>>>>> not initialized!
>>>>>>>>> [   26.095496] uvcvideo 1-4.2:1.0: Entity type for entity Camera 1
>>>>>>>>> was
>>>>>>>>> not
>>>>>>>>> initialized!
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> You can safely ignore those messages. I need to submit a patch to
>>>>>>>> get
>>>>>>>> rid
>>>>>>>> of them.
>>>>>>>>
>>>>>>>>> Laurent, I've attached lsusb -v output so that you can check the
>>>>>>>>> descriptors.
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> Thank you.
>>>>>>>>
>>>>>>>> It's funny how UVC specifies a standard way to describe a device
>>>>>>>> with
>>>>>>>> two
>>>>>>>> camera sensors with dynamic selection of one of them at runtime, and
>>>>>>>> vendors instead implement vendor-specific crap :-(
>>>>>>>>
>>>>>>>> The interesting part in the descriptors is
>>>>>>>>
>>>>>>>>          VideoControl Interface Descriptor:
>>>>>>>>            bLength                27
>>>>>>>>            bDescriptorType        36
>>>>>>>>            bDescriptorSubtype      6 (EXTENSION_UNIT)
>>>>>>>>            bUnitID                 4
>>>>>>>>            guidExtensionCode
>>>>>>>> {1229a78c-47b4-4094-b0ce-db07386fb938}
>>>>>>>>            bNumControl             2
>>>>>>>>            bNrPins                 1
>>>>>>>>            baSourceID( 0)          2
>>>>>>>>            bControlSize            2
>>>>>>>>            bmControls( 0)       0x00
>>>>>>>>            bmControls( 1)       0x06
>>>>>>>>            iExtension              0
>>>>>>>>
>>>>>>>> The extension unit exposes two controls (bmControls is a bitmask).
>>>>>>>> They
>>>>>>>> can be accessed from userspace through the UVCIOC_CTRL_QUERY ioctl,
>>>>>>>> or
>>>>>>>> mapped to V4L2 controls through the UVCIOC_CTRL_MAP ioctl, in which
>>>>>>>> case
>>>>>>>> they will be exposed to standard V4L2 applications.
>>>>>>>>
>>>>>>>> If you want to experiment with this, I would advise querying both
>>>>>>>> controls
>>>>>>>> with UVCIOC_CTRL_QUERY. You can use the UVC_GET_CUR, UVC_GET_MIN,
>>>>>>>> UVC_GET_MAX, UVC_GET_DEF and UVC_GET_RES requests to get the control
>>>>>>>> current, minimum, maximum, default and resolution values, and
>>>>>>>> UVC_GET_LEN
>>>>>>>> and UVC_GET_INFO to get the control size (in bytes) and flags. Based
>>>>>>>> on
>>>>>>>> that you can start experimenting with UVC_SET_CUR to set semi-random
>>>>>>>> values.
>>>>>>>>
>>>>>>>> I'm however worried that those two controls would be a register
>>>>>>>> address
>>>>>>>> and a register value, for indirect access to all hardware registers
>>>>>>>> in
>>>>>>>> the device. In that case, you would likely need information from the
>>>>>>>> device vendor, or possibly a USB traffic dump from a Windows machine
>>>>>>>> when
>>>>>>>> switching between the front and back cameras.
>>>>>>>>
>>>>>>>>> Carlos, it might be good to get Laurent your descriptors too, to do
>>>>>>>>> this do "lsusb", note what is the <vid>:<pid> for your camera and
>>>>>>>>> then
>>>>>>>>> run:
>>>>>>>>>
>>>>>>>>> sudo lsusb -v -d <vid>:<pid>  > lsusb.log
>>>>>>>>>
>>>>>>>>> And send Laurent a mail with the generated lsusb
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> That would be appreciated, but I expect the same issue :-(
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Please find it attached. IIUC your last email, it might not be the
>>>>>>> exact same issue, but you can definitely judge better.
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> Your device is similar in the sense that it doesn't use the standard
>>>>>> UVC
>>>>>> support for multiple camera sensors. It instead exposes two extension
>>>>>> units:
>>>>>>
>>>>>>          VideoControl Interface Descriptor:
>>>>>>            bLength                27
>>>>>>            bDescriptorType        36
>>>>>>            bDescriptorSubtype      6 (EXTENSION_UNIT)
>>>>>>            bUnitID                 4
>>>>>>            guidExtensionCode
>>>>>> {1229a78c-47b4-4094-b0ce-db07386fb938}
>>>>>>            bNumControl             2
>>>>>>            bNrPins                 1
>>>>>>            baSourceID( 0)          2
>>>>>>            bControlSize            2
>>>>>>            bmControls( 0)       0x00
>>>>>>            bmControls( 1)       0x06
>>>>>>            iExtension              0
>>>>>>          VideoControl Interface Descriptor:
>>>>>>            bLength                29
>>>>>>            bDescriptorType        36
>>>>>>            bDescriptorSubtype      6 (EXTENSION_UNIT)
>>>>>>            bUnitID                 6
>>>>>>            guidExtensionCode
>>>>>> {26b8105a-0713-4870-979d-da79444bb68e}
>>>>>>            bNumControl             9
>>>>>>            bNrPins                 1
>>>>>>            baSourceID( 0)          4
>>>>>>            bControlSize            4
>>>>>>            bmControls( 0)       0x1f
>>>>>>            bmControls( 1)       0x01
>>>>>>            bmControls( 2)       0x38
>>>>>>            bmControls( 3)       0x00
>>>>>>            iExtension              6 Realtek Extended Controls Unit
>>>>>>
>>>>>> The first one is identical to Hans', and I expect it to offer indirect
>>>>>> access
>>>>>> to internal device registers. The second one exposes 9 controls, and I
>>>>>> expect
>>>>>> at least some of those to have direct effects on the device. What they
>>>>>> do
>>>>>> and
>>>>>> how they operate is unfortunately unknown.
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> Laurent, thank you for your input on this. I thought it was a bit weird
>>>>> that
>>>>> the cam on my HP X2 only had what appears to be the debug controls, so
>>>>> I
>>>>> opened it up and as I suspect (after your analysis) it is using a USB
>>>>> module
>>>>> for the front camera, but the back camera is a sensor directly hooked
>>>>> with
>>>>> its
>>>>> CSI/MIPI bus to the PCB, so very likely it is using the ATOMISP stuff.
>>>>>
>>>>> So I think that we can consider this "solved" for my 2-in-1.
>>>>>
>>>>> Carlos, your Acer is using a Core CPU (not an Atom) right ? And the
>>>>> front
>>>>
>>>>
>>>>
>>>> Indeed, it is an i5...
>>>>
>>>>> and
>>>>> rear cams are both centered at the same edge I guess ?  (mine had one
>>>>> in
>>>>> the
>>>>> corner and the other centered which already was a hint)
>>>>
>>>>
>>>>
>>>> ...but now that you mention this, I have front camera centered and
>>>> rear camera on a corner too. Is there any other info I may need to
>>>> fetch? I assume ATOMISP is irrelevant here.
>>>
>>>
>>>
>>> Skylake and kabylake also have an ATOMISP like device. What is the
>>> output of lspci ?  And what is your CPU model number? (cat /proc/cpuinfo)
>>
>>
>> Oh I see, this is Skylake indeed, so I guess the issue is similar.
>
>
> I think that your CPU does have integrated camera support, but that does
> not necessarily mean it is used. If it is used it should show up in
> lspci.
>
> Can you provide lspci output ?   And is there any output for:

Sorry for the late reply. lspci -vvv output is attached.

>
> lsmod | grep ipu3

There indeed is:

$ lsmod |grep ipu3
ipu3_cio2              36864  0
v4l2_fwnode            20480  1 ipu3_cio2
videobuf2_dma_sg       16384  1 ipu3_cio2
videobuf2_v4l2         28672  2 uvcvideo,ipu3_cio2
videobuf2_common       53248  3 uvcvideo,ipu3_cio2,videobuf2_v4l2
videodev              208896  5
v4l2_fwnode,uvcvideo,videobuf2_common,ipu3_cio2,videobuf2_v4l2
media                  45056  3 uvcvideo,videodev,ipu3_cio2

In lspci output I seem to see "Device 9d32" used by ipu3_cio2, you
probably mean that one?

Thanks,
  Carlos

--000000000000b38bf6057144b701
Content-Type: text/x-log; charset="US-ASCII"; name="lspci.log"
Content-Disposition: attachment; filename="lspci.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jjr2b0zy0

MDA6MDAuMCBIb3N0IGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gWGVvbiBFMy0xMjAwIHY1L0Uz
LTE1MDAgdjUvNnRoIEdlbiBDb3JlIFByb2Nlc3NvciBIb3N0IEJyaWRnZS9EUkFNIFJlZ2lzdGVy
cyAocmV2IDA4KQoJU3Vic3lzdGVtOiBBY2VyIEluY29ycG9yYXRlZCBbQUxJXSBEZXZpY2UgMTEx
ZQoJQ29udHJvbDogSS9PLSBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FT
bm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czog
Q2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCKyBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxU
QWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAKCUNhcGFiaWxp
dGllczogW2UwXSBWZW5kb3IgU3BlY2lmaWMgSW5mb3JtYXRpb246IExlbj0xMCA8Pz4KCUtlcm5l
bCBkcml2ZXIgaW4gdXNlOiBza2xfdW5jb3JlCgowMDowMi4wIFZHQSBjb21wYXRpYmxlIGNvbnRy
b2xsZXI6IEludGVsIENvcnBvcmF0aW9uIFNreWxha2UgR1QyIFtIRCBHcmFwaGljcyA1MjBdIChy
ZXYgMDcpIChwcm9nLWlmIDAwIFtWR0EgY29udHJvbGxlcl0pCglTdWJzeXN0ZW06IEFjZXIgSW5j
b3Jwb3JhdGVkIFtBTEldIERldmljZSAxMTFlCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVy
KyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBG
YXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVy
ci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJ
TlR4LQoJTGF0ZW5jeTogMCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRlcwoJSW50ZXJydXB0OiBw
aW4gQSByb3V0ZWQgdG8gSVJRIDEyNQoJUmVnaW9uIDA6IE1lbW9yeSBhdCBiMDAwMDAwMCAoNjQt
Yml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0xNk1dCglSZWdpb24gMjogTWVtb3J5IGF0IGEw
MDAwMDAwICg2NC1iaXQsIHByZWZldGNoYWJsZSkgW3NpemU9MjU2TV0KCVJlZ2lvbiA0OiBJL08g
cG9ydHMgYXQgMzAwMCBbc2l6ZT02NF0KCVt2aXJ0dWFsXSBFeHBhbnNpb24gUk9NIGF0IDAwMGMw
MDAwIFtkaXNhYmxlZF0gW3NpemU9MTI4S10KCUNhcGFiaWxpdGllczogWzQwXSBWZW5kb3IgU3Bl
Y2lmaWMgSW5mb3JtYXRpb246IExlbj0wYyA8Pz4KCUNhcGFiaWxpdGllczogWzcwXSBFeHByZXNz
ICh2MikgUm9vdCBDb21wbGV4IEludGVncmF0ZWQgRW5kcG9pbnQsIE1TSSAwMAoJCURldkNhcDoJ
TWF4UGF5bG9hZCAxMjggYnl0ZXMsIFBoYW50RnVuYyAwCgkJCUV4dFRhZy0gUkJFKwoJCURldkN0
bDoJUmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUtIE5vbi1GYXRhbC0gRmF0YWwtIFVuc3VwcG9y
dGVkLQoJCQlSbHhkT3JkLSBFeHRUYWctIFBoYW50RnVuYy0gQXV4UHdyLSBOb1Nub29wLQoJCQlN
YXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSAxMjggYnl0ZXMKCQlEZXZTdGE6CUNvcnJF
cnItIFVuY29yckVyci0gRmF0YWxFcnItIFVuc3VwcFJlcS0gQXV4UHdyLSBUcmFuc1BlbmQtCgkJ
RGV2Q2FwMjogQ29tcGxldGlvbiBUaW1lb3V0OiBOb3QgU3VwcG9ydGVkLCBUaW1lb3V0RGlzLSwg
TFRSLSwgT0JGRiBOb3QgU3VwcG9ydGVkCgkJCSBBdG9taWNPcHNDYXA6IDMyYml0LSA2NGJpdC0g
MTI4Yml0Q0FTLQoJCURldkN0bDI6IENvbXBsZXRpb24gVGltZW91dDogNTB1cyB0byA1MG1zLCBU
aW1lb3V0RGlzLSwgTFRSLSwgT0JGRiBEaXNhYmxlZAoJCQkgQXRvbWljT3BzQ3RsOiBSZXFFbi0K
CUNhcGFiaWxpdGllczogW2FjXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJp
dC0KCQlBZGRyZXNzOiBmZWUwMDAxOCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbZDBdIFBv
d2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAyCgkJRmxhZ3M6IFBNRUNsay0gRFNJKyBEMS0gRDItIEF1
eEN1cnJlbnQ9MG1BIFBNRShEMC0sRDEtLEQyLSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQw
IE5vU29mdFJzdC0gUE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGll
czogWzEwMCB2MV0gUHJvY2VzcyBBZGRyZXNzIFNwYWNlIElEIChQQVNJRCkKCQlQQVNJRENhcDog
RXhlYysgUHJpdi0sIE1heCBQQVNJRCBXaWR0aDogMTQKCQlQQVNJREN0bDogRW5hYmxlLSBFeGVj
LSBQcml2LQoJQ2FwYWJpbGl0aWVzOiBbMjAwIHYxXSBBZGRyZXNzIFRyYW5zbGF0aW9uIFNlcnZp
Y2UgKEFUUykKCQlBVFNDYXA6CUludmFsaWRhdGUgUXVldWUgRGVwdGg6IDAwCgkJQVRTQ3RsOglF
bmFibGUtLCBTbWFsbGVzdCBUcmFuc2xhdGlvbiBVbml0OiAwMAoJQ2FwYWJpbGl0aWVzOiBbMzAw
IHYxXSBQYWdlIFJlcXVlc3QgSW50ZXJmYWNlIChQUkkpCgkJUFJJQ3RsOiBFbmFibGUtIFJlc2V0
LQoJCVBSSVN0YTogUkYtIFVQUkdJLSBTdG9wcGVkLQoJCVBhZ2UgUmVxdWVzdCBDYXBhY2l0eTog
MDAwMDgwMDAsIFBhZ2UgUmVxdWVzdCBBbGxvY2F0aW9uOiAwMDAwMDAwMAoJS2VybmVsIGRyaXZl
ciBpbiB1c2U6IGk5MTUKCUtlcm5lbCBtb2R1bGVzOiBpOTE1CgowMDowNC4wIFNpZ25hbCBwcm9j
ZXNzaW5nIGNvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIFhlb24gRTMtMTIwMCB2NS9FMy0x
NTAwIHY1LzZ0aCBHZW4gQ29yZSBQcm9jZXNzb3IgVGhlcm1hbCBTdWJzeXN0ZW0gKHJldiAwOCkK
CVN1YnN5c3RlbTogQWNlciBJbmNvcnBvcmF0ZWQgW0FMSV0gRGV2aWNlIDExMWUKCUNvbnRyb2w6
IEkvTy0gTWVtKyBCdXNNYXN0ZXItIFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVy
ci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHot
IFVERi0gRmFzdEIyQisgUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFi
b3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEg
MTYKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgYjE2MzAwMDAgKDY0LWJpdCwgbm9uLXByZWZldGNoYWJs
ZSkgW3NpemU9MzJLXQoJQ2FwYWJpbGl0aWVzOiBbOTBdIE1TSTogRW5hYmxlLSBDb3VudD0xLzEg
TWFza2FibGUtIDY0Yml0LQoJCUFkZHJlc3M6IDAwMDAwMDAwICBEYXRhOiAwMDAwCglDYXBhYmls
aXRpZXM6IFtkMF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDMKCQlGbGFnczogUE1FQ2xrLSBE
U0ktIEQxLSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwLSxEMS0sRDItLEQzaG90LSxEM2NvbGQt
KQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0KyBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1F
LQoJQ2FwYWJpbGl0aWVzOiBbZTBdIFZlbmRvciBTcGVjaWZpYyBJbmZvcm1hdGlvbjogTGVuPTBj
IDw/PgoJS2VybmVsIGRyaXZlciBpbiB1c2U6IHByb2NfdGhlcm1hbAoJS2VybmVsIG1vZHVsZXM6
IHByb2Nlc3Nvcl90aGVybWFsX2RldmljZQoKMDA6MDUuMCBNdWx0aW1lZGlhIGNvbnRyb2xsZXI6
IEludGVsIENvcnBvcmF0aW9uIFhlb24gRTMtMTIwMCB2NS9FMy0xNTAwIHY1LzZ0aCBHZW4gQ29y
ZSBQcm9jZXNzb3IgSW1hZ2luZyBVbml0IChyZXYgMDEpCglTdWJzeXN0ZW06IEFjZXIgSW5jb3Jw
b3JhdGVkIFtBTEldIERldmljZSAxMTFlCglDb250cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyKyBT
cGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0
QjJCLSBEaXNJTlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0g
REVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4
LQoJTGF0ZW5jeTogMAoJSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDI1NQoJUmVnaW9u
IDA6IE1lbW9yeSBhdCBiMTAwMDAwMCAoNjQtYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT00
TV0KCUNhcGFiaWxpdGllczogWzkwXSBNU0k6IEVuYWJsZS0gQ291bnQ9MS8xIE1hc2thYmxlLSA2
NGJpdCsKCQlBZGRyZXNzOiAwMDAwMDAwMDAwMDAwMDAwICBEYXRhOiAwMDAwCglDYXBhYmlsaXRp
ZXM6IFthMF0gUENJIEFkdmFuY2VkIEZlYXR1cmVzCgkJQUZDYXA6IFRQKyBGTFIrCgkJQUZDdHJs
OiBGTFItCgkJQUZTdGF0dXM6IFRQLQoJQ2FwYWJpbGl0aWVzOiBbZDBdIFBvd2VyIE1hbmFnZW1l
bnQgdmVyc2lvbiAzCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1B
IFBNRShEMC0sRDEtLEQyLSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQwIE5vU29mdFJzdC0g
UE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCjAwOjEzLjAgTm9uLVZHQSB1bmNsYXNz
aWZpZWQgZGV2aWNlOiBJbnRlbCBDb3Jwb3JhdGlvbiBTdW5yaXNlIFBvaW50LUxQIEludGVncmF0
ZWQgU2Vuc29yIEh1YiAocmV2IDIxKQoJU3Vic3lzdGVtOiBBY2VyIEluY29ycG9yYXRlZCBbQUxJ
XSBEZXZpY2UgMTExZQoJQ29udHJvbDogSS9PLSBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBN
ZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5U
eC0KCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0
ID5UQWJvcnQtIDxUQWJvcnQtIDxNQWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6
IDAsIENhY2hlIExpbmUgU2l6ZTogNjQgYnl0ZXMKCUludGVycnVwdDogcGluIEEgcm91dGVkIHRv
IElSUSAyMAoJUmVnaW9uIDA6IE1lbW9yeSBhdCBiMTY0MjAwMCAoNjQtYml0LCBub24tcHJlZmV0
Y2hhYmxlKSBbc2l6ZT00S10KCUNhcGFiaWxpdGllczogWzgwXSBQb3dlciBNYW5hZ2VtZW50IHZl
cnNpb24gMwoJCUZsYWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUo
RDAtLEQxLSxEMi0sRDNob3QtLEQzY29sZC0pCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QrIFBNRS1F
bmFibGUtIERTZWw9MCBEU2NhbGU9MCBQTUUtCglLZXJuZWwgZHJpdmVyIGluIHVzZTogaW50ZWxf
aXNoX2lwYwoJS2VybmVsIG1vZHVsZXM6IGludGVsX2lzaF9pcGMKCjAwOjE0LjAgVVNCIGNvbnRy
b2xsZXI6IEludGVsIENvcnBvcmF0aW9uIFN1bnJpc2UgUG9pbnQtTFAgVVNCIDMuMCB4SENJIENv
bnRyb2xsZXIgKHJldiAyMSkgKHByb2ctaWYgMzAgW1hIQ0ldKQoJU3Vic3lzdGVtOiBBY2VyIElu
Y29ycG9yYXRlZCBbQUxJXSBEZXZpY2UgMTExZQoJQ29udHJvbDogSS9PLSBNZW0rIEJ1c01hc3Rl
cisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0g
RmFzdEIyQi0gRGlzSU5UeCsKCVN0YXR1czogQ2FwKyA2Nk1Iei0gVURGLSBGYXN0QjJCKyBQYXJF
cnItIERFVlNFTD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJS
LSBJTlR4LQoJTGF0ZW5jeTogMAoJSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDEyNAoJ
UmVnaW9uIDA6IE1lbW9yeSBhdCBiMTYwMDAwMCAoNjQtYml0LCBub24tcHJlZmV0Y2hhYmxlKSBb
c2l6ZT02NEtdCglDYXBhYmlsaXRpZXM6IFs3MF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDIK
CQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0zNzVtQSBQTUUoRDAtLEQx
LSxEMi0sRDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QrIFBNRS1FbmFibGUt
IERTZWw9MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFs4MF0gTVNJOiBFbmFibGUrIENv
dW50PTEvOCBNYXNrYWJsZS0gNjRiaXQrCgkJQWRkcmVzczogMDAwMDAwMDBmZWUwMDI3OCAgRGF0
YTogMDAwMAoJS2VybmVsIGRyaXZlciBpbiB1c2U6IHhoY2lfaGNkCgowMDoxNC4yIFNpZ25hbCBw
cm9jZXNzaW5nIGNvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIFN1bnJpc2UgUG9pbnQtTFAg
VGhlcm1hbCBzdWJzeXN0ZW0gKHJldiAyMSkKCVN1YnN5c3RlbTogQWNlciBJbmNvcnBvcmF0ZWQg
W0FMSV0gRGV2aWNlIDExMWUKCUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNs
ZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERp
c0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9
ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRl
bmN5OiAwCglJbnRlcnJ1cHQ6IHBpbiBDIHJvdXRlZCB0byBJUlEgMTgKCVJlZ2lvbiAwOiBNZW1v
cnkgYXQgYjE2NDMwMDAgKDY0LWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9NEtdCglDYXBh
YmlsaXRpZXM6IFs1MF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDMKCQlGbGFnczogUE1FQ2xr
LSBEU0krIEQxLSBEMi0gQXV4Q3VycmVudD0wbUEgUE1FKEQwLSxEMS0sRDItLEQzaG90LSxEM2Nv
bGQtKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0KyBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAg
UE1FLQoJQ2FwYWJpbGl0aWVzOiBbODBdIE1TSTogRW5hYmxlLSBDb3VudD0xLzEgTWFza2FibGUt
IDY0Yml0LQoJCUFkZHJlc3M6IDAwMDAwMDAwICBEYXRhOiAwMDAwCglLZXJuZWwgZHJpdmVyIGlu
IHVzZTogaW50ZWxfcGNoX3RoZXJtYWwKCUtlcm5lbCBtb2R1bGVzOiBpbnRlbF9wY2hfdGhlcm1h
bAoKMDA6MTQuMyBNdWx0aW1lZGlhIGNvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIERldmlj
ZSA5ZDMyIChyZXYgMDEpCglDb250cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyLSBTcGVjQ3ljbGUt
IE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJ
TlR4LQoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZh
c3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJSW50ZXJy
dXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDE2CglSZWdpb24gMDogTWVtb3J5IGF0IGIxNjEwMDAw
ICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUpIFtzaXplPTY0S10KCUNhcGFiaWxpdGllczogWzkw
XSBNU0k6IEVuYWJsZS0gQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdCsKCQlBZGRyZXNzOiAwMDAw
MDAwMDAwMDAwMDAwICBEYXRhOiAwMDAwCglDYXBhYmlsaXRpZXM6IFtkMF0gUG93ZXIgTWFuYWdl
bWVudCB2ZXJzaW9uIDMKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0w
bUEgUE1FKEQwLSxEMS0sRDItLEQzaG90LSxEM2NvbGQtKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0
KyBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJS2VybmVsIG1vZHVsZXM6IGlwdTNf
Y2lvMgoKMDA6MTUuMCBTaWduYWwgcHJvY2Vzc2luZyBjb250cm9sbGVyOiBJbnRlbCBDb3Jwb3Jh
dGlvbiBTdW5yaXNlIFBvaW50LUxQIFNlcmlhbCBJTyBJMkMgQ29udHJvbGxlciAjMCAocmV2IDIx
KQoJU3Vic3lzdGVtOiBBY2VyIEluY29ycG9yYXRlZCBbQUxJXSBEZXZpY2UgMTExZQoJQ29udHJv
bDogSS9PLSBNZW0rIEJ1c01hc3RlcisgU3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFy
RXJyLSBTdGVwcGluZy0gU0VSUi0gRmFzdEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwKyA2Nk1I
ei0gVURGLSBGYXN0QjJCLSBQYXJFcnItIERFVlNFTD1mYXN0ID5UQWJvcnQtIDxUQWJvcnQtIDxN
QWJvcnQtID5TRVJSLSA8UEVSUi0gSU5UeC0KCUxhdGVuY3k6IDAsIENhY2hlIExpbmUgU2l6ZTog
NjQgYnl0ZXMKCUludGVycnVwdDogcGluIEEgcm91dGVkIHRvIElSUSAxNgoJUmVnaW9uIDA6IE1l
bW9yeSBhdCBiMTY0NDAwMCAoNjQtYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT00S10KCUNh
cGFiaWxpdGllczogWzgwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMwoJCUZsYWdzOiBQTUVD
bGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDAtLEQxLSxEMi0sRDNob3QtLEQz
Y29sZC0pCgkJU3RhdHVzOiBEMyBOb1NvZnRSc3QrIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9
MCBQTUUtCglDYXBhYmlsaXRpZXM6IFs5MF0gVmVuZG9yIFNwZWNpZmljIEluZm9ybWF0aW9uOiBM
ZW49MTQgPD8+CglLZXJuZWwgZHJpdmVyIGluIHVzZTogaW50ZWwtbHBzcwoJS2VybmVsIG1vZHVs
ZXM6IGludGVsX2xwc3NfcGNpCgowMDoxNS4xIFNpZ25hbCBwcm9jZXNzaW5nIGNvbnRyb2xsZXI6
IEludGVsIENvcnBvcmF0aW9uIFN1bnJpc2UgUG9pbnQtTFAgU2VyaWFsIElPIEkyQyBDb250cm9s
bGVyICMxIChyZXYgMjEpCglTdWJzeXN0ZW06IEFjZXIgSW5jb3Jwb3JhdGVkIFtBTEldIERldmlj
ZSAxMTFlCglDb250cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYt
IFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4LQoJU3Rh
dHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9y
dC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2Fj
aGUgTGluZSBTaXplOiA2NCBieXRlcwoJSW50ZXJydXB0OiBwaW4gQiByb3V0ZWQgdG8gSVJRIDE3
CglSZWdpb24gMDogTWVtb3J5IGF0IGIxNjQ1MDAwICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUp
IFtzaXplPTRLXQoJQ2FwYWJpbGl0aWVzOiBbODBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAz
CgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1BIFBNRShEMC0sRDEt
LEQyLSxEM2hvdC0sRDNjb2xkLSkKCQlTdGF0dXM6IEQzIE5vU29mdFJzdCsgUE1FLUVuYWJsZS0g
RFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogWzkwXSBWZW5kb3IgU3BlY2lmaWMg
SW5mb3JtYXRpb246IExlbj0xNCA8Pz4KCUtlcm5lbCBkcml2ZXIgaW4gdXNlOiBpbnRlbC1scHNz
CglLZXJuZWwgbW9kdWxlczogaW50ZWxfbHBzc19wY2kKCjAwOjE1LjIgU2lnbmFsIHByb2Nlc3Np
bmcgY29udHJvbGxlcjogSW50ZWwgQ29ycG9yYXRpb24gU3VucmlzZSBQb2ludC1MUCBTZXJpYWwg
SU8gSTJDIENvbnRyb2xsZXIgIzIgKHJldiAyMSkKCVN1YnN5c3RlbTogQWNlciBJbmNvcnBvcmF0
ZWQgW0FMSV0gRGV2aWNlIDExMWUKCUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWND
eWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkIt
IERpc0lOVHgtCglTdGF0dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZT
RUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglM
YXRlbmN5OiAwLCBDYWNoZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglJbnRlcnJ1cHQ6IHBpbiBDIHJv
dXRlZCB0byBJUlEgMTgKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgYjE2NDYwMDAgKDY0LWJpdCwgbm9u
LXByZWZldGNoYWJsZSkgW3NpemU9NEtdCglDYXBhYmlsaXRpZXM6IFs4MF0gUG93ZXIgTWFuYWdl
bWVudCB2ZXJzaW9uIDMKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD0w
bUEgUE1FKEQwLSxEMS0sRDItLEQzaG90LSxEM2NvbGQtKQoJCVN0YXR1czogRDMgTm9Tb2Z0UnN0
KyBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbOTBdIFZl
bmRvciBTcGVjaWZpYyBJbmZvcm1hdGlvbjogTGVuPTE0IDw/PgoJS2VybmVsIGRyaXZlciBpbiB1
c2U6IGludGVsLWxwc3MKCUtlcm5lbCBtb2R1bGVzOiBpbnRlbF9scHNzX3BjaQoKMDA6MTYuMCBD
b21tdW5pY2F0aW9uIGNvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIFN1bnJpc2UgUG9pbnQt
TFAgQ1NNRSBIRUNJICMxIChyZXYgMjEpCglTdWJzeXN0ZW06IEFjZXIgSW5jb3Jwb3JhdGVkIFtB
TEldIERldmljZSAxMTFlCglDb250cm9sOiBJL08tIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUt
IE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJ
TlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZh
c3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5j
eTogMAoJSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDE1MAoJUmVnaW9uIDA6IE1lbW9y
eSBhdCBiMTY0NzAwMCAoNjQtYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT00S10KCUNhcGFi
aWxpdGllczogWzUwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMwoJCUZsYWdzOiBQTUVDbGst
IERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDAtLEQxLSxEMi0sRDNob3QrLEQzY29s
ZC0pCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QrIFBNRS1FbmFibGUtIERTZWw9MCBEU2NhbGU9MCBQ
TUUtCglDYXBhYmlsaXRpZXM6IFs4Y10gTVNJOiBFbmFibGUrIENvdW50PTEvMSBNYXNrYWJsZS0g
NjRiaXQrCgkJQWRkcmVzczogMDAwMDAwMDBmZWUwMDJmOCAgRGF0YTogMDAwMAoJS2VybmVsIGRy
aXZlciBpbiB1c2U6IG1laV9tZQoJS2VybmVsIG1vZHVsZXM6IG1laV9tZQoKMDA6MTcuMCBTQVRB
IGNvbnRyb2xsZXI6IEludGVsIENvcnBvcmF0aW9uIFN1bnJpc2UgUG9pbnQtTFAgU0FUQSBDb250
cm9sbGVyIFtBSENJIG1vZGVdIChyZXYgMjEpIChwcm9nLWlmIDAxIFtBSENJIDEuMF0pCglTdWJz
eXN0ZW06IEFjZXIgSW5jb3Jwb3JhdGVkIFtBTEldIERldmljZSAxMTFlCglDb250cm9sOiBJL08r
IE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0
ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6KyBVREYt
IEZhc3RCMkIrIFBhckVyci0gREVWU0VMPW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0
LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwCglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRl
ZCB0byBJUlEgMTIzCglSZWdpb24gMDogTWVtb3J5IGF0IGIxNjQwMDAwICgzMi1iaXQsIG5vbi1w
cmVmZXRjaGFibGUpIFtzaXplPThLXQoJUmVnaW9uIDE6IE1lbW9yeSBhdCBiMTY0YTAwMCAoMzIt
Yml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0yNTZdCglSZWdpb24gMjogSS9PIHBvcnRzIGF0
IDMwODAgW3NpemU9OF0KCVJlZ2lvbiAzOiBJL08gcG9ydHMgYXQgMzA4OCBbc2l6ZT00XQoJUmVn
aW9uIDQ6IEkvTyBwb3J0cyBhdCAzMDYwIFtzaXplPTMyXQoJUmVnaW9uIDU6IE1lbW9yeSBhdCBi
MTY0ODAwMCAoMzItYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT0yS10KCUNhcGFiaWxpdGll
czogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdC0KCQlBZGRyZXNz
OiBmZWUwMDI1OCAgRGF0YTogMDAwMAoJQ2FwYWJpbGl0aWVzOiBbNzBdIFBvd2VyIE1hbmFnZW1l
bnQgdmVyc2lvbiAzCgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9MG1B
IFBNRShEMC0sRDEtLEQyLSxEM2hvdCssRDNjb2xkLSkKCQlTdGF0dXM6IEQwIE5vU29mdFJzdCsg
UE1FLUVuYWJsZS0gRFNlbD0wIERTY2FsZT0wIFBNRS0KCUNhcGFiaWxpdGllczogW2E4XSBTQVRB
IEhCQSB2MS4wIEJBUjQgT2Zmc2V0PTAwMDAwMDA0CglLZXJuZWwgZHJpdmVyIGluIHVzZTogYWhj
aQoKMDA6MWQuMCBQQ0kgYnJpZGdlOiBJbnRlbCBDb3Jwb3JhdGlvbiBTdW5yaXNlIFBvaW50LUxQ
IFBDSSBFeHByZXNzIFJvb3QgUG9ydCAjOSAocmV2IGYxKSAocHJvZy1pZiAwMCBbTm9ybWFsIGRl
Y29kZV0pCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYt
IFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3Rh
dHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9y
dC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMCwgQ2Fj
aGUgTGluZSBTaXplOiA2NCBieXRlcwoJSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQgdG8gSVJRIDEy
MgoJQnVzOiBwcmltYXJ5PTAwLCBzZWNvbmRhcnk9MDEsIHN1Ym9yZGluYXRlPTAxLCBzZWMtbGF0
ZW5jeT0wCglJL08gYmVoaW5kIGJyaWRnZTogMDAwMGYwMDAtMDAwMDBmZmYgW2VtcHR5XQoJTWVt
b3J5IGJlaGluZCBicmlkZ2U6IGIxNDAwMDAwLWIxNWZmZmZmIFtzaXplPTJNXQoJUHJlZmV0Y2hh
YmxlIG1lbW9yeSBiZWhpbmQgYnJpZGdlOiAwMDAwMDAwMGZmZjAwMDAwLTAwMDAwMDAwMDAwZmZm
ZmYgW2VtcHR5XQoJU2Vjb25kYXJ5IHN0YXR1czogNjZNSHotIEZhc3RCMkItIFBhckVyci0gREVW
U0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydCsgPFNFUlItIDxQRVJSLQoJQnJpZGdl
Q3RsOiBQYXJpdHktIFNFUlItIE5vSVNBLSBWR0EtIE1BYm9ydC0gPlJlc2V0LSBGYXN0QjJCLQoJ
CVByaURpc2NUbXItIFNlY0Rpc2NUbXItIERpc2NUbXJTdGF0LSBEaXNjVG1yU0VSUkVuLQoJQ2Fw
YWJpbGl0aWVzOiBbNDBdIEV4cHJlc3MgKHYyKSBSb290IFBvcnQgKFNsb3QrKSwgTVNJIDAwCgkJ
RGV2Q2FwOglNYXhQYXlsb2FkIDI1NiBieXRlcywgUGhhbnRGdW5jIDAKCQkJRXh0VGFnLSBSQkUr
CgkJRGV2Q3RsOglSZXBvcnQgZXJyb3JzOiBDb3JyZWN0YWJsZSsgTm9uLUZhdGFsKyBGYXRhbCsg
VW5zdXBwb3J0ZWQrCgkJCVJseGRPcmQtIEV4dFRhZy0gUGhhbnRGdW5jLSBBdXhQd3ItIE5vU25v
b3AtCgkJCU1heFBheWxvYWQgMjU2IGJ5dGVzLCBNYXhSZWFkUmVxIDEyOCBieXRlcwoJCURldlN0
YToJQ29yckVyci0gVW5jb3JyRXJyLSBGYXRhbEVyci0gVW5zdXBwUmVxLSBBdXhQd3IrIFRyYW5z
UGVuZC0KCQlMbmtDYXA6CVBvcnQgIzksIFNwZWVkIDhHVC9zLCBXaWR0aCB4MSwgQVNQTSBMMSwg
RXhpdCBMYXRlbmN5IEwxIDwxNnVzCgkJCUNsb2NrUE0tIFN1cnByaXNlLSBMTEFjdFJlcCsgQndO
b3QrIEFTUE1PcHRDb21wKwoJCUxua0N0bDoJQVNQTSBMMSBFbmFibGVkOyBSQ0IgNjQgYnl0ZXMg
RGlzYWJsZWQtIENvbW1DbGsrCgkJCUV4dFN5bmNoLSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50
LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVkIDIuNUdUL3MsIFdpZHRoIHgxLCBUckVyci0gVHJh
aW4tIFNsb3RDbGsrIERMQWN0aXZlKyBCV01nbXQrIEFCV01nbXQtCgkJU2x0Q2FwOglBdHRuQnRu
LSBQd3JDdHJsLSBNUkwtIEF0dG5JbmQtIFB3ckluZC0gSG90UGx1Zy0gU3VycHJpc2UtCgkJCVNs
b3QgIzgsIFBvd2VyTGltaXQgMTAuMDAwVzsgSW50ZXJsb2NrLSBOb0NvbXBsKwoJCVNsdEN0bDoJ
RW5hYmxlOiBBdHRuQnRuLSBQd3JGbHQtIE1STC0gUHJlc0RldC0gQ21kQ3BsdC0gSFBJcnEtIExp
bmtDaGctCgkJCUNvbnRyb2w6IEF0dG5JbmQgVW5rbm93biwgUHdySW5kIFVua25vd24sIFBvd2Vy
LSBJbnRlcmxvY2stCgkJU2x0U3RhOglTdGF0dXM6IEF0dG5CdG4tIFBvd2VyRmx0LSBNUkwtIENt
ZENwbHQtIFByZXNEZXQrIEludGVybG9jay0KCQkJQ2hhbmdlZDogTVJMLSBQcmVzRGV0KyBMaW5r
U3RhdGUrCgkJUm9vdEN0bDogRXJyQ29ycmVjdGFibGUtIEVyck5vbi1GYXRhbC0gRXJyRmF0YWwt
IFBNRUludEVuYSsgQ1JTVmlzaWJsZS0KCQlSb290Q2FwOiBDUlNWaXNpYmxlLQoJCVJvb3RTdGE6
IFBNRSBSZXFJRCAwMDAwLCBQTUVTdGF0dXMtIFBNRVBlbmRpbmctCgkJRGV2Q2FwMjogQ29tcGxl
dGlvbiBUaW1lb3V0OiBSYW5nZSBBQkMsIFRpbWVvdXREaXMrLCBMVFIrLCBPQkZGIE5vdCBTdXBw
b3J0ZWQgQVJJRndkKwoJCQkgQXRvbWljT3BzQ2FwOiBSb3V0aW5nLSAzMmJpdC0gNjRiaXQtIDEy
OGJpdENBUy0KCQlEZXZDdGwyOiBDb21wbGV0aW9uIFRpbWVvdXQ6IDUwdXMgdG8gNTBtcywgVGlt
ZW91dERpcy0sIExUUissIE9CRkYgRGlzYWJsZWQgQVJJRndkLQoJCQkgQXRvbWljT3BzQ3RsOiBS
ZXFFbi0gRWdyZXNzQmxjay0KCQlMbmtDdGwyOiBUYXJnZXQgTGluayBTcGVlZDogOEdUL3MsIEVu
dGVyQ29tcGxpYW5jZS0gU3BlZWREaXMtCgkJCSBUcmFuc21pdCBNYXJnaW46IE5vcm1hbCBPcGVy
YXRpbmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlhbmNlLSBDb21wbGlhbmNlU09TLQoJCQkg
Q29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJCUxua1N0YTI6IEN1cnJlbnQgRGUtZW1waGFz
aXMgTGV2ZWw6IC0zLjVkQiwgRXF1YWxpemF0aW9uQ29tcGxldGUtLCBFcXVhbGl6YXRpb25QaGFz
ZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFzZTItLCBFcXVhbGl6YXRpb25QaGFzZTMtLCBMaW5rRXF1
YWxpemF0aW9uUmVxdWVzdC0KCUNhcGFiaWxpdGllczogWzgwXSBNU0k6IEVuYWJsZSsgQ291bnQ9
MS8xIE1hc2thYmxlLSA2NGJpdC0KCQlBZGRyZXNzOiBmZWUwMDIzOCAgRGF0YTogMDAwMAoJQ2Fw
YWJpbGl0aWVzOiBbOTBdIFN1YnN5c3RlbTogQWNlciBJbmNvcnBvcmF0ZWQgW0FMSV0gRGV2aWNl
IDExMWUKCUNhcGFiaWxpdGllczogW2EwXSBQb3dlciBNYW5hZ2VtZW50IHZlcnNpb24gMwoJCUZs
YWdzOiBQTUVDbGstIERTSS0gRDEtIEQyLSBBdXhDdXJyZW50PTBtQSBQTUUoRDArLEQxLSxEMi0s
RDNob3QrLEQzY29sZCspCgkJU3RhdHVzOiBEMCBOb1NvZnRSc3QtIFBNRS1FbmFibGUtIERTZWw9
MCBEU2NhbGU9MCBQTUUtCglDYXBhYmlsaXRpZXM6IFsxMDAgdjFdIEFkdmFuY2VkIEVycm9yIFJl
cG9ydGluZwoJCVVFU3RhOglETFAtIFNERVMtIFRMUC0gRkNQLSBDbXBsdFRPLSBDbXBsdEFicnQt
IFVueENtcGx0LSBSeE9GLSBNYWxmVExQLSBFQ1JDLSBVbnN1cFJlcS0gQUNTVmlvbC0KCQlVRU1z
azoJRExQLSBTREVTLSBUTFAtIEZDUC0gQ21wbHRUTy0gQ21wbHRBYnJ0LSBVbnhDbXBsdCsgUnhP
Ri0gTWFsZlRMUC0gRUNSQy0gVW5zdXBSZXEtIEFDU1Zpb2wtCgkJVUVTdnJ0OglETFArIFNERVMt
IFRMUC0gRkNQLSBDbXBsdFRPLSBDbXBsdEFicnQtIFVueENtcGx0LSBSeE9GKyBNYWxmVExQKyBF
Q1JDLSBVbnN1cFJlcS0gQUNTVmlvbC0KCQlDRVN0YToJUnhFcnItIEJhZFRMUC0gQmFkRExMUC0g
Um9sbG92ZXItIFRpbWVvdXQtIE5vbkZhdGFsRXJyLQoJCUNFTXNrOglSeEVyci0gQmFkVExQLSBC
YWRETExQLSBSb2xsb3Zlci0gVGltZW91dC0gTm9uRmF0YWxFcnIrCgkJQUVSQ2FwOglGaXJzdCBF
cnJvciBQb2ludGVyOiAwMCwgRUNSQ0dlbkNhcC0gRUNSQ0dlbkVuLSBFQ1JDQ2hrQ2FwLSBFQ1JD
Q2hrRW4tCgkJCU11bHRIZHJSZWNDYXAtIE11bHRIZHJSZWNFbi0gVExQUGZ4UHJlcy0gSGRyTG9n
Q2FwLQoJCUhlYWRlckxvZzogMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAgMDAwMDAwMDAKCQlS
b290Q21kOiBDRVJwdEVuLSBORkVScHRFbi0gRkVScHRFbi0KCQlSb290U3RhOiBDRVJjdmQtIE11
bHRDRVJjdmQtIFVFUmN2ZC0gTXVsdFVFUmN2ZC0KCQkJIEZpcnN0RmF0YWwtIE5vbkZhdGFsTXNn
LSBGYXRhbE1zZy0gSW50TXNnIDAKCQlFcnJvclNyYzogRVJSX0NPUjogMDAwMCBFUlJfRkFUQUwv
Tk9ORkFUQUw6IDAwMDAKCUNhcGFiaWxpdGllczogWzE0MCB2MV0gQWNjZXNzIENvbnRyb2wgU2Vy
dmljZXMKCQlBQ1NDYXA6CVNyY1ZhbGlkKyBUcmFuc0JsaysgUmVxUmVkaXIrIENtcGx0UmVkaXIr
IFVwc3RyZWFtRndkLSBFZ3Jlc3NDdHJsLSBEaXJlY3RUcmFucy0KCQlBQ1NDdGw6CVNyY1ZhbGlk
LSBUcmFuc0Jsay0gUmVxUmVkaXItIENtcGx0UmVkaXItIFVwc3RyZWFtRndkLSBFZ3Jlc3NDdHJs
LSBEaXJlY3RUcmFucy0KCUNhcGFiaWxpdGllczogWzIwMCB2MV0gTDEgUE0gU3Vic3RhdGVzCgkJ
TDFTdWJDYXA6IFBDSS1QTV9MMS4yKyBQQ0ktUE1fTDEuMSsgQVNQTV9MMS4yKyBBU1BNX0wxLjEr
IEwxX1BNX1N1YnN0YXRlcysKCQkJICBQb3J0Q29tbW9uTW9kZVJlc3RvcmVUaW1lPTQwdXMgUG9y
dFRQb3dlck9uVGltZT0xMHVzCgkJTDFTdWJDdGwxOiBQQ0ktUE1fTDEuMisgUENJLVBNX0wxLjEr
IEFTUE1fTDEuMisgQVNQTV9MMS4xKwoJCQkgICBUX0NvbW1vbk1vZGU9NTB1cyBMVFIxLjJfVGhy
ZXNob2xkPTE2Mzg0MG5zCgkJTDFTdWJDdGwyOiBUX1B3ck9uPTEwdXMKCUNhcGFiaWxpdGllczog
WzIyMCB2MV0gIzE5CglLZXJuZWwgZHJpdmVyIGluIHVzZTogcGNpZXBvcnQKCUtlcm5lbCBtb2R1
bGVzOiBzaHBjaHAKCjAwOjFmLjAgSVNBIGJyaWRnZTogSW50ZWwgQ29ycG9yYXRpb24gU3Vucmlz
ZSBQb2ludC1MUCBMUEMgQ29udHJvbGxlciAocmV2IDIxKQoJU3Vic3lzdGVtOiBBY2VyIEluY29y
cG9yYXRlZCBbQUxJXSBEZXZpY2UgMTExZQoJQ29udHJvbDogSS9PKyBNZW0rIEJ1c01hc3Rlcisg
U3BlY0N5Y2xlLSBNZW1XSU5WLSBWR0FTbm9vcC0gUGFyRXJyLSBTdGVwcGluZy0gU0VSUi0gRmFz
dEIyQi0gRGlzSU5UeC0KCVN0YXR1czogQ2FwLSA2Nk1Iei0gVURGLSBGYXN0QjJCLSBQYXJFcnIt
IERFVlNFTD1tZWRpdW0gPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJ
TlR4LQoJTGF0ZW5jeTogMAoKMDA6MWYuMiBNZW1vcnkgY29udHJvbGxlcjogSW50ZWwgQ29ycG9y
YXRpb24gU3VucmlzZSBQb2ludC1MUCBQTUMgKHJldiAyMSkKCVN1YnN5c3RlbTogQWNlciBJbmNv
cnBvcmF0ZWQgW0FMSV0gRGV2aWNlIDExMWUKCUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIr
IFNwZWNDeWNsZS0gTWVtV0lOVi0gVkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZh
c3RCMkItIERpc0lOVHgtCglTdGF0dXM6IENhcC0gNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJy
LSBERVZTRUw9ZmFzdCA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElO
VHgtCglMYXRlbmN5OiAwCglSZWdpb24gMDogTWVtb3J5IGF0IGIxNjNjMDAwICgzMi1iaXQsIG5v
bi1wcmVmZXRjaGFibGUpIFtzaXplPTE2S10KCjAwOjFmLjMgQXVkaW8gZGV2aWNlOiBJbnRlbCBD
b3Jwb3JhdGlvbiBTdW5yaXNlIFBvaW50LUxQIEhEIEF1ZGlvIChyZXYgMjEpCglTdWJzeXN0ZW06
IEFjZXIgSW5jb3Jwb3JhdGVkIFtBTEldIERldmljZSAxMTFlCglDb250cm9sOiBJL08tIE1lbSsg
QnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5n
LSBTRVJSLSBGYXN0QjJCLSBEaXNJTlR4KwoJU3RhdHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RC
MkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRBYm9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlIt
IDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTogMzIsIENhY2hlIExpbmUgU2l6ZTogNjQgYnl0ZXMKCUlu
dGVycnVwdDogcGluIEEgcm91dGVkIHRvIElSUSAxNTEKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgYjE2
MzgwMDAgKDY0LWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9MTZLXQoJUmVnaW9uIDQ6IE1l
bW9yeSBhdCBiMTYyMDAwMCAoNjQtYml0LCBub24tcHJlZmV0Y2hhYmxlKSBbc2l6ZT02NEtdCglD
YXBhYmlsaXRpZXM6IFs1MF0gUG93ZXIgTWFuYWdlbWVudCB2ZXJzaW9uIDMKCQlGbGFnczogUE1F
Q2xrLSBEU0ktIEQxLSBEMi0gQXV4Q3VycmVudD01NW1BIFBNRShEMC0sRDEtLEQyLSxEM2hvdCss
RDNjb2xkKykKCQlTdGF0dXM6IEQwIE5vU29mdFJzdCsgUE1FLUVuYWJsZS0gRFNlbD0wIERTY2Fs
ZT0wIFBNRS0KCUNhcGFiaWxpdGllczogWzYwXSBNU0k6IEVuYWJsZSsgQ291bnQ9MS8xIE1hc2th
YmxlLSA2NGJpdCsKCQlBZGRyZXNzOiAwMDAwMDAwMGZlZTAwMzE4ICBEYXRhOiAwMDAwCglLZXJu
ZWwgZHJpdmVyIGluIHVzZTogc25kX2hkYV9pbnRlbAoJS2VybmVsIG1vZHVsZXM6IHNuZF9oZGFf
aW50ZWwsIHNuZF9zb2Nfc2tsCgowMDoxZi40IFNNQnVzOiBJbnRlbCBDb3Jwb3JhdGlvbiBTdW5y
aXNlIFBvaW50LUxQIFNNQnVzIChyZXYgMjEpCglTdWJzeXN0ZW06IEFjZXIgSW5jb3Jwb3JhdGVk
IFtBTEldIERldmljZSAxMTFlCglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyLSBTcGVjQ3lj
bGUtIE1lbVdJTlYtIFZHQVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSLSBGYXN0QjJCLSBE
aXNJTlR4LQoJU3RhdHVzOiBDYXAtIDY2TUh6LSBVREYtIEZhc3RCMkIrIFBhckVyci0gREVWU0VM
PW1lZGl1bSA+VEFib3J0LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglJ
bnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMTYKCVJlZ2lvbiAwOiBNZW1vcnkgYXQgYjE2
NDkwMDAgKDY0LWJpdCwgbm9uLXByZWZldGNoYWJsZSkgW3NpemU9MjU2XQoJUmVnaW9uIDQ6IEkv
TyBwb3J0cyBhdCAzMDQwIFtzaXplPTMyXQoJS2VybmVsIGRyaXZlciBpbiB1c2U6IGk4MDFfc21i
dXMKCUtlcm5lbCBtb2R1bGVzOiBpMmNfaTgwMQoKMDE6MDAuMCBOZXR3b3JrIGNvbnRyb2xsZXI6
IFF1YWxjb21tIEF0aGVyb3MgUUNBNjE3NCA4MDIuMTFhYyBXaXJlbGVzcyBOZXR3b3JrIEFkYXB0
ZXIgKHJldiAzMikKCVN1YnN5c3RlbTogTGl0ZS1PbiBDb21tdW5pY2F0aW9ucyBJbmMgRGV2aWNl
IDA4MDcKCUNvbnRyb2w6IEkvTy0gTWVtKyBCdXNNYXN0ZXIrIFNwZWNDeWNsZS0gTWVtV0lOVi0g
VkdBU25vb3AtIFBhckVyci0gU3RlcHBpbmctIFNFUlItIEZhc3RCMkItIERpc0lOVHgrCglTdGF0
dXM6IENhcCsgNjZNSHotIFVERi0gRmFzdEIyQi0gUGFyRXJyLSBERVZTRUw9ZmFzdCA+VEFib3J0
LSA8VEFib3J0LSA8TUFib3J0LSA+U0VSUi0gPFBFUlItIElOVHgtCglMYXRlbmN5OiAwLCBDYWNo
ZSBMaW5lIFNpemU6IDY0IGJ5dGVzCglJbnRlcnJ1cHQ6IHBpbiBBIHJvdXRlZCB0byBJUlEgMTUy
CglSZWdpb24gMDogTWVtb3J5IGF0IGIxNDAwMDAwICg2NC1iaXQsIG5vbi1wcmVmZXRjaGFibGUp
IFtzaXplPTJNXQoJQ2FwYWJpbGl0aWVzOiBbNDBdIFBvd2VyIE1hbmFnZW1lbnQgdmVyc2lvbiAz
CgkJRmxhZ3M6IFBNRUNsay0gRFNJLSBEMS0gRDItIEF1eEN1cnJlbnQ9Mzc1bUEgUE1FKEQwKyxE
MS0sRDItLEQzaG90KyxEM2NvbGQrKQoJCVN0YXR1czogRDAgTm9Tb2Z0UnN0LSBQTUUtRW5hYmxl
LSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBbNTBdIE1TSTogRW5hYmxlKyBD
b3VudD0xLzggTWFza2FibGUrIDY0Yml0LQoJCUFkZHJlc3M6IGZlZTAwMzM4ICBEYXRhOiAwMDAw
CgkJTWFza2luZzogMDAwMDAwZmUgIFBlbmRpbmc6IDAwMDAwMDAwCglDYXBhYmlsaXRpZXM6IFs3
MF0gRXhwcmVzcyAodjIpIEVuZHBvaW50LCBNU0kgMDAKCQlEZXZDYXA6CU1heFBheWxvYWQgMjU2
IGJ5dGVzLCBQaGFudEZ1bmMgMCwgTGF0ZW5jeSBMMHMgdW5saW1pdGVkLCBMMSA8NjR1cwoJCQlF
eHRUYWctIEF0dG5CdG4tIEF0dG5JbmQtIFB3ckluZC0gUkJFKyBGTFJlc2V0LSBTbG90UG93ZXJM
aW1pdCAxMC4wMDBXCgkJRGV2Q3RsOglSZXBvcnQgZXJyb3JzOiBDb3JyZWN0YWJsZS0gTm9uLUZh
dGFsLSBGYXRhbC0gVW5zdXBwb3J0ZWQtCgkJCVJseGRPcmQrIEV4dFRhZy0gUGhhbnRGdW5jLSBB
dXhQd3ItIE5vU25vb3AtCgkJCU1heFBheWxvYWQgMjU2IGJ5dGVzLCBNYXhSZWFkUmVxIDUxMiBi
eXRlcwoJCURldlN0YToJQ29yckVycisgVW5jb3JyRXJyLSBGYXRhbEVyci0gVW5zdXBwUmVxLSBB
dXhQd3IrIFRyYW5zUGVuZC0KCQlMbmtDYXA6CVBvcnQgIzAsIFNwZWVkIDIuNUdUL3MsIFdpZHRo
IHgxLCBBU1BNIEwwcyBMMSwgRXhpdCBMYXRlbmN5IEwwcyA8NHVzLCBMMSA8NjR1cwoJCQlDbG9j
a1BNKyBTdXJwcmlzZS0gTExBY3RSZXAtIEJ3Tm90LSBBU1BNT3B0Q29tcCsKCQlMbmtDdGw6CUFT
UE0gTDEgRW5hYmxlZDsgUkNCIDY0IGJ5dGVzIERpc2FibGVkLSBDb21tQ2xrKwoJCQlFeHRTeW5j
aC0gQ2xvY2tQTSsgQXV0V2lkRGlzLSBCV0ludC0gQXV0QldJbnQtCgkJTG5rU3RhOglTcGVlZCAy
LjVHVC9zLCBXaWR0aCB4MSwgVHJFcnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2ZS0gQldNZ210
LSBBQldNZ210LQoJCURldkNhcDI6IENvbXBsZXRpb24gVGltZW91dDogTm90IFN1cHBvcnRlZCwg
VGltZW91dERpcyssIExUUissIE9CRkYgVmlhIG1lc3NhZ2UKCQkJIEF0b21pY09wc0NhcDogMzJi
aXQtIDY0Yml0LSAxMjhiaXRDQVMtCgkJRGV2Q3RsMjogQ29tcGxldGlvbiBUaW1lb3V0OiA1MHVz
IHRvIDUwbXMsIFRpbWVvdXREaXMtLCBMVFIrLCBPQkZGIERpc2FibGVkCgkJCSBBdG9taWNPcHND
dGw6IFJlcUVuLQoJCUxua0N0bDI6IFRhcmdldCBMaW5rIFNwZWVkOiAyLjVHVC9zLCBFbnRlckNv
bXBsaWFuY2UtIFNwZWVkRGlzLQoJCQkgVHJhbnNtaXQgTWFyZ2luOiBOb3JtYWwgT3BlcmF0aW5n
IFJhbmdlLCBFbnRlck1vZGlmaWVkQ29tcGxpYW5jZS0gQ29tcGxpYW5jZVNPUy0KCQkJIENvbXBs
aWFuY2UgRGUtZW1waGFzaXM6IC02ZEIKCQlMbmtTdGEyOiBDdXJyZW50IERlLWVtcGhhc2lzIExl
dmVsOiAtNmRCLCBFcXVhbGl6YXRpb25Db21wbGV0ZS0sIEVxdWFsaXphdGlvblBoYXNlMS0KCQkJ
IEVxdWFsaXphdGlvblBoYXNlMi0sIEVxdWFsaXphdGlvblBoYXNlMy0sIExpbmtFcXVhbGl6YXRp
b25SZXF1ZXN0LQoJQ2FwYWJpbGl0aWVzOiBbMTAwIHYyXSBBZHZhbmNlZCBFcnJvciBSZXBvcnRp
bmcKCQlVRVN0YToJRExQLSBTREVTLSBUTFAtIEZDUC0gQ21wbHRUTy0gQ21wbHRBYnJ0LSBVbnhD
bXBsdC0gUnhPRi0gTWFsZlRMUC0gRUNSQy0gVW5zdXBSZXEtIEFDU1Zpb2wtCgkJVUVNc2s6CURM
UC0gU0RFUy0gVExQLSBGQ1AtIENtcGx0VE8tIENtcGx0QWJydC0gVW54Q21wbHQtIFJ4T0YtIE1h
bGZUTFAtIEVDUkMtIFVuc3VwUmVxLSBBQ1NWaW9sLQoJCVVFU3ZydDoJRExQKyBTREVTKyBUTFAt
IEZDUCsgQ21wbHRUTy0gQ21wbHRBYnJ0LSBVbnhDbXBsdC0gUnhPRisgTWFsZlRMUCsgRUNSQy0g
VW5zdXBSZXEtIEFDU1Zpb2wtCgkJQ0VTdGE6CVJ4RXJyLSBCYWRUTFAtIEJhZERMTFArIFJvbGxv
dmVyLSBUaW1lb3V0LSBOb25GYXRhbEVyci0KCQlDRU1zazoJUnhFcnItIEJhZFRMUC0gQmFkRExM
UC0gUm9sbG92ZXItIFRpbWVvdXQtIE5vbkZhdGFsRXJyKwoJCUFFUkNhcDoJRmlyc3QgRXJyb3Ig
UG9pbnRlcjogMDAsIEVDUkNHZW5DYXAtIEVDUkNHZW5Fbi0gRUNSQ0Noa0NhcC0gRUNSQ0Noa0Vu
LQoJCQlNdWx0SGRyUmVjQ2FwLSBNdWx0SGRyUmVjRW4tIFRMUFBmeFByZXMtIEhkckxvZ0NhcC0K
CQlIZWFkZXJMb2c6IDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwIDAwMDAwMDAwCglDYXBhYmls
aXRpZXM6IFsxNDggdjFdIFZpcnR1YWwgQ2hhbm5lbAoJCUNhcHM6CUxQRVZDPTAgUmVmQ2xrPTEw
MG5zIFBBVEVudHJ5Qml0cz0xCgkJQXJiOglGaXhlZC0gV1JSMzItIFdSUjY0LSBXUlIxMjgtCgkJ
Q3RybDoJQXJiU2VsZWN0PUZpeGVkCgkJU3RhdHVzOglJblByb2dyZXNzLQoJCVZDMDoJQ2FwczoJ
UEFUT2Zmc2V0PTAwIE1heFRpbWVTbG90cz0xIFJlalNub29wVHJhbnMtCgkJCUFyYjoJRml4ZWQt
IFdSUjMyLSBXUlI2NC0gV1JSMTI4LSBUV1JSMTI4LSBXUlIyNTYtCgkJCUN0cmw6CUVuYWJsZSsg
SUQ9MCBBcmJTZWxlY3Q9Rml4ZWQgVEMvVkM9ZmYKCQkJU3RhdHVzOglOZWdvUGVuZGluZy0gSW5Q
cm9ncmVzcy0KCUNhcGFiaWxpdGllczogWzE2OCB2MV0gRGV2aWNlIFNlcmlhbCBOdW1iZXIgMDAt
MDAtMDAtMDAtMDAtMDAtMDAtMDAKCUNhcGFiaWxpdGllczogWzE3OCB2MV0gTGF0ZW5jeSBUb2xl
cmFuY2UgUmVwb3J0aW5nCgkJTWF4IHNub29wIGxhdGVuY3k6IDMxNDU3MjhucwoJCU1heCBubyBz
bm9vcCBsYXRlbmN5OiAzMTQ1NzI4bnMKCUNhcGFiaWxpdGllczogWzE4MCB2MV0gTDEgUE0gU3Vi
c3RhdGVzCgkJTDFTdWJDYXA6IFBDSS1QTV9MMS4yKyBQQ0ktUE1fTDEuMSsgQVNQTV9MMS4yKyBB
U1BNX0wxLjErIEwxX1BNX1N1YnN0YXRlcysKCQkJICBQb3J0Q29tbW9uTW9kZVJlc3RvcmVUaW1l
PTUwdXMgUG9ydFRQb3dlck9uVGltZT0xMHVzCgkJTDFTdWJDdGwxOiBQQ0ktUE1fTDEuMisgUENJ
LVBNX0wxLjErIEFTUE1fTDEuMisgQVNQTV9MMS4xKwoJCQkgICBUX0NvbW1vbk1vZGU9MHVzIExU
UjEuMl9UaHJlc2hvbGQ9MTYzODQwbnMKCQlMMVN1YkN0bDI6IFRfUHdyT249MTB1cwoJS2VybmVs
IGRyaXZlciBpbiB1c2U6IGF0aDEwa19wY2kKCUtlcm5lbCBtb2R1bGVzOiBhdGgxMGtfcGNpLCB3
bAoK
--000000000000b38bf6057144b701--
