Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:36301 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbZFPO0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 10:26:10 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Tue, 16 Jun 2009 09:26:05 -0500
Subject: RE: [PATCH 1/10 - v2] vpfe capture bridge driver for DM355 and
 DM6446
Message-ID: <A69FA2915331DC488A831521EAE36FE40139DF96ED@dlee06.ent.ti.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com>
 <200906141610.21618.hverkuil@xs4all.nl>
 <A69FA2915331DC488A831521EAE36FE40139DF9582@dlee06.ent.ti.com>
 <200906160029.01328.hverkuil@xs4all.nl>
In-Reply-To: <200906160029.01328.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

Thanks for the response.

<snip>

>Polarities have to be set for each side, that's correct. The other
>parameters are common for both. Although I can think of scenarios where the
>bus width can differ between host and subdev (e.g. subdev sends data on 8
>pins and the host captures on 10 with the least significant two pins pulled
>low). But that's probably really paranoid of me :-)

[MK] You are right on width. The MT9T001/31 sensor has 10 bits and MT9P031 has 12 bits, but on DM355 we the vpfe will take in only 10 bits and on DM365 it takes 12 bits. But this is applicable only on the host (vpfe) side though (at least in this case) , not on sub device side.

<snip>

>First of all, this isn't a blocking issue at all. This is more a
>nice-to-have.
>
>The reason I mentioned it is because of how we use this (or the dm646x to
>be
>precise) at my work: the dm646x is connected to our FPGA so we had to make
>dummy encoder/decoder drivers to allow it to work with that driver. What
>made that somewhat annoying is that those dummy drivers really didn't do
>anything since the FPGA isn't programmed from the linux kernel at all. So
>we have basically dead code in our kernel just to satisfy a dm646x driver
>requirement.
>
>And you are right: a subdev is bus independent, so it is perfectly possible
>to make a dummy subdev instead. The key phrase was really 'doesn't require
>any setup'. It would be nice to be able to use this driver 'standalone'
>without requiring a subdev. Something to think about.
>
>And apologies for my poor review comment, that was phrased rather badly.
>
[MK] This is the first version of the driver and I assure you that there are opportunities to improve the driver as we add more features. Since many of the other activities like adding camera interface, supporting resizer/previewer are dependent on this, it is important for us to get this to the kernel tree as quickly as possible. So I would prefer to keep it as is now and change it part of later patches. If this can go in 2.6.31, that will be really great.

>>

<snip>

>> >Don't use these PRIVATE_BASE controls. See also this post regarding
>> >the current situation regarding private controls:
>> >
>> >http://www.mail-archive.com/linux-omap%40vger.kernel.org/msg07999.html
>>
>> [MK] Looks like it is better to add it to TBD and address it when I add
>> camera interface support.
>
>OK, but please make sure it is revisited. Improving the control handling
>code in the v4l2 framework is very high on my TODO list since it is getting
>really annoying to implement in drivers. And the inconsistent driver
>support isn't helping applications either.
>
[MK] Sure. I will add it to the TODO list and address it later.
>I really hope I'll have time for it in the next few weeks.
>
>Regards,
>
>	Hans
>
>--
>Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

