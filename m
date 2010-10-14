Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2555 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab0JNGrD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 02:47:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH v12 0/3] TI WL1273 FM Radio driver...
Date: Thu, 14 Oct 2010 08:46:32 +0200
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	eduardo.valentin@nokia.com
References: <1286457373-1742-1-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1286457373-1742-1-git-send-email-matti.j.aaltonen@nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010140846.32224.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Matti,

I've acked patches 1 and 2 and added some comments to patch 3.

Two other patches are needed, though: the new BLOCK_IO and CONTROLS
capabilities also need to be set in existing RDS drivers:

video/saa6588.c
radio/radio-cadet.c
radio/si4713-i2c.c
radio/si470x/radio-si470x-common.c

The other patch is for v4l2-ctl.cpp in the v4l-utils repository where
support for these new caps needs to be added as well.

This second patch can be provided once the other patches are merged, although
it would be nice if you can have it earlier.

Regards,

	Hans

On Thursday, October 07, 2010 15:16:10 Matti J. Aaltonen wrote:
> Hello Mauro, Hans and others.
> 
> I haven't gotten any comments to the latest patch set. The audio part
> of the driver has already been accepted so I'm now trying to apply a
> similar approach as with the codec. I've abstracted out the physical
> control layer from the driver, it could use I2c or UART but the driver
> now has only read and write calls (and a couple of other calls). Also
> the driver doesn't export anything and it doesn't expose the FM radio
> bands it uses internally to the outsize world.
> 
> Cheers,
> Matti
> 
> 
> Matti J. Aaltonen (3):
>   V4L2: Add seek spacing and RDS CAP bits.
>   V4L2: WL1273 FM Radio: Controls for the FM radio.
>   Documentation: v4l: Add hw_seek spacing and two TUNER_RDS_CAP flags.
> 
>  Documentation/DocBook/v4l/dev-rds.xml              |   10 +-
>  .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 +-
>  drivers/media/radio/Kconfig                        |   16 +
>  drivers/media/radio/Makefile                       |    1 +
>  drivers/media/radio/radio-wl1273.c                 | 1848 ++++++++++++++++++++
>  include/linux/videodev2.h                          |    5 +-
>  6 files changed, 1886 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/media/radio/radio-wl1273.c
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
