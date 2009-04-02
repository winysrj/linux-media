Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4900 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZDBHrW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 03:47:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: Re: [PATCH 0/3] FM Transmitter driver
Date: Thu, 2 Apr 2009 09:47:11 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>
References: <1238579011-12435-1-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1238579011-12435-1-git-send-email-eduardo.valentin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904020947.11256.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 01 April 2009 11:43:28 Eduardo Valentin wrote:
> Hello Mauro and v4l guys,
>
> This series contains a v4l2 radio driver which
> adds support for Silabs si4713 devices. That is
> a FM transmitter device.
>
> As you should know, v4l2 does not contain representation
> of FM Transmitters (at least that I know). So this driver
> was written highly based on FM receivers API, which can
> cover most of basic functionality. However, as expected,
> there are some properties which were not covered.
> For those properties, sysfs nodes were added in order
> to get user interactions.
>
> Comments are wellcome.

Can you explain in reasonable detail the extra properties needed for a 
device like this? You will need to document that anyway :-) Rather than 
implementing a private API it would be much more interesting to turn this 
into a public V4L2 API that everyone can use.

How does one pass the audio and rds data to the driver? Note that for 2.6.31 
we will finalize the V4L2 RDS decoder API (I recently posted an RFC for 
that, but I haven't had the time to implement the few changes needed). It 
would be nice if rds modulator support would be modeled after this 
demodulator API if possible.

Does region information really belong in the driver? Perhaps this should be 
in a user-space library? (just a suggestion, I'm not sure at this stage).

A general comment: the si4713 driver should be a stand-alone i2c driver. 
That way it can be reused by other drivers/platforms that use this chip. 
The v4l2_subdev framework should be used for this.

Always interesting to see new functionality arrive in V4L2 :-)

Regards,

	Hans

>
> Eduardo Valentin (3):
>   FMTx: si4713: Add files to handle si4713 device
>   FMTx: si4713: Add files to add radio interface for si4713
>   FMTx: si4713: Add Kconfig and Makefile entries
>
>  drivers/media/radio/Kconfig        |   12 +
>  drivers/media/radio/Makefile       |    2 +
>  drivers/media/radio/radio-si4713.c |  834 ++++++++++++++
>  drivers/media/radio/radio-si4713.h |   32 +
>  drivers/media/radio/si4713.c       | 2238
> ++++++++++++++++++++++++++++++++++++ drivers/media/radio/si4713.h       |
>  294 +++++
>  6 files changed, 3412 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/radio/radio-si4713.c
>  create mode 100644 drivers/media/radio/radio-si4713.h
>  create mode 100644 drivers/media/radio/si4713.c
>  create mode 100644 drivers/media/radio/si4713.h
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
