Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBCDvnAg025533
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 08:57:49 -0500
Received: from web32101.mail.mud.yahoo.com (web32101.mail.mud.yahoo.com
	[68.142.207.115])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBCDvVxC026808
	for <video4linux-list@redhat.com>; Fri, 12 Dec 2008 08:57:31 -0500
Date: Fri, 12 Dec 2008 05:57:29 -0800 (PST)
From: Agustin <gatoguan-os@yahoo.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0812121308290.4520@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <779389.20315.qm@web32101.mail.mud.yahoo.com>
Content-Transfer-Encoding: 8bit
Cc: video4linux list <video4linux-list@redhat.com>
Subject: SoC-Camera bus width,
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

(Changing subject)

On Fri, 12/12/08, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Fri, 12 Dec 2008, Agustin wrote:
> > Absolutely. Right now I am connecting 6 MT9P031, the monochrome
> > type, with 12 bits ADC so I think the right format would be 'Y16'.
> 
> Hm, actually I think it is not. As you might have seen in
> the current soc-camera sources, we now handle two formats:
> one from the sensor to the host controller driver, and one
> from the host driver to the user. i.MX31 can handle 15, 10,
> 8 and 4 bits, so, you will either have to extend your 
> 12 bits to 15, or truncate them to 10 or 8. Respectively
> you will choose a suitable format. But - it will have to be
> "15-bit monochrome", "10-bit monochrome", or "8-bit
> monochrome."
> Currently I only see 8 and 16 bits defined in v4l, so, if
> you use anything different you will have to define it. Yes,
> I know I used V4L2_PIX_FMT_Y16 in mt9m001 for "monochrome
> 10 bit" - this is wrong, as well as using
> V4L2_PIX_FMT_SBGGR16 for "Bayer 10 bit,"
> I will have to fix this some time.

According to V4L2 API (http://v4l2spec.bytesex.org/spec/r4246.htm), V4L2_PIX_FMT_Y16 ('Y16 ') describes "a grey-scale image with a depth of 16 bits per pixel". And it is also stated that "the actual sampling precision may be lower than 16 bits, for example 10 bits per pixel".

So I think V4L2_PIX_FMT_Y16 is valid for all the monochrome widths in i.MX31, isn't it?

Maybe you mean that host interface can pack 10-bit data into RAM bit-wise? e.g., putting 4 pixels in every 5 bytes? That would definitely make a new format. I need to check i.MX31 docs on this...

Regarding CSI bus width, I understand it is 'negotiated' through soc_camera_ops.query/set_bus_params(). I still don't know who makes the choice here, so I am just announcing 10 bit cause is what I need at the moment.

> > Later on I plan to use the complete bus width in the i.MX31
> > (16 or 15 bit?) as 'raw' data, in order to pack pixels and
> > get higher data rate at the same clock.
> 
> Maximum 15, but you already use raw data for monochrome,
> i.MX31 doesn't have any special support for it.

I see, then I just need to make sure that nobody tries to interpret
the data on its way to user space.

Regards,
--Agustín.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
