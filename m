Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2533 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab3DVG4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 02:56:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv3 01/10] [media] Add initial SDR support at V4L2 API
Date: Mon, 22 Apr 2013 08:56:16 +0200
References: <1366570839-662-1-git-send-email-mchehab@redhat.com> <1366570839-662-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366570839-662-2-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304220856.16295.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun April 21 2013 21:00:30 Mauro Carvalho Chehab wrote:
> Adds the basic API bits for Software Digital Radio (SDR) at
> the V4L2 API.
> 
> A normal radio device is actually radio and hardware demod. As the demod
> is in hardware, several things that are required for the demodulate the
> signal (IF, bandwidth, sample rate, RF/IF filters, etc) are internal to
> the device and aren't part of the API.
> 
> SDR radio, on the other hand, requires that every control needed by the
> tuner to be exposed on userspace, as userspace needs to adjust the
> software decoder to match it.
> 
> As proposed at:
> 	http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/63123
> 
> Add a new device node for SDR devices, and a VIDIOC_QUERYCAP
> capability (V4L2_CAP_SDR) to indicate that a devnode is SDR.
> 
> The stream output format also needs to be different, as it should
> output sample data, instead of video streams. As we need to document
> SDR, add one initial format there that will be later be used.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  Documentation/DocBook/media/v4l/common.xml         | 35 ++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml         | 41 ++++++++++++++++++++++
>  Documentation/DocBook/media/v4l/v4l2.xml           |  1 +
>  .../DocBook/media/v4l/vidioc-querycap.xml          |  7 ++++
>  drivers/media/v4l2-core/v4l2-dev.c                 |  3 ++
>  include/media/v4l2-dev.h                           |  3 +-
>  include/uapi/linux/videodev2.h                     | 11 ++++++
>  7 files changed, 100 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
> index 1ddf354..f59c67d 100644
> --- a/Documentation/DocBook/media/v4l/common.xml
> +++ b/Documentation/DocBook/media/v4l/common.xml
> @@ -513,6 +513,41 @@ the &v4l2-capability; returned by the &VIDIOC-QUERYCAP; ioctl when the
>  device has one or more modulators.</para>
>      </section>
>  
> +  <section id="sdr_tuner">
> +    <title>Software Digital Radio (SDR) Tuners and Modulators</title>
> +
> +    <para>Those devices are special types of Radio devices that don't

s/don't/do not/

'don't' is a bit too informal IMHO.

> +have any analog demodulator. Instead, it samples the radio IF or baseband
> +and sends the samples for userspace to demodulate.</para>

s/for/to/

> +    <section>

Regards,

	Hans
