Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53652 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752035AbeF1Lhk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Jun 2018 07:37:40 -0400
Date: Thu, 28 Jun 2018 08:37:32 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/2] v4l: Add support for STD ioctls on subdev nodes
Message-ID: <20180628083732.3679d730@coco.lan>
In-Reply-To: <20180517143016.13501-3-niklas.soderlund+renesas@ragnatech.se>
References: <20180517143016.13501-1-niklas.soderlund+renesas@ragnatech.se>
        <20180517143016.13501-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 May 2018 16:30:16 +0200
Niklas S=C3=B6derlund         <niklas.soderlund+renesas@ragnatech.se> escre=
veu:

> There is no way to control the standard of subdevices which are part of
> a media device. The ioctls which exists all target video devices
> explicitly and the idea is that the video device should talk to the
> subdevice. For subdevices part of a media graph this is not possible and
> the standard must be controlled on the subdev device directly.

Why isn't it possible? A media pipeline should have at least a video
devnode where the standard ioctls will be issued.

So, I don't see why you would need to explicitly set the standard inside
a sub-device.

The way I see, inside a given pipeline, all subdevs should be using the
same video standard (maybe except for a m2m device with would have some
coded that would be doing format conversion).

Am I missing something?

Thanks,
Mauro
