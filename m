Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54665 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab1LVGX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 01:23:58 -0500
Received: by wgbdr13 with SMTP id dr13so15373340wgb.1
        for <linux-media@vger.kernel.org>; Wed, 21 Dec 2011 22:23:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201112211155.36565.laurent.pinchart@ideasonboard.com>
References: <CAOy7-nNJXMbFkJWRubri2O_kc-V1Z+ZjTioqQu=8STtkuLag9w@mail.gmail.com>
	<CAOy7-nOc9U4_BRKYyagcVtDZyr2Z9ZEUAftmdBsfBrWVVLFGjA@mail.gmail.com>
	<CAOy7-nM4-qVjgmgwATPHuUnpPmAggVpsLtJ48H932tweaQdY0Q@mail.gmail.com>
	<201112211155.36565.laurent.pinchart@ideasonboard.com>
Date: Thu, 22 Dec 2011 14:23:56 +0800
Message-ID: <CAOy7-nMhQ6qB2iy+230Gg7yRMV3MtmF6mHAvTtqWR0rAN1DMmw@mail.gmail.com>
Subject: Re: Why is the Y12 support 12-bit grey formats at the CCDC input
 (Y12) is truncated to Y10 at the CCDC output?
From: James <angweiyang@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Michael Jones <michael.jones@matrix-vision.de>,
	linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary=0015174c1a1c5ac62104b4a85865
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--0015174c1a1c5ac62104b4a85865
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On Wed, Dec 21, 2011 at 6:55 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi James,
>
> On Wednesday 21 December 2011 04:06:33 James wrote:
>> On Wed, Dec 21, 2011 at 10:50 AM, James wrote:
>> > On Thu, Dec 15, 2011 at 6:10 PM, Michael Jones wrote:
>> >> Hi James,
>> >>
>> >> Laurent has a program 'media-ctl' to set up the pipeline (see
>> >> http://git.ideasonboard.org/?p=3Dmedia-ctl.git). =A0You will find man=
y
>> >> examples of its usage in the archives of this mailing list. It will
>> >> look something like:
>> >> media-ctl -r
>> >> media-ctl -l '"OMAP3 ISP CCDC":1 -> "OMAP3 ISP CCDC output":0 [1]'
>> >> media-ctl -l '"your-sensor-name":0 -> "OMAP3 ISP CCDC":0 [1]'
>> >>
>> >> you will also need to set the formats through the pipeline with
>> >> 'media-ctl --set-format'.
>> >>
>> >> After you use media-ctl to set up the pipeline, you can use yavta to
>> >> capture the data from the CCDC output (for me, this is /dev/video2).
>> >>
>> >>
>> >> -Michael
>> >
>> > I encountered some obstacles with the driver testing of my monochrome
>> > sensor on top of Steve's 3.0-pm branch. An NXP SC16IS750 I2C-UART
>> > bridge is used to 'transform' the sensor into a I2C device.
>> >
>> > The PCLK, VSYNC, HSYNC (640x512, 30Hz, fixed output format) are free
>> > running upon power-on the sensor unlike MT9V032 which uses the XCLKA
>> > to 'power-on/off' it.
>> >
>> > My steps,
>> >
>> > 1) media-ctl -r -l '"mono640":0->"OMAP3 ISP CCDC":0:[1], "OMAP3 ISP
>> > CCDC":1->"OMAP3 ISP CCDC output":0[1]'
>> >
>> > Resetting all links to inactive
>> > Setting up link 16:0 -> 5:0 [1]
>> > Setting up link 5:1 -> 6:0 [1]
>> >
>> > 2) media-ctl -f '"mono640":0[Y12 640x512]", "OMAP3 ISP CCDC":1[Y12
>> > 640x512]'
>> >
>> > Setting up format Y12 640x512 on pad OMAP3 ISP CCDC/0
>> > Setting up format Y12 640x512 on pad OMAP3 ISP CCDC/1
>> >
>> > 3) yavta -p -f Y12 -s 640x512 -n 4 --capture=3D61 --skip 1 -F `media-c=
tl
>> > -e "OMAP3 ISP CCDC output"` --file=3D./DCIM/Y12
>> >
>> > Unsupported video format 'Y12'
>> >
>> > Did I missed something?
>
> I've just pushed a patch to the yavta repository to support Y10 and Y12.
> Please update.
>
>> > What parameters did you supplied to yavta to test the Y10/Y12
>> >
>> > Many thanks in adv.
>> > Sorry if duplicated emails received.
>>
>> I changed the parameters for yavta from "-f Y12" to "-f Y16"
>>
>> yavta -p -f Y16 -s 640x512 -n 2 --capture=3D10 --skip 5 -F `media-ctl -e
>> "OMAP3 ISP CCDC output"` --file=3D./DCIM/Y16
>>
>> and there are 2 chunks of message at the console now and it ended with
>> "Unable to request buffers: Invalid argument (22).".
>>
>> I've attached the logfile here. (mono640.log)
>>
>> Hope you can assist me to grab the raw Y12 data to file.
>
> --
> Regards,
>
> Laurent Pinchart

Tried the new yavta but encountered a different situation.

yavta -p -f Y12 -s 640x512 -n 2 --capture=3D10 --skip 5 -F `media-ctl -e
"OMAP3 ISP CCDC output"` --file=3D./DCIM/Y12

yavta will hang for infinite time and only Ctrl+C will break out of
the wait and a new error message appears.

yavta: video_do_capture:  calling ioctl..
^C
omap3isp omap3isp: CCDC stop timeout!

I placed some debugging printf() and yavta wait at

ret =3D ioctl(dev->fd, VIDIOC_DQBUF, &buf);

Attached is the logfile (mono640.yavta-y12.1.log)

What should be the remedies?

Many thanks in adv.
--=20
Regards,
James

--0015174c1a1c5ac62104b4a85865
Content-Type: text/x-log; charset=US-ASCII; name="mono640.yavta-y12.1.log"
Content-Disposition: attachment; filename="mono640.yavta-y12.1.log"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gwhdxgzk0

cm9vdEBvdmVybzp+IyBsc21vZApNb2R1bGUgICAgICAgICAgICAgICAgICBTaXplICBVc2VkIGJ5
CmJ1ZmZlcmNsYXNzX3RpICAgICAgICAgIDQ5NzYgIDAgCm9tYXBsZmIgICAgICAgICAgICAgICAg
IDgyODAgIDAgCnB2cnNydmttICAgICAgICAgICAgICAxNTU0NzEgIDIgYnVmZmVyY2xhc3NfdGks
b21hcGxmYgppcHY2ICAgICAgICAgICAgICAgICAgMjI5MTYyICAxOCAKbW9ubzY0MCAgICAgICAg
ICAgICAgICAxMDMwOSAgMSAKbGliZXJ0YXNfc2RpbyAgICAgICAgICAxNDg1MSAgMCAKbGliZXJ0
YXMgICAgICAgICAgICAgICA5MjE5MCAgMSBsaWJlcnRhc19zZGlvCm9tYXAzX2lzcCAgICAgICAg
ICAgICAxMDY5NTcgIDAgCmNmZzgwMjExICAgICAgICAgICAgICAxNjE3NjcgIDEgbGliZXJ0YXMK
djRsMl9jb21tb24gICAgICAgICAgICAgODg4NSAgMiBtb25vNjQwLG9tYXAzX2lzcAp2aWRlb2Rl
diAgICAgICAgICAgICAgIDc4Nzc2ICAzIG1vbm82NDAsb21hcDNfaXNwLHY0bDJfY29tbW9uCm1l
ZGlhICAgICAgICAgICAgICAgICAgMTIxOTIgIDMgbW9ubzY0MCxvbWFwM19pc3AsdmlkZW9kZXYK
bGliODAyMTEgICAgICAgICAgICAgICAgNTQzNSAgMSBsaWJlcnRhcwpmaXJtd2FyZV9jbGFzcyAg
ICAgICAgICA2MzI3ICAyIGxpYmVydGFzX3NkaW8sbGliZXJ0YXMKYWRzNzg0NiAgICAgICAgICAg
ICAgICAxMDUyNCAgMCAKcm9vdEBvdmVybzp+IyBtZWRpYS1jdGwgLXIgLXYgLWwgJyJtb25vNjQw
IjowLT4iT01BUDMgSVNQIENDREMiOjBbMV0sICJPTUFQMyBJU1AKIENDREMiOjEtPiJPTUFQMyBJ
U1AgQ0NEQyBvdXRwdXQiOjBbMV0nCk9wZW5pbmcgbWVkaWEgZGV2aWNlIC9kZXYvbWVkaWEwCkVu
dW1lcmF0aW5nIGVudGl0aWVzCkZvdW5kIDE2IGVudGl0aWVzCkVudW1lcmF0aW5nIHBhZHMgYW5k
IGxpbmtzClJlc2V0dGluZyBhbGwgbGlua3MgdG8gaW5hY3RpdmUKU2V0dGluZyB1cCBsaW5rIDE2
OjAgLT4gNTowIFsxXQpTZXR0aW5nIHVwIGxpbmsgNToxIC0+IDY6MCBbMV0Kcm9vdEBvdmVybzp+
IyBtZWRpYS1jdGwgLXYgLWYgJyJtb25vNjQwIjowW1kxMiA2NDB4NTEyXSwgIk9NQVAzIElTUCBD
Q0RDIjoxW1kxMiAKNjQweDUxMl0nCk9wZW5pbmcgbWVkaWEgZGV2aWNlIC9kZXYvbWVkaWEwCkVu
dW1lcmF0aW5nIGVudGl0aWVzCkZvdW5kIDE2IGVudGl0aWVzCkVudW1lcmF0aW5nIHBhZHMgYW5k
IGxpbmtzClNldHRpbmcgdXAgZm9ybWF0IFkxMiA2NDB4NTEyIG9uIHBhZCBtb25vNjQwIDMtMDA0
ZC8wCm92ZXJvOiBzZXR0aW5nIHhjbGsgdG8gMjUwMDAwMDAgaHoKRm9ybWF0IHNldDogWTEyIDY0
MHg1MTIKU2V0dGluZyB1cCBmb3JtYXQgWTEyIDY0MHg1MTIgb24gcGFkIE9NQVAzIElTUCBDQ0RD
LzAKRm9ybWF0IHNldDogWTEyIDY0MHg1MTIKb3Zlcm86IHNldHRpbmcgeGNsayB0byAwIGh6ClNl
dHRpbmcgdXAgZm9ybWF0IFkxMiA2NDB4NTEyIG9uIHBhZCBPTUFQMyBJU1AgQ0NEQy8xCkZvcm1h
dCBzZXQ6IFkxMiA2NDB4NTEyCnJvb3RAb3Zlcm86fiMgeWF2dGEgLXAgLWYgWTEyIC1zIDY0MHg1
MTIgLW4gMiAtLWNhcHR1cmU9MTAgLS1za2lwIDUgLUYgYG1lZGlhLWN0CmwgLWUgIk9NQVAzIElT
UCBDQ0RDIG91dHB1dCJgIC0tZmlsZT0uL0RDSU0vWTEyCm92ZXJvOiBzZXR0aW5nIHhjbGsgdG8g
MjUwMDAwMDAgaHoKRGV2aWNlIC9kZXYvdmlkZW8yIG9wZW5lZC4KRGV2aWNlIGBPTUFQMyBJU1Ag
Q0NEQyBvdXRwdXQnIG9uIGBtZWRpYScgaXMgYSB2aWRlbyBjYXB0dXJlIGRldmljZS4KVmlkZW8g
Zm9ybWF0IHNldDogWTEyICgyMDMyMzE1OSkgNjQweDUxMiBidWZmZXIgc2l6ZSA2NTUzNjAKVmlk
ZW8gZm9ybWF0OiBZMTIgKDIwMzIzMTU5KSA2NDB4NTEyIGJ1ZmZlciBzaXplIDY1NTM2MAoyIGJ1
ZmZlcnMgcmVxdWVzdGVkLgpsZW5ndGg6IDY1NTM2MCBvZmZzZXQ6IDAKTU1BUDogQnVmZmVyIDAg
bWFwcGVkIGF0IGFkZHJlc3MgMHg0MDEwYjAwMC4KbGVuZ3RoOiA2NTUzNjAgb2Zmc2V0OiA2NTUz
NjAKTU1BUDogQnVmZmVyIDEgbWFwcGVkIGF0IGFkZHJlc3MgMHg0MDMxOTAwMC4KUHJlc3MgZW50
ZXIgdG8gc3RhcnQgY2FwdHVyZQp5YXZ0YTogdmlkZW9fZG9fY2FwdHVyZTogIGNhbGxpbmcgaW9j
dGwuLgpeQwpvbWFwM2lzcCBvbWFwM2lzcDogQ0NEQyBzdG9wIHRpbWVvdXQhCgo=
--0015174c1a1c5ac62104b4a85865--
