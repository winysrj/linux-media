Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1503 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbZFQGjI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 02:39:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Subject: Re: [PATCH 1/10 - v2] vpfe capture bridge driver for DM355 and DM6446
Date: Wed, 17 Jun 2009 08:39:06 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com> <200906160029.01328.hverkuil@xs4all.nl> <A69FA2915331DC488A831521EAE36FE40139DF96ED@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40139DF96ED@dlee06.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906170839.06421.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 16 June 2009 16:26:05 Karicheri, Muralidharan wrote:
> Hans,
>
> Thanks for the response.
>
> <snip>
>
> >Polarities have to be set for each side, that's correct. The other
> >parameters are common for both. Although I can think of scenarios where
> > the bus width can differ between host and subdev (e.g. subdev sends
> > data on 8 pins and the host captures on 10 with the least significant
> > two pins pulled low). But that's probably really paranoid of me :-)
>
> [MK] You are right on width. The MT9T001/31 sensor has 10 bits and
> MT9P031 has 12 bits, but on DM355 we the vpfe will take in only 10 bits
> and on DM365 it takes 12 bits. But this is applicable only on the host
> (vpfe) side though (at least in this case) , not on sub device side.

Can you post your latest proposal for the s_bus op?

I propose a few changes: the name of the struct should be something like 
v4l2_bus_settings, the master/slave bit should be renamed to something 
like 'host_is_master', and we should have two widths: subdev_width and 
host_width.

That way the same structure can be used for both host and subdev, unless 
some of the polarities are inverted. In that case you need to make two 
structs, one for host and one for the subdev.

It is possible to add info on inverters to the struct, but unless inverters 
are used a lot more frequently than I expect I am inclined not to do that 
at this time.

> <snip>
>
> >First of all, this isn't a blocking issue at all. This is more a
> >nice-to-have.
> >
> >The reason I mentioned it is because of how we use this (or the dm646x
> > to be
> >precise) at my work: the dm646x is connected to our FPGA so we had to
> > make dummy encoder/decoder drivers to allow it to work with that
> > driver. What made that somewhat annoying is that those dummy drivers
> > really didn't do anything since the FPGA isn't programmed from the
> > linux kernel at all. So we have basically dead code in our kernel just
> > to satisfy a dm646x driver requirement.
> >
> >And you are right: a subdev is bus independent, so it is perfectly
> > possible to make a dummy subdev instead. The key phrase was really
> > 'doesn't require any setup'. It would be nice to be able to use this
> > driver 'standalone' without requiring a subdev. Something to think
> > about.
> >
> >And apologies for my poor review comment, that was phrased rather badly.
>
> [MK] This is the first version of the driver and I assure you that there
> are opportunities to improve the driver as we add more features. Since
> many of the other activities like adding camera interface, supporting
> resizer/previewer are dependent on this, it is important for us to get
> this to the kernel tree as quickly as possible. So I would prefer to keep
> it as is now and change it part of later patches. If this can go in
> 2.6.31, that will be really great.

It's no problem to keep this as is.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
