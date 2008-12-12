Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBCGqZh8020019
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 11:52:35 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBCGqH3r016181
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 11:52:17 -0500
Date: Fri, 12 Dec 2008 17:52:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Agustin <gatoguan-os@yahoo.com>
In-Reply-To: <779389.20315.qm@web32101.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0812121500400.6411@axis700.grange>
References: <779389.20315.qm@web32101.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux list <video4linux-list@redhat.com>
Subject: Re: SoC-Camera bus width, and "V4LV4L2_PIX_FMT_Y16" for "monochrome
 10 bit"
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

On Fri, 12 Dec 2008, Agustin wrote:

> (Changing subject)
> 
> On Fri, 12/12/08, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > On Fri, 12 Dec 2008, Agustin wrote:
> > > Absolutely. Right now I am connecting 6 MT9P031, the monochrome
> > > type, with 12 bits ADC so I think the right format would be 'Y16'.
> > 
> > Hm, actually I think it is not. As you might have seen in
> > the current soc-camera sources, we now handle two formats:
> > one from the sensor to the host controller driver, and one
> > from the host driver to the user. i.MX31 can handle 15, 10,
> > 8 and 4 bits, so, you will either have to extend your 
> > 12 bits to 15, or truncate them to 10 or 8. Respectively
> > you will choose a suitable format. But - it will have to be
> > "15-bit monochrome", "10-bit monochrome", or "8-bit
> > monochrome."
> > Currently I only see 8 and 16 bits defined in v4l, so, if
> > you use anything different you will have to define it. Yes,
> > I know I used V4L2_PIX_FMT_Y16 in mt9m001 for "monochrome
> > 10 bit" - this is wrong, as well as using
> > V4L2_PIX_FMT_SBGGR16 for "Bayer 10 bit,"
> > I will have to fix this some time.
> 
> According to V4L2 API (http://v4l2spec.bytesex.org/spec/r4246.htm), 
> V4L2_PIX_FMT_Y16 ('Y16 ') describes "a grey-scale image with a depth of 
> 16 bits per pixel". And it is also stated that "the actual sampling 
> precision may be lower than 16 bits, for example 10 bits per pixel".
> 
> So I think V4L2_PIX_FMT_Y16 is valid for all the monochrome widths in 
> i.MX31, isn't it?

Hm, ok, in case of i.MX31 it is the case - if you connect a sensor over 15 
bit to it, you get 16 bit (see 44.1.1.3) - 15 _most_ significant bits of a 
16-bit word will be used! This is not the case with pxa270 - it uses 
_least_ significant bits, so, if you get a 10-bit monochrome format. Now 
with your 12 bits - to get 16 bits out of them you will have to connect 
them to high 12 bits of imx31: D11 of a sensor to D14 of imx31 ... D0 of a 
sensor to D3 of imx31, then you get 16 bits too. I think, if you connect 
10 bits and configure imx31 for 10 bits, you get 16 bits too, but I 
haven't found anything in the datasheet about it.

So, if you connect your sensors correctly _from_ imx31 to the user you get 
8 or 16 bits. But, to describe the format the sensor sends to the imx31 
you have to specify 15 bits, so that your sensor works correctly also when 
connected to other hosts, e.g., pxa.

> Regarding CSI bus width, I understand it is 'negotiated' through 
> soc_camera_ops.query/set_bus_params(). I still don't know who makes the 
> choice here, so I am just announcing 10 bit cause is what I need at the 
> moment.

The host decides. You will see soon enough whether what you announce is 
right:-) Even more so after updates that I hope to push out early next 
week, where flags comparison is made even more strict.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
