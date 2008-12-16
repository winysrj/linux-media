Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBG7IpJG016925
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 02:18:51 -0500
Received: from web32107.mail.mud.yahoo.com (web32107.mail.mud.yahoo.com
	[68.142.207.121])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBG7Ibiw026553
	for <video4linux-list@redhat.com>; Tue, 16 Dec 2008 02:18:37 -0500
Date: Mon, 15 Dec 2008 23:18:36 -0800 (PST)
From: Agustin <gatoguan-os@yahoo.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0812121500400.6411@axis700.grange>
MIME-Version: 1.0
Message-ID: <994493.36303.qm@web32107.mail.mud.yahoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: video4linux list <video4linux-list@redhat.com>
Subject: Re: SoC-Camera bus width,
	and "V4LV4L2_PIX_FMT_Y16" for "monochrome 10 bit"
Reply-To: gatoguan-os@yahoo.com
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Guennadi,

According to manual, i.MX31's CSI can handle up to 16 bits wide, not just 1=
5. I have been checking my hardware limitations and IOMUX options and 16 bi=
ts seems possible.

However, that's far from my current working status. I am using such a big f=
rame format (~7700x970x10bits) that it requires a 16MB buffer for a single =
frame. I did the required mods to kernel to allow a big enough coherent DMA=
 to be reserved, and I am trying to work with one single buffer, though I g=
uess I will use two, sooner or later.

I have come as far to having the image as to successfully requesting a vide=
o capture from userspace through mmap, then get some message from mx3_camer=
a that some IRQ is reserved, then select() expires (10 seconds) and the app=
lication stays "zombie" on exit.

Today I am troubleshooting this. I will see if the frame size or bus 'param=
s' are wrong, and what is the IPU/CSI seeing in the bus, as my logic analyz=
er sees a pretty usable thing. Any tips?

Regards,
--

Agustin Ferrin Pozuelo

Embedded Systems Consultant

http://embedded.ferrin.org/

Tel. +34 610502587

--- El vie, 12/12/08, Guennadi Liakhovetski <g.liakhovetski@gmx.de> escribi=
=C3=B3:
De: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Asunto: Re: SoC-Camera bus width, and "V4LV4L2_PIX_FMT_Y16" for "monochrome=
 10 bit"
Para: "Agustin" <gatoguan-os@yahoo.com>
CC: "video4linux list" <video4linux-list@redhat.com>
Fecha: viernes, 12 diciembre, 2008 5:52

On Fri, 12 Dec 2008, Agustin wrote:

> (Changing subject)
>=20
> On Fri, 12/12/08, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
wrote:
> > On Fri, 12 Dec 2008, Agustin wrote:
> > > Absolutely. Right now I am connecting 6 MT9P031, the monochrome
> > > type, with 12 bits ADC so I think the right format would be
'Y16'.
> >=20
> > Hm, actually I think it is not. As you might have seen in
> > the current soc-camera sources, we now handle two formats:
> > one from the sensor to the host controller driver, and one
> > from the host driver to the user. i.MX31 can handle 15, 10,
> > 8 and 4 bits, so, you will either have to extend your=20
> > 12 bits to 15, or truncate them to 10 or 8. Respectively
> > you will choose a suitable format. But - it will have to be
> > "15-bit monochrome", "10-bit monochrome", or
"8-bit
> > monochrome."
> > Currently I only see 8 and 16 bits defined in v4l, so, if
> > you use anything different you will have to define it. Yes,
> > I know I used V4L2_PIX_FMT_Y16 in mt9m001 for "monochrome
> > 10 bit" - this is wrong, as well as using
> > V4L2_PIX_FMT_SBGGR16 for "Bayer 10 bit,"
> > I will have to fix this some time.
>=20
> According to V4L2 API (http://v4l2spec.bytesex.org/spec/r4246.htm),=20
> V4L2_PIX_FMT_Y16 ('Y16 ') describes "a grey-scale image with
a depth of=20
> 16 bits per pixel". And it is also stated that "the actual
sampling=20
> precision may be lower than 16 bits, for example 10 bits per pixel".
>=20
> So I think V4L2_PIX_FMT_Y16 is valid for all the monochrome widths in=20
> i.MX31, isn't it?

Hm, ok, in case of i.MX31 it is the case - if you connect a sensor over 15=
=20
bit to it, you get 16 bit (see 44.1.1.3) - 15 _most_ significant bits of a=
=20
16-bit word will be used! This is not the case with pxa270 - it uses=20
_least_ significant bits, so, if you get a 10-bit monochrome format. Now=20
with your 12 bits - to get 16 bits out of them you will have to connect=20
them to high 12 bits of imx31: D11 of a sensor to D14 of imx31 ... D0 of a=
=20
sensor to D3 of imx31, then you get 16 bits too. I think, if you connect=20
10 bits and configure imx31 for 10 bits, you get 16 bits too, but I=20
haven't found anything in the datasheet about it.

So, if you connect your sensors correctly _from_ imx31 to the user you get=
=20
8 or 16 bits. But, to describe the format the sensor sends to the imx31=20
you have to specify 15 bits, so that your sensor works correctly also when=
=20
connected to other hosts, e.g., pxa.

> Regarding CSI bus width, I understand it is 'negotiated' through=20
> soc_camera_ops.query/set_bus_params(). I still don't know who makes
the=20
> choice here, so I am just announcing 10 bit cause is what I need at the=
=20
> moment.

The host decides. You will see soon enough whether what you announce is=20
right:-) Even more so after updates that I hope to push out early next=20
week, where flags comparison is made even more strict.

Thanks
Guennadi
---
Guennadi Liakhovetski
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
