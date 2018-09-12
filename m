Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:36821 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726358AbeILNAS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 09:00:18 -0400
Subject: Re: [PATCH v9 5/9] media: platform: Add Cedrus VPU decoder driver
To: Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Paul Kocialkowski <contact@paulk.fr>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20180906222442.14825-1-contact@paulk.fr>
 <20180906222442.14825-6-contact@paulk.fr> <20180911124625.6759e429@coco.lan>
 <20180912072347.nqw4uu23fykjtz72@flea>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <17cad39d-cc81-164c-58a2-00ea7d1f96b3@xs4all.nl>
Date: Wed, 12 Sep 2018 09:56:49 +0200
MIME-Version: 1.0
In-Reply-To: <20180912072347.nqw4uu23fykjtz72@flea>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/2018 09:23 AM, Maxime Ripard wrote:
> On Tue, Sep 11, 2018 at 12:46:25PM -0300, Mauro Carvalho Chehab wrote:
>> Em Fri,  7 Sep 2018 00:24:38 +0200
>> Paul Kocialkowski <contact@paulk.fr> escreveu:
>>
>>> From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>>>
>>> This introduces the Cedrus VPU driver that supports the VPU found in
>>> Allwinner SoCs, also known as Video Engine. It is implemented through
>>> a V4L2 M2M decoder device and a media device (used for media requests).
>>> So far, it only supports MPEG-2 decoding.
>>>
>>> Since this VPU is stateless, synchronization with media requests is
>>> required in order to ensure consistency between frame headers that
>>> contain metadata about the frame to process and the raw slice data that
>>> is used to generate the frame.
>>>
>>> This driver was made possible thanks to the long-standing effort
>>> carried out by the linux-sunxi community in the interest of reverse
>>> engineering, documenting and implementing support for the Allwinner VPU.
>>>
>>> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
>>> Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
>>
>> There are several checkpatch issues here. Ok, some can be
>> ignored, but there are at least some of them that sounda relevant.
> 
> Sorry for that. Given that it's intended to be in staging, do you want
> us to send subsequent patches or the whole serie?

I would actually prefer a v10 with the current follow-up patches merged
into the main driver. I'm getting kbuild errors for the Kconfig missing
select and the PHYS_PFN_OFFSET. So let's just spin a v10.

It would help if you post a follow-up patch for the checkpatch changes
(that's easy to review), then post a v10 with just that and the other
follow-on patches merged into the driver patch itself, and that's
what I'll use for the pull request.

Sorry, I should have seen those checkpatch.pl warnings myself, but I
discovered that my git hooks didn't use the --strict option with
checkpatch. I'd have sworn that I had added it in the past, but apparently
not :-(

Regards,

	Hans
