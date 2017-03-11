Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35806 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754075AbdCKSI3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 13:08:29 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-15-git-send-email-steve_longerbeam@mentor.com>
 <20170302160257.GK3220@valkosipuli.retiisi.org.uk>
 <20170303230645.GR21222@n2100.armlinux.org.uk>
 <20170304131329.GV3220@valkosipuli.retiisi.org.uk>
 <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
 <20170310120902.1daebc7b@vento.lan>
 <5e1183f4-774f-413a-628a-96e0df321faf@xs4all.nl>
 <20170311101408.272a9187@vento.lan>
 <20170311153229.yrdjmggb3p2suhdw@ihha.localdomain>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Message-ID: <acfb5eca-ff00-6d57-339a-3322034cbdb3@gmail.com>
Date: Sat, 11 Mar 2017 10:08:23 -0800
MIME-Version: 1.0
In-Reply-To: <20170311153229.yrdjmggb3p2suhdw@ihha.localdomain>
Content-Type: multipart/mixed;
 boundary="------------D3D8DB550A7856A23DA581FD"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------D3D8DB550A7856A23DA581FD
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit



On 03/11/2017 07:32 AM, Sakari Ailus wrote:
> Hi Mauro and Hans,
>
> On Sat, Mar 11, 2017 at 10:14:08AM -0300, Mauro Carvalho Chehab wrote:
>> Em Sat, 11 Mar 2017 12:32:43 +0100
>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>
>>> On 10/03/17 16:09, Mauro Carvalho Chehab wrote:
>>>> Em Fri, 10 Mar 2017 13:54:28 +0100
>>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>>
>>>>>> Devices that have complex pipeline that do essentially require using the
>>>>>> Media controller interface to configure them are out of that scope.
>>>>>>
>>>>>
>>>>> Way too much of how the MC devices should be used is in the minds of developers.
>>>>> There is a major lack for good detailed documentation, utilities, compliance
>>>>> test (really needed!) and libv4l plugins.
>>>>
>>>> Unfortunately, we merged an incomplete MC support at the Kernel. We knew
>>>> all the problems with MC-based drivers and V4L2 applications by the time
>>>> it was developed, and we requested Nokia developers (with was sponsoring MC
>>>> develoment, on that time) to work on a solution to allow standard V4L2
>>>> applications to work with MC based boards.
>>>>
>>>> Unfortunately, we took the decision to merge MC without that, because
>>>> Nokia was giving up on Linux development, and we didn't want to lose the
>>>> 2 years of discussions and work around it, as Nokia employers were leaving
>>>> the company. Also, on that time, there was already some patches floating
>>>> around adding backward support via libv4l. Unfortunately, those patches
>>>> were never finished.
>>>>
>>>> The net result is that MC was merged with some huge gaps, including
>>>> the lack of a proper solution for a generic V4L2 program to work
>>>> with V4L2 devices that use the subdev API.
>>>>
>>>> That was not that bad by then, as MC was used only on cell phones
>>>> that run custom-made applications.
>>>>
>>>> The reallity changed, as now, we have lots of low cost SoC based
>>>> boards, used for all sort of purposes. So, we need a quick solution
>>>> for it.
>>>>
>>>> In other words, while that would be acceptable support special apps
>>>> on really embedded systems, it is *not OK* for general purpose SoC
>>>> harware[1].
>>>>
>>>> [1] I'm calling "general purpose SoC harware" those ARM boards
>>>> like Raspberry Pi that are shipped to the mass and used by a wide
>>>> range of hobbyists and other people that just wants to run Linux on
>>>> ARM. It is possible to buy such boards for a very cheap price,
>>>> making them to be used not only on special projects, where a custom
>>>> made application could be interesting, but also for a lot of
>>>> users that just want to run Linux on a low cost ARM board, while
>>>> keeping using standard V4L2 apps, like "camorama".
>>>>
>>>> That's perhaps one of the reasons why it took a long time for us to
>>>> start receiving drivers upstream for such hardware: it is quite
>>>> intimidating and not logical to require developers to implement
>>>> on their drivers 2 complex APIs (MC, subdev) for those
>>>> hardware that most users won't care. From user's perspective,
>>>> being able to support generic applications like "camorama" and
>>>> "zbar" is all they want.
>>>>
>>>> In summary, I'm pretty sure we need to support standard V4L2
>>>> applications on boards like Raspberry Pi and those low-cost
>>>> SoC-based boards that are shipped to end users.
>>>>
>>>>> Anyway, regarding this specific patch and for this MC-aware driver: no, you
>>>>> shouldn't inherit controls from subdevs. It defeats the purpose.
>>>>
>>>> Sorry, but I don't agree with that. The subdev API is an optional API
>>>> (and even the MC API can be optional).
>>>>
>>>> I see the rationale for using MC and subdev APIs on cell phones,
>>>> ISV and other embedded hardware, as it will allow fine-tuning
>>>> the driver's support to allow providing the required quality for
>>>> certain custom-made applications. but on general SoC hardware,
>>>> supporting standard V4L2 applications is a need.
>>>>
>>>> Ok, perhaps supporting both subdev API and V4L2 API at the same
>>>> time doesn't make much sense. We could disable one in favor of the
>>>> other, either at compilation time or at runtime.
>>>
>>> Right. If the subdev API is disabled, then you have to inherit the subdev
>>> controls in the bridge driver (how else would you be able to access them?).
>>> And that's the usual case.
>>>
>>> If you do have the subdev API enabled, AND you use the MC, then the
>>> intention clearly is to give userspace full control and inheriting controls
>>> no longer makes any sense (and is highly confusing IMHO).
>>
>> I tend to agree with that.
>
> I agree as well.
>
> This is in line with how existing drivers behave, too.


Well, sounds like there is consensus on this topic. I guess I'll
go ahead and remove the control inheritance support. I suppose
having a control appear in two places (subdev and video nodes) can
be confusing.

As for the configurability vs. ease-of-use debate, I added the
control inheritance to make it a little easier on the user, but,
as the dot graphs below will show, the user already needs quite
a lot of knowledge of the architecture already, in order to setup
the different pipelines. So perhaps the control inheritance is
rather pointless anyway.



>
>>
>>>>
>>>> This way, if the subdev API is disabled, the driver will be
>>>> functional for V4L2-based applications that don't support neither
>>>> MC or subdev APIs.
>>>
>>> I'm not sure if it makes sense for the i.MX driver to behave differently
>>> depending on whether the subdev API is enabled or disabled. I don't know
>>> enough of the hardware to tell if it would ever make sense to disable the
>>> subdev API.
>>
>> Yeah, I don't know enough about it either. The point is: this is
>> something that the driver maintainer and driver users should
>> decide if it either makes sense or not, based on the expected use cases.
>
> My understanding of the i.MX6 case is the hardware is configurable enough
> to warrant the use of the Media controller API. Some patches indicate
> there are choices to be made in data routing.
>
> Steve: could you enlighten us on the topic, by e.g. doing media-ctl
> --print-dot and sending the results to the list? What kind of different IP
> blocks are there and what do they do? A pointer to hardware documentation
> wouldn't hurt either (if it's available).

Wow, I didn't realize there was so little knowledge of the imx6
IPU capture architecture.

Yes, the imx6 definitely warrants the need for MC, as the dot graphs
will attest.

The graphs follows very closely the actual hardware architecture of
the IPU capture blocks. I.e., all the subdevs and links shown correspond 
to actual hardware connections and sub-blocks.

Russell just provided a link to the imx6 reference manual, and dot
graph for the imx219 based platform.

Also I've added quite a lot of detail to the media doc at
Documentation/media/v4l-drivers/imx.rst.

The dot graphs for SabreSD, SabreLite, and SabreAuto reference platforms 
are attached. This is generated from the most recent
(version 5) imx-media driver.

Steve

--------------D3D8DB550A7856A23DA581FD
Content-Type: application/msword-template;
 name="sabresd.dot"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="sabresd.dot"

ZGlncmFwaCBib2FyZCB7CglyYW5rZGlyPVRCCgluMDAwMDAwMDEgW2xhYmVsPSJ7ezxwb3J0
MD4gMCB8IDxwb3J0MT4gMX0gfCBpcHUyX2NzaTFfbXV4XG4vZGV2L3Y0bC1zdWJkZXYwIHwg
ezxwb3J0Mj4gMn19Iiwgc2hhcGU9TXJlY29yZCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9
Z3JlZW5dCgluMDAwMDAwMDE6cG9ydDIgLT4gbjAwMDAwMDViOnBvcnQwIFtzdHlsZT1kYXNo
ZWRdCgluMDAwMDAwMDUgW2xhYmVsPSJ7ezxwb3J0MD4gMCB8IDxwb3J0MT4gMX0gfCBpcHUx
X2NzaTBfbXV4XG4vZGV2L3Y0bC1zdWJkZXYxIHwgezxwb3J0Mj4gMn19Iiwgc2hhcGU9TXJl
Y29yZCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9Z3JlZW5dCgluMDAwMDAwMDU6cG9ydDIg
LT4gbjAwMDAwMDNkOnBvcnQwIFtzdHlsZT1kYXNoZWRdCgluMDAwMDAwMDkgW2xhYmVsPSJ7
ezxwb3J0MD4gMCB8IDxwb3J0MT4gMX0gfCBpcHUxX3ZkaWNcbi9kZXYvdjRsLXN1YmRldjIg
fCB7PHBvcnQyPiAyfX0iLCBzaGFwZT1NcmVjb3JkLCBzdHlsZT1maWxsZWQsIGZpbGxjb2xv
cj1ncmVlbl0KCW4wMDAwMDAwOTpwb3J0MiAtPiBuMDAwMDAwMTE6cG9ydDAgW3N0eWxlPWRh
c2hlZF0KCW4wMDAwMDAwZCBbbGFiZWw9Int7PHBvcnQwPiAwIHwgPHBvcnQxPiAxfSB8IGlw
dTJfdmRpY1xuL2Rldi92NGwtc3ViZGV2MyB8IHs8cG9ydDI+IDJ9fSIsIHNoYXBlPU1yZWNv
cmQsIHN0eWxlPWZpbGxlZCwgZmlsbGNvbG9yPWdyZWVuXQoJbjAwMDAwMDBkOnBvcnQyIC0+
IG4wMDAwMDAyNzpwb3J0MCBbc3R5bGU9ZGFzaGVkXQoJbjAwMDAwMDExIFtsYWJlbD0ie3s8
cG9ydDA+IDB9IHwgaXB1MV9pY19wcnBcbi9kZXYvdjRsLXN1YmRldjQgfCB7PHBvcnQxPiAx
IHwgPHBvcnQyPiAyfX0iLCBzaGFwZT1NcmVjb3JkLCBzdHlsZT1maWxsZWQsIGZpbGxjb2xv
cj1ncmVlbl0KCW4wMDAwMDAxMTpwb3J0MSAtPiBuMDAwMDAwMTU6cG9ydDAgW3N0eWxlPWRh
c2hlZF0KCW4wMDAwMDAxMTpwb3J0MiAtPiBuMDAwMDAwMWU6cG9ydDAgW3N0eWxlPWRhc2hl
ZF0KCW4wMDAwMDAxNSBbbGFiZWw9Int7PHBvcnQwPiAwfSB8IGlwdTFfaWNfcHJwZW5jXG4v
ZGV2L3Y0bC1zdWJkZXY1IHwgezxwb3J0MT4gMX19Iiwgc2hhcGU9TXJlY29yZCwgc3R5bGU9
ZmlsbGVkLCBmaWxsY29sb3I9Z3JlZW5dCgluMDAwMDAwMTU6cG9ydDEgLT4gbjAwMDAwMDE4
IFtzdHlsZT1kYXNoZWRdCgluMDAwMDAwMTggW2xhYmVsPSJpcHUxX2ljX3BycGVuYyBjYXB0
dXJlXG4vZGV2L3ZpZGVvMCIsIHNoYXBlPWJveCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9
eWVsbG93XQoJbjAwMDAwMDFlIFtsYWJlbD0ie3s8cG9ydDA+IDB9IHwgaXB1MV9pY19wcnB2
ZlxuL2Rldi92NGwtc3ViZGV2NiB8IHs8cG9ydDE+IDF9fSIsIHNoYXBlPU1yZWNvcmQsIHN0
eWxlPWZpbGxlZCwgZmlsbGNvbG9yPWdyZWVuXQoJbjAwMDAwMDFlOnBvcnQxIC0+IG4wMDAw
MDAyMSBbc3R5bGU9ZGFzaGVkXQoJbjAwMDAwMDIxIFtsYWJlbD0iaXB1MV9pY19wcnB2ZiBj
YXB0dXJlXG4vZGV2L3ZpZGVvMSIsIHNoYXBlPWJveCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29s
b3I9eWVsbG93XQoJbjAwMDAwMDI3IFtsYWJlbD0ie3s8cG9ydDA+IDB9IHwgaXB1Ml9pY19w
cnBcbi9kZXYvdjRsLXN1YmRldjcgfCB7PHBvcnQxPiAxIHwgPHBvcnQyPiAyfX0iLCBzaGFw
ZT1NcmVjb3JkLCBzdHlsZT1maWxsZWQsIGZpbGxjb2xvcj1ncmVlbl0KCW4wMDAwMDAyNzpw
b3J0MSAtPiBuMDAwMDAwMmI6cG9ydDAgW3N0eWxlPWRhc2hlZF0KCW4wMDAwMDAyNzpwb3J0
MiAtPiBuMDAwMDAwMzQ6cG9ydDAgW3N0eWxlPWRhc2hlZF0KCW4wMDAwMDAyYiBbbGFiZWw9
Int7PHBvcnQwPiAwfSB8IGlwdTJfaWNfcHJwZW5jXG4vZGV2L3Y0bC1zdWJkZXY4IHwgezxw
b3J0MT4gMX19Iiwgc2hhcGU9TXJlY29yZCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9Z3Jl
ZW5dCgluMDAwMDAwMmI6cG9ydDEgLT4gbjAwMDAwMDJlIFtzdHlsZT1kYXNoZWRdCgluMDAw
MDAwMmUgW2xhYmVsPSJpcHUyX2ljX3BycGVuYyBjYXB0dXJlXG4vZGV2L3ZpZGVvMiIsIHNo
YXBlPWJveCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9eWVsbG93XQoJbjAwMDAwMDM0IFts
YWJlbD0ie3s8cG9ydDA+IDB9IHwgaXB1Ml9pY19wcnB2ZlxuL2Rldi92NGwtc3ViZGV2OSB8
IHs8cG9ydDE+IDF9fSIsIHNoYXBlPU1yZWNvcmQsIHN0eWxlPWZpbGxlZCwgZmlsbGNvbG9y
PWdyZWVuXQoJbjAwMDAwMDM0OnBvcnQxIC0+IG4wMDAwMDAzNyBbc3R5bGU9ZGFzaGVkXQoJ
bjAwMDAwMDM3IFtsYWJlbD0iaXB1Ml9pY19wcnB2ZiBjYXB0dXJlXG4vZGV2L3ZpZGVvMyIs
IHNoYXBlPWJveCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9eWVsbG93XQoJbjAwMDAwMDNk
IFtsYWJlbD0ie3s8cG9ydDA+IDB9IHwgaXB1MV9jc2kwXG4vZGV2L3Y0bC1zdWJkZXYxMCB8
IHs8cG9ydDE+IDEgfCA8cG9ydDI+IDJ9fSIsIHNoYXBlPU1yZWNvcmQsIHN0eWxlPWZpbGxl
ZCwgZmlsbGNvbG9yPWdyZWVuXQoJbjAwMDAwMDNkOnBvcnQyIC0+IG4wMDAwMDA0MSBbc3R5
bGU9ZGFzaGVkXQoJbjAwMDAwMDNkOnBvcnQxIC0+IG4wMDAwMDAxMTpwb3J0MCBbc3R5bGU9
ZGFzaGVkXQoJbjAwMDAwMDNkOnBvcnQxIC0+IG4wMDAwMDAwOTpwb3J0MCBbc3R5bGU9ZGFz
aGVkXQoJbjAwMDAwMDQxIFtsYWJlbD0iaXB1MV9jc2kwIGNhcHR1cmVcbi9kZXYvdmlkZW80
Iiwgc2hhcGU9Ym94LCBzdHlsZT1maWxsZWQsIGZpbGxjb2xvcj15ZWxsb3ddCgluMDAwMDAw
NDcgW2xhYmVsPSJ7ezxwb3J0MD4gMH0gfCBpcHUxX2NzaTFcbi9kZXYvdjRsLXN1YmRldjEx
IHwgezxwb3J0MT4gMSB8IDxwb3J0Mj4gMn19Iiwgc2hhcGU9TXJlY29yZCwgc3R5bGU9Zmls
bGVkLCBmaWxsY29sb3I9Z3JlZW5dCgluMDAwMDAwNDc6cG9ydDIgLT4gbjAwMDAwMDRiIFtz
dHlsZT1kYXNoZWRdCgluMDAwMDAwNDc6cG9ydDEgLT4gbjAwMDAwMDExOnBvcnQwIFtzdHls
ZT1kYXNoZWRdCgluMDAwMDAwNDc6cG9ydDEgLT4gbjAwMDAwMDA5OnBvcnQwIFtzdHlsZT1k
YXNoZWRdCgluMDAwMDAwNGIgW2xhYmVsPSJpcHUxX2NzaTEgY2FwdHVyZVxuL2Rldi92aWRl
bzUiLCBzaGFwZT1ib3gsIHN0eWxlPWZpbGxlZCwgZmlsbGNvbG9yPXllbGxvd10KCW4wMDAw
MDA1MSBbbGFiZWw9Int7PHBvcnQwPiAwfSB8IGlwdTJfY3NpMFxuL2Rldi92NGwtc3ViZGV2
MTIgfCB7PHBvcnQxPiAxIHwgPHBvcnQyPiAyfX0iLCBzaGFwZT1NcmVjb3JkLCBzdHlsZT1m
aWxsZWQsIGZpbGxjb2xvcj1ncmVlbl0KCW4wMDAwMDA1MTpwb3J0MiAtPiBuMDAwMDAwNTUg
W3N0eWxlPWRhc2hlZF0KCW4wMDAwMDA1MTpwb3J0MSAtPiBuMDAwMDAwMjc6cG9ydDAgW3N0
eWxlPWRhc2hlZF0KCW4wMDAwMDA1MTpwb3J0MSAtPiBuMDAwMDAwMGQ6cG9ydDAgW3N0eWxl
PWRhc2hlZF0KCW4wMDAwMDA1NSBbbGFiZWw9ImlwdTJfY3NpMCBjYXB0dXJlXG4vZGV2L3Zp
ZGVvNiIsIHNoYXBlPWJveCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9eWVsbG93XQoJbjAw
MDAwMDViIFtsYWJlbD0ie3s8cG9ydDA+IDB9IHwgaXB1Ml9jc2kxXG4vZGV2L3Y0bC1zdWJk
ZXYxMyB8IHs8cG9ydDE+IDEgfCA8cG9ydDI+IDJ9fSIsIHNoYXBlPU1yZWNvcmQsIHN0eWxl
PWZpbGxlZCwgZmlsbGNvbG9yPWdyZWVuXQoJbjAwMDAwMDViOnBvcnQyIC0+IG4wMDAwMDA1
ZiBbc3R5bGU9ZGFzaGVkXQoJbjAwMDAwMDViOnBvcnQxIC0+IG4wMDAwMDAyNzpwb3J0MCBb
c3R5bGU9ZGFzaGVkXQoJbjAwMDAwMDViOnBvcnQxIC0+IG4wMDAwMDAwZDpwb3J0MCBbc3R5
bGU9ZGFzaGVkXQoJbjAwMDAwMDVmIFtsYWJlbD0iaXB1Ml9jc2kxIGNhcHR1cmVcbi9kZXYv
dmlkZW83Iiwgc2hhcGU9Ym94LCBzdHlsZT1maWxsZWQsIGZpbGxjb2xvcj15ZWxsb3ddCglu
MDAwMDAwNjUgW2xhYmVsPSJ7ezxwb3J0MD4gMH0gfCBpbXg2LW1pcGktY3NpMlxuL2Rldi92
NGwtc3ViZGV2MTQgfCB7PHBvcnQxPiAxIHwgPHBvcnQyPiAyIHwgPHBvcnQzPiAzIHwgPHBv
cnQ0PiA0fX0iLCBzaGFwZT1NcmVjb3JkLCBzdHlsZT1maWxsZWQsIGZpbGxjb2xvcj1ncmVl
bl0KCW4wMDAwMDA2NTpwb3J0MSAtPiBuMDAwMDAwMDU6cG9ydDAgW3N0eWxlPWRhc2hlZF0K
CW4wMDAwMDA2NTpwb3J0MiAtPiBuMDAwMDAwNDc6cG9ydDAgW3N0eWxlPWRhc2hlZF0KCW4w
MDAwMDA2NTpwb3J0MyAtPiBuMDAwMDAwNTE6cG9ydDAgW3N0eWxlPWRhc2hlZF0KCW4wMDAw
MDA2NTpwb3J0NCAtPiBuMDAwMDAwMDE6cG9ydDAgW3N0eWxlPWRhc2hlZF0KCW4wMDAwMDA2
YiBbbGFiZWw9Int7fSB8IG92NTY0MCAxLTAwM2Ncbi9kZXYvdjRsLXN1YmRldjE1IHwgezxw
b3J0MD4gMH19Iiwgc2hhcGU9TXJlY29yZCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9Z3Jl
ZW5dCgluMDAwMDAwNmI6cG9ydDAgLT4gbjAwMDAwMDY1OnBvcnQwIFtzdHlsZT1kYXNoZWRd
Cn0KCg==
--------------D3D8DB550A7856A23DA581FD
Content-Type: application/msword-template;
 name="sabrelite.dot"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="sabrelite.dot"

ZGlncmFwaCBib2FyZCB7CglyYW5rZGlyPVRCCgluMDAwMDAwMDEgW2xhYmVsPSJ7ezxwb3J0
MD4gMCB8IDxwb3J0MT4gMX0gfCBpcHUyX2NzaTFfbXV4XG4vZGV2L3Y0bC1zdWJkZXYwIHwg
ezxwb3J0Mj4gMn19Iiwgc2hhcGU9TXJlY29yZCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9
Z3JlZW5dCgluMDAwMDAwMDE6cG9ydDIgLT4gbjAwMDAwMDViOnBvcnQwIFtzdHlsZT1kYXNo
ZWRdCgluMDAwMDAwMDUgW2xhYmVsPSJ7ezxwb3J0MD4gMCB8IDxwb3J0MT4gMX0gfCBpcHUx
X2NzaTBfbXV4XG4vZGV2L3Y0bC1zdWJkZXYxIHwgezxwb3J0Mj4gMn19Iiwgc2hhcGU9TXJl
Y29yZCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9Z3JlZW5dCgluMDAwMDAwMDU6cG9ydDIg
LT4gbjAwMDAwMDNkOnBvcnQwIFtzdHlsZT1kYXNoZWRdCgluMDAwMDAwMDkgW2xhYmVsPSJ7
ezxwb3J0MD4gMCB8IDxwb3J0MT4gMX0gfCBpcHUxX3ZkaWNcbi9kZXYvdjRsLXN1YmRldjIg
fCB7PHBvcnQyPiAyfX0iLCBzaGFwZT1NcmVjb3JkLCBzdHlsZT1maWxsZWQsIGZpbGxjb2xv
cj1ncmVlbl0KCW4wMDAwMDAwOTpwb3J0MiAtPiBuMDAwMDAwMTE6cG9ydDAgW3N0eWxlPWRh
c2hlZF0KCW4wMDAwMDAwZCBbbGFiZWw9Int7PHBvcnQwPiAwIHwgPHBvcnQxPiAxfSB8IGlw
dTJfdmRpY1xuL2Rldi92NGwtc3ViZGV2MyB8IHs8cG9ydDI+IDJ9fSIsIHNoYXBlPU1yZWNv
cmQsIHN0eWxlPWZpbGxlZCwgZmlsbGNvbG9yPWdyZWVuXQoJbjAwMDAwMDBkOnBvcnQyIC0+
IG4wMDAwMDAyNzpwb3J0MCBbc3R5bGU9ZGFzaGVkXQoJbjAwMDAwMDExIFtsYWJlbD0ie3s8
cG9ydDA+IDB9IHwgaXB1MV9pY19wcnBcbi9kZXYvdjRsLXN1YmRldjQgfCB7PHBvcnQxPiAx
IHwgPHBvcnQyPiAyfX0iLCBzaGFwZT1NcmVjb3JkLCBzdHlsZT1maWxsZWQsIGZpbGxjb2xv
cj1ncmVlbl0KCW4wMDAwMDAxMTpwb3J0MSAtPiBuMDAwMDAwMTU6cG9ydDAgW3N0eWxlPWRh
c2hlZF0KCW4wMDAwMDAxMTpwb3J0MiAtPiBuMDAwMDAwMWU6cG9ydDAgW3N0eWxlPWRhc2hl
ZF0KCW4wMDAwMDAxNSBbbGFiZWw9Int7PHBvcnQwPiAwfSB8IGlwdTFfaWNfcHJwZW5jXG4v
ZGV2L3Y0bC1zdWJkZXY1IHwgezxwb3J0MT4gMX19Iiwgc2hhcGU9TXJlY29yZCwgc3R5bGU9
ZmlsbGVkLCBmaWxsY29sb3I9Z3JlZW5dCgluMDAwMDAwMTU6cG9ydDEgLT4gbjAwMDAwMDE4
IFtzdHlsZT1kYXNoZWRdCgluMDAwMDAwMTggW2xhYmVsPSJpcHUxX2ljX3BycGVuYyBjYXB0
dXJlXG4vZGV2L3ZpZGVvMCIsIHNoYXBlPWJveCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9
eWVsbG93XQoJbjAwMDAwMDFlIFtsYWJlbD0ie3s8cG9ydDA+IDB9IHwgaXB1MV9pY19wcnB2
ZlxuL2Rldi92NGwtc3ViZGV2NiB8IHs8cG9ydDE+IDF9fSIsIHNoYXBlPU1yZWNvcmQsIHN0
eWxlPWZpbGxlZCwgZmlsbGNvbG9yPWdyZWVuXQoJbjAwMDAwMDFlOnBvcnQxIC0+IG4wMDAw
MDAyMSBbc3R5bGU9ZGFzaGVkXQoJbjAwMDAwMDIxIFtsYWJlbD0iaXB1MV9pY19wcnB2ZiBj
YXB0dXJlXG4vZGV2L3ZpZGVvMSIsIHNoYXBlPWJveCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29s
b3I9eWVsbG93XQoJbjAwMDAwMDI3IFtsYWJlbD0ie3s8cG9ydDA+IDB9IHwgaXB1Ml9pY19w
cnBcbi9kZXYvdjRsLXN1YmRldjcgfCB7PHBvcnQxPiAxIHwgPHBvcnQyPiAyfX0iLCBzaGFw
ZT1NcmVjb3JkLCBzdHlsZT1maWxsZWQsIGZpbGxjb2xvcj1ncmVlbl0KCW4wMDAwMDAyNzpw
b3J0MSAtPiBuMDAwMDAwMmI6cG9ydDAgW3N0eWxlPWRhc2hlZF0KCW4wMDAwMDAyNzpwb3J0
MiAtPiBuMDAwMDAwMzQ6cG9ydDAgW3N0eWxlPWRhc2hlZF0KCW4wMDAwMDAyYiBbbGFiZWw9
Int7PHBvcnQwPiAwfSB8IGlwdTJfaWNfcHJwZW5jXG4vZGV2L3Y0bC1zdWJkZXY4IHwgezxw
b3J0MT4gMX19Iiwgc2hhcGU9TXJlY29yZCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9Z3Jl
ZW5dCgluMDAwMDAwMmI6cG9ydDEgLT4gbjAwMDAwMDJlIFtzdHlsZT1kYXNoZWRdCgluMDAw
MDAwMmUgW2xhYmVsPSJpcHUyX2ljX3BycGVuYyBjYXB0dXJlXG4vZGV2L3ZpZGVvMiIsIHNo
YXBlPWJveCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9eWVsbG93XQoJbjAwMDAwMDM0IFts
YWJlbD0ie3s8cG9ydDA+IDB9IHwgaXB1Ml9pY19wcnB2ZlxuL2Rldi92NGwtc3ViZGV2OSB8
IHs8cG9ydDE+IDF9fSIsIHNoYXBlPU1yZWNvcmQsIHN0eWxlPWZpbGxlZCwgZmlsbGNvbG9y
PWdyZWVuXQoJbjAwMDAwMDM0OnBvcnQxIC0+IG4wMDAwMDAzNyBbc3R5bGU9ZGFzaGVkXQoJ
bjAwMDAwMDM3IFtsYWJlbD0iaXB1Ml9pY19wcnB2ZiBjYXB0dXJlXG4vZGV2L3ZpZGVvMyIs
IHNoYXBlPWJveCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9eWVsbG93XQoJbjAwMDAwMDNk
IFtsYWJlbD0ie3s8cG9ydDA+IDB9IHwgaXB1MV9jc2kwXG4vZGV2L3Y0bC1zdWJkZXYxMCB8
IHs8cG9ydDE+IDEgfCA8cG9ydDI+IDJ9fSIsIHNoYXBlPU1yZWNvcmQsIHN0eWxlPWZpbGxl
ZCwgZmlsbGNvbG9yPWdyZWVuXQoJbjAwMDAwMDNkOnBvcnQyIC0+IG4wMDAwMDA0MSBbc3R5
bGU9ZGFzaGVkXQoJbjAwMDAwMDNkOnBvcnQxIC0+IG4wMDAwMDAxMTpwb3J0MCBbc3R5bGU9
ZGFzaGVkXQoJbjAwMDAwMDNkOnBvcnQxIC0+IG4wMDAwMDAwOTpwb3J0MCBbc3R5bGU9ZGFz
aGVkXQoJbjAwMDAwMDQxIFtsYWJlbD0iaXB1MV9jc2kwIGNhcHR1cmVcbi9kZXYvdmlkZW80
Iiwgc2hhcGU9Ym94LCBzdHlsZT1maWxsZWQsIGZpbGxjb2xvcj15ZWxsb3ddCgluMDAwMDAw
NDcgW2xhYmVsPSJ7ezxwb3J0MD4gMH0gfCBpcHUxX2NzaTFcbi9kZXYvdjRsLXN1YmRldjEx
IHwgezxwb3J0MT4gMSB8IDxwb3J0Mj4gMn19Iiwgc2hhcGU9TXJlY29yZCwgc3R5bGU9Zmls
bGVkLCBmaWxsY29sb3I9Z3JlZW5dCgluMDAwMDAwNDc6cG9ydDIgLT4gbjAwMDAwMDRiIFtz
dHlsZT1kYXNoZWRdCgluMDAwMDAwNDc6cG9ydDEgLT4gbjAwMDAwMDExOnBvcnQwIFtzdHls
ZT1kYXNoZWRdCgluMDAwMDAwNDc6cG9ydDEgLT4gbjAwMDAwMDA5OnBvcnQwIFtzdHlsZT1k
YXNoZWRdCgluMDAwMDAwNGIgW2xhYmVsPSJpcHUxX2NzaTEgY2FwdHVyZVxuL2Rldi92aWRl
bzUiLCBzaGFwZT1ib3gsIHN0eWxlPWZpbGxlZCwgZmlsbGNvbG9yPXllbGxvd10KCW4wMDAw
MDA1MSBbbGFiZWw9Int7PHBvcnQwPiAwfSB8IGlwdTJfY3NpMFxuL2Rldi92NGwtc3ViZGV2
MTIgfCB7PHBvcnQxPiAxIHwgPHBvcnQyPiAyfX0iLCBzaGFwZT1NcmVjb3JkLCBzdHlsZT1m
aWxsZWQsIGZpbGxjb2xvcj1ncmVlbl0KCW4wMDAwMDA1MTpwb3J0MiAtPiBuMDAwMDAwNTUg
W3N0eWxlPWRhc2hlZF0KCW4wMDAwMDA1MTpwb3J0MSAtPiBuMDAwMDAwMjc6cG9ydDAgW3N0
eWxlPWRhc2hlZF0KCW4wMDAwMDA1MTpwb3J0MSAtPiBuMDAwMDAwMGQ6cG9ydDAgW3N0eWxl
PWRhc2hlZF0KCW4wMDAwMDA1NSBbbGFiZWw9ImlwdTJfY3NpMCBjYXB0dXJlXG4vZGV2L3Zp
ZGVvNiIsIHNoYXBlPWJveCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9eWVsbG93XQoJbjAw
MDAwMDViIFtsYWJlbD0ie3s8cG9ydDA+IDB9IHwgaXB1Ml9jc2kxXG4vZGV2L3Y0bC1zdWJk
ZXYxMyB8IHs8cG9ydDE+IDEgfCA8cG9ydDI+IDJ9fSIsIHNoYXBlPU1yZWNvcmQsIHN0eWxl
PWZpbGxlZCwgZmlsbGNvbG9yPWdyZWVuXQoJbjAwMDAwMDViOnBvcnQyIC0+IG4wMDAwMDA1
ZiBbc3R5bGU9ZGFzaGVkXQoJbjAwMDAwMDViOnBvcnQxIC0+IG4wMDAwMDAyNzpwb3J0MCBb
c3R5bGU9ZGFzaGVkXQoJbjAwMDAwMDViOnBvcnQxIC0+IG4wMDAwMDAwZDpwb3J0MCBbc3R5
bGU9ZGFzaGVkXQoJbjAwMDAwMDVmIFtsYWJlbD0iaXB1Ml9jc2kxIGNhcHR1cmVcbi9kZXYv
dmlkZW83Iiwgc2hhcGU9Ym94LCBzdHlsZT1maWxsZWQsIGZpbGxjb2xvcj15ZWxsb3ddCglu
MDAwMDAwNjUgW2xhYmVsPSJ7ezxwb3J0MD4gMH0gfCBpbXg2LW1pcGktY3NpMlxuL2Rldi92
NGwtc3ViZGV2MTQgfCB7PHBvcnQxPiAxIHwgPHBvcnQyPiAyIHwgPHBvcnQzPiAzIHwgPHBv
cnQ0PiA0fX0iLCBzaGFwZT1NcmVjb3JkLCBzdHlsZT1maWxsZWQsIGZpbGxjb2xvcj1ncmVl
bl0KCW4wMDAwMDA2NTpwb3J0MSAtPiBuMDAwMDAwMDU6cG9ydDAgW3N0eWxlPWRhc2hlZF0K
CW4wMDAwMDA2NTpwb3J0MiAtPiBuMDAwMDAwNDc6cG9ydDAgW3N0eWxlPWRhc2hlZF0KCW4w
MDAwMDA2NTpwb3J0MyAtPiBuMDAwMDAwNTE6cG9ydDAgW3N0eWxlPWRhc2hlZF0KCW4wMDAw
MDA2NTpwb3J0NCAtPiBuMDAwMDAwMDE6cG9ydDAgW3N0eWxlPWRhc2hlZF0KCW4wMDAwMDA2
YiBbbGFiZWw9Int7fSB8IG92NTY0MCAxLTAwNDBcbi9kZXYvdjRsLXN1YmRldjE1IHwgezxw
b3J0MD4gMH19Iiwgc2hhcGU9TXJlY29yZCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9Z3Jl
ZW5dCgluMDAwMDAwNmI6cG9ydDAgLT4gbjAwMDAwMDY1OnBvcnQwIFtzdHlsZT1kYXNoZWRd
Cn0KCg==
--------------D3D8DB550A7856A23DA581FD
Content-Type: application/msword-template;
 name="sabreauto.dot"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="sabreauto.dot"

ZGlncmFwaCBib2FyZCB7CglyYW5rZGlyPVRCCgluMDAwMDAwMDEgW2xhYmVsPSJ7ezxwb3J0
MD4gMCB8IDxwb3J0MT4gMX0gfCBpcHUyX2NzaTFfbXV4XG4vZGV2L3Y0bC1zdWJkZXYwIHwg
ezxwb3J0Mj4gMn19Iiwgc2hhcGU9TXJlY29yZCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9
Z3JlZW5dCgluMDAwMDAwMDE6cG9ydDIgLT4gbjAwMDAwMDViOnBvcnQwIFtzdHlsZT1kYXNo
ZWRdCgluMDAwMDAwMDUgW2xhYmVsPSJ7ezxwb3J0MD4gMCB8IDxwb3J0MT4gMX0gfCBpcHUx
X2NzaTBfbXV4XG4vZGV2L3Y0bC1zdWJkZXYxIHwgezxwb3J0Mj4gMn19Iiwgc2hhcGU9TXJl
Y29yZCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9Z3JlZW5dCgluMDAwMDAwMDU6cG9ydDIg
LT4gbjAwMDAwMDNkOnBvcnQwIFtzdHlsZT1kYXNoZWRdCgluMDAwMDAwMDkgW2xhYmVsPSJ7
ezxwb3J0MD4gMCB8IDxwb3J0MT4gMX0gfCBpcHUxX3ZkaWNcbi9kZXYvdjRsLXN1YmRldjIg
fCB7PHBvcnQyPiAyfX0iLCBzaGFwZT1NcmVjb3JkLCBzdHlsZT1maWxsZWQsIGZpbGxjb2xv
cj1ncmVlbl0KCW4wMDAwMDAwOTpwb3J0MiAtPiBuMDAwMDAwMTE6cG9ydDAgW3N0eWxlPWRh
c2hlZF0KCW4wMDAwMDAwZCBbbGFiZWw9Int7PHBvcnQwPiAwIHwgPHBvcnQxPiAxfSB8IGlw
dTJfdmRpY1xuL2Rldi92NGwtc3ViZGV2MyB8IHs8cG9ydDI+IDJ9fSIsIHNoYXBlPU1yZWNv
cmQsIHN0eWxlPWZpbGxlZCwgZmlsbGNvbG9yPWdyZWVuXQoJbjAwMDAwMDBkOnBvcnQyIC0+
IG4wMDAwMDAyNzpwb3J0MCBbc3R5bGU9ZGFzaGVkXQoJbjAwMDAwMDExIFtsYWJlbD0ie3s8
cG9ydDA+IDB9IHwgaXB1MV9pY19wcnBcbi9kZXYvdjRsLXN1YmRldjQgfCB7PHBvcnQxPiAx
IHwgPHBvcnQyPiAyfX0iLCBzaGFwZT1NcmVjb3JkLCBzdHlsZT1maWxsZWQsIGZpbGxjb2xv
cj1ncmVlbl0KCW4wMDAwMDAxMTpwb3J0MSAtPiBuMDAwMDAwMTU6cG9ydDAgW3N0eWxlPWRh
c2hlZF0KCW4wMDAwMDAxMTpwb3J0MiAtPiBuMDAwMDAwMWU6cG9ydDAgW3N0eWxlPWRhc2hl
ZF0KCW4wMDAwMDAxNSBbbGFiZWw9Int7PHBvcnQwPiAwfSB8IGlwdTFfaWNfcHJwZW5jXG4v
ZGV2L3Y0bC1zdWJkZXY1IHwgezxwb3J0MT4gMX19Iiwgc2hhcGU9TXJlY29yZCwgc3R5bGU9
ZmlsbGVkLCBmaWxsY29sb3I9Z3JlZW5dCgluMDAwMDAwMTU6cG9ydDEgLT4gbjAwMDAwMDE4
IFtzdHlsZT1kYXNoZWRdCgluMDAwMDAwMTggW2xhYmVsPSJpcHUxX2ljX3BycGVuYyBjYXB0
dXJlXG4vZGV2L3ZpZGVvMCIsIHNoYXBlPWJveCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9
eWVsbG93XQoJbjAwMDAwMDFlIFtsYWJlbD0ie3s8cG9ydDA+IDB9IHwgaXB1MV9pY19wcnB2
ZlxuL2Rldi92NGwtc3ViZGV2NiB8IHs8cG9ydDE+IDF9fSIsIHNoYXBlPU1yZWNvcmQsIHN0
eWxlPWZpbGxlZCwgZmlsbGNvbG9yPWdyZWVuXQoJbjAwMDAwMDFlOnBvcnQxIC0+IG4wMDAw
MDAyMSBbc3R5bGU9ZGFzaGVkXQoJbjAwMDAwMDIxIFtsYWJlbD0iaXB1MV9pY19wcnB2ZiBj
YXB0dXJlXG4vZGV2L3ZpZGVvMSIsIHNoYXBlPWJveCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29s
b3I9eWVsbG93XQoJbjAwMDAwMDI3IFtsYWJlbD0ie3s8cG9ydDA+IDB9IHwgaXB1Ml9pY19w
cnBcbi9kZXYvdjRsLXN1YmRldjcgfCB7PHBvcnQxPiAxIHwgPHBvcnQyPiAyfX0iLCBzaGFw
ZT1NcmVjb3JkLCBzdHlsZT1maWxsZWQsIGZpbGxjb2xvcj1ncmVlbl0KCW4wMDAwMDAyNzpw
b3J0MSAtPiBuMDAwMDAwMmI6cG9ydDAgW3N0eWxlPWRhc2hlZF0KCW4wMDAwMDAyNzpwb3J0
MiAtPiBuMDAwMDAwMzQ6cG9ydDAgW3N0eWxlPWRhc2hlZF0KCW4wMDAwMDAyYiBbbGFiZWw9
Int7PHBvcnQwPiAwfSB8IGlwdTJfaWNfcHJwZW5jXG4vZGV2L3Y0bC1zdWJkZXY4IHwgezxw
b3J0MT4gMX19Iiwgc2hhcGU9TXJlY29yZCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9Z3Jl
ZW5dCgluMDAwMDAwMmI6cG9ydDEgLT4gbjAwMDAwMDJlIFtzdHlsZT1kYXNoZWRdCgluMDAw
MDAwMmUgW2xhYmVsPSJpcHUyX2ljX3BycGVuYyBjYXB0dXJlXG4vZGV2L3ZpZGVvMiIsIHNo
YXBlPWJveCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9eWVsbG93XQoJbjAwMDAwMDM0IFts
YWJlbD0ie3s8cG9ydDA+IDB9IHwgaXB1Ml9pY19wcnB2ZlxuL2Rldi92NGwtc3ViZGV2OSB8
IHs8cG9ydDE+IDF9fSIsIHNoYXBlPU1yZWNvcmQsIHN0eWxlPWZpbGxlZCwgZmlsbGNvbG9y
PWdyZWVuXQoJbjAwMDAwMDM0OnBvcnQxIC0+IG4wMDAwMDAzNyBbc3R5bGU9ZGFzaGVkXQoJ
bjAwMDAwMDM3IFtsYWJlbD0iaXB1Ml9pY19wcnB2ZiBjYXB0dXJlXG4vZGV2L3ZpZGVvMyIs
IHNoYXBlPWJveCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9eWVsbG93XQoJbjAwMDAwMDNk
IFtsYWJlbD0ie3s8cG9ydDA+IDB9IHwgaXB1MV9jc2kwXG4vZGV2L3Y0bC1zdWJkZXYxMCB8
IHs8cG9ydDE+IDEgfCA8cG9ydDI+IDJ9fSIsIHNoYXBlPU1yZWNvcmQsIHN0eWxlPWZpbGxl
ZCwgZmlsbGNvbG9yPWdyZWVuXQoJbjAwMDAwMDNkOnBvcnQyIC0+IG4wMDAwMDA0MSBbc3R5
bGU9ZGFzaGVkXQoJbjAwMDAwMDNkOnBvcnQxIC0+IG4wMDAwMDAxMTpwb3J0MCBbc3R5bGU9
ZGFzaGVkXQoJbjAwMDAwMDNkOnBvcnQxIC0+IG4wMDAwMDAwOTpwb3J0MCBbc3R5bGU9ZGFz
aGVkXQoJbjAwMDAwMDQxIFtsYWJlbD0iaXB1MV9jc2kwIGNhcHR1cmVcbi9kZXYvdmlkZW80
Iiwgc2hhcGU9Ym94LCBzdHlsZT1maWxsZWQsIGZpbGxjb2xvcj15ZWxsb3ddCgluMDAwMDAw
NDcgW2xhYmVsPSJ7ezxwb3J0MD4gMH0gfCBpcHUxX2NzaTFcbi9kZXYvdjRsLXN1YmRldjEx
IHwgezxwb3J0MT4gMSB8IDxwb3J0Mj4gMn19Iiwgc2hhcGU9TXJlY29yZCwgc3R5bGU9Zmls
bGVkLCBmaWxsY29sb3I9Z3JlZW5dCgluMDAwMDAwNDc6cG9ydDIgLT4gbjAwMDAwMDRiIFtz
dHlsZT1kYXNoZWRdCgluMDAwMDAwNDc6cG9ydDEgLT4gbjAwMDAwMDExOnBvcnQwIFtzdHls
ZT1kYXNoZWRdCgluMDAwMDAwNDc6cG9ydDEgLT4gbjAwMDAwMDA5OnBvcnQwIFtzdHlsZT1k
YXNoZWRdCgluMDAwMDAwNGIgW2xhYmVsPSJpcHUxX2NzaTEgY2FwdHVyZVxuL2Rldi92aWRl
bzUiLCBzaGFwZT1ib3gsIHN0eWxlPWZpbGxlZCwgZmlsbGNvbG9yPXllbGxvd10KCW4wMDAw
MDA1MSBbbGFiZWw9Int7PHBvcnQwPiAwfSB8IGlwdTJfY3NpMFxuL2Rldi92NGwtc3ViZGV2
MTIgfCB7PHBvcnQxPiAxIHwgPHBvcnQyPiAyfX0iLCBzaGFwZT1NcmVjb3JkLCBzdHlsZT1m
aWxsZWQsIGZpbGxjb2xvcj1ncmVlbl0KCW4wMDAwMDA1MTpwb3J0MiAtPiBuMDAwMDAwNTUg
W3N0eWxlPWRhc2hlZF0KCW4wMDAwMDA1MTpwb3J0MSAtPiBuMDAwMDAwMjc6cG9ydDAgW3N0
eWxlPWRhc2hlZF0KCW4wMDAwMDA1MTpwb3J0MSAtPiBuMDAwMDAwMGQ6cG9ydDAgW3N0eWxl
PWRhc2hlZF0KCW4wMDAwMDA1NSBbbGFiZWw9ImlwdTJfY3NpMCBjYXB0dXJlXG4vZGV2L3Zp
ZGVvNiIsIHNoYXBlPWJveCwgc3R5bGU9ZmlsbGVkLCBmaWxsY29sb3I9eWVsbG93XQoJbjAw
MDAwMDViIFtsYWJlbD0ie3s8cG9ydDA+IDB9IHwgaXB1Ml9jc2kxXG4vZGV2L3Y0bC1zdWJk
ZXYxMyB8IHs8cG9ydDE+IDEgfCA8cG9ydDI+IDJ9fSIsIHNoYXBlPU1yZWNvcmQsIHN0eWxl
PWZpbGxlZCwgZmlsbGNvbG9yPWdyZWVuXQoJbjAwMDAwMDViOnBvcnQyIC0+IG4wMDAwMDA1
ZiBbc3R5bGU9ZGFzaGVkXQoJbjAwMDAwMDViOnBvcnQxIC0+IG4wMDAwMDAyNzpwb3J0MCBb
c3R5bGU9ZGFzaGVkXQoJbjAwMDAwMDViOnBvcnQxIC0+IG4wMDAwMDAwZDpwb3J0MCBbc3R5
bGU9ZGFzaGVkXQoJbjAwMDAwMDVmIFtsYWJlbD0iaXB1Ml9jc2kxIGNhcHR1cmVcbi9kZXYv
dmlkZW83Iiwgc2hhcGU9Ym94LCBzdHlsZT1maWxsZWQsIGZpbGxjb2xvcj15ZWxsb3ddCglu
MDAwMDAwNjUgW2xhYmVsPSJ7e30gfCBhZHY3MTgwIDQtMDAyMVxuL2Rldi92NGwtc3ViZGV2
MTQgfCB7PHBvcnQwPiAwfX0iLCBzaGFwZT1NcmVjb3JkLCBzdHlsZT1maWxsZWQsIGZpbGxj
b2xvcj1ncmVlbl0KCW4wMDAwMDA2NTpwb3J0MCAtPiBuMDAwMDAwMDU6cG9ydDEgW3N0eWxl
PWRhc2hlZF0KfQoK
--------------D3D8DB550A7856A23DA581FD--
