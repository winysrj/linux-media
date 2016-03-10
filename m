Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:35627 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbcCJPu2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 10:50:28 -0500
MIME-Version: 1.0
In-Reply-To: <20160302214501.GE7079@bigcity.dyn.berto.se>
References: <1456751563-21246-1-git-send-email-ykaneko0929@gmail.com>
	<56D4475A.1070203@xs4all.nl>
	<CAH1o70KLcLAK4GCN-PYmrggHoXFB-9bRiCF73M-0YL5griaweg@mail.gmail.com>
	<20160302214501.GE7079@bigcity.dyn.berto.se>
Date: Fri, 11 Mar 2016 00:50:26 +0900
Message-ID: <CAH1o70LWOX1wd9EaaMLeEy21G1MW0E8aSze9PmL=zNTJD-KYiA@mail.gmail.com>
Subject: Re: [PATCH/RFC 0/4] media: soc_camera: rcar_vin: Add UDS and NV16
 scaling support
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <magnus.damm@gmail.com>,
	Simon Horman <horms@verge.net.au>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas-san,

I'm very sorry for the long delay in my reply.

2016-03-03 6:45 GMT+09:00 Niklas Söderlund <niklas.soderlund@ragnatech.se>:
> Hi Kaneko-san,
>
> On 2016-03-03 02:26:41 +0900, Yoshihiro Kaneko wrote:
>> Hi Hans,
>>
>> 2016-02-29 22:27 GMT+09:00 Hans Verkuil <hverkuil@xs4all.nl>:
>> > Huh, you must have missed Niklas's work the rcar-vin driver:
>> >
>> > http://www.spinics.net/lists/linux-media/msg97816.html
>> >
>> > I expect that the old soc-camera driver will be retired soon in favor of
>> > the new driver, so I don't want to accept patches for that one.
>> >
>> > I recommend that you check the new driver and see what (if anything) is needed
>> > to get this functionality in there and work with Niklas on this.
>> >
>> > This is all quite recent work, so it is not surprising that you missed it.
>>
>> Thank you for informing me!
>> I will check it.
>
> My plan is to look at VIN for Gen3 once Gen2 support is done. I have
> somewhat tried to keep the new driver prepared for Gen3. I have
> separating the Gen2 scaler och clipper out in its own corner since this
> will be different on Gen3.
>
> My understanding is however that Gen3 don't provide UDS blocks
> (scaler+clipper) to all VIN instances. And the VIN instances that have
> access to a UDS block have to share it with one other VIN instance (only
> one user at a time). How to describe this in DT in a good way I do not
> yet know. If you have any ideas here or know more I would be glad to
> hear it, I have not yet started any work for Gen3.
>
> My initial plan for Gen3 enablement is to ignore the UDS blocks all
> together. I feel there is enough to adapt VIN driver and get both the
> CSI2 and sensor driver to work to be able to test the whole chain
> without worrying about UDS too.

Thanks for your detailed explanation.
I don't have any idea. Sorry that I can't help you.
I stop posting any patch for the current (old) VIN driver.

Thanks,
kaneko

>
>>
>> >
>> > Regards,
>> >
>> >         Hans
>>
>> Regards,
>> kaneko
>>
>> >
>> > On 02/29/2016 02:12 PM, Yoshihiro Kaneko wrote:
>> >> This series adds UDS support, NV16 scaling support and callback functions
>> >> to be required by a clipping process.
>> >>
>> >> This series is against the master branch of linuxtv.org/media_tree.git.
>> >>
>> >> Koji Matsuoka (3):
>> >>   media: soc_camera: rcar_vin: Add get_selection callback function
>> >>   media: soc_camera: rcar_vin: Add cropcap callback function
>> >>   media: soc_camera: rcar_vin: Add NV16 scaling support
>> >>
>> >> Yoshihiko Mori (1):
>> >>   media: soc_camera: rcar_vin: Add UDS support
>> >>
>> >>  drivers/media/platform/soc_camera/rcar_vin.c | 220 ++++++++++++++++++++++-----
>> >>  1 file changed, 184 insertions(+), 36 deletions(-)
>> >>
>> >
>
> --
> Regards,
> Niklas Söderlund
