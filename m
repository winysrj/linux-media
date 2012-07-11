Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2365 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab2GKSB5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 14:01:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 1/5] v4l2: Add rangelow and rangehigh fields to the v4l2_hw_freq_seek struct
Date: Wed, 11 Jul 2012 20:01:18 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	halli manjunatha <hallimanju@gmail.com>
References: <1342021658-27821-1-git-send-email-hdegoede@redhat.com> <1342021658-27821-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1342021658-27821-2-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207112001.18960.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

I've CC-ed Halli as well.

On Wed July 11 2012 17:47:34 Hans de Goede wrote:
> To allow apps to limit a hw-freq-seek to a specific band, for further
> info see the documentation this patch adds for these new fields.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |   44 ++++++++++++++++----
>  include/linux/videodev2.h                          |    5 ++-
>  2 files changed, 40 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
> index f4db44d..50dc9f8 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
> @@ -52,11 +52,21 @@
>      <para>Start a hardware frequency seek from the current frequency.
>  To do this applications initialize the <structfield>tuner</structfield>,
>  <structfield>type</structfield>, <structfield>seek_upward</structfield>,
> -<structfield>spacing</structfield> and
> -<structfield>wrap_around</structfield> fields, and zero out the
> -<structfield>reserved</structfield> array of a &v4l2-hw-freq-seek; and
> -call the <constant>VIDIOC_S_HW_FREQ_SEEK</constant> ioctl with a pointer
> -to this structure.</para>
> +<structfield>wrap_around</structfield>, <structfield>spacing</structfield>,
> +<structfield>rangelow</structfield> and <structfield>rangehigh</structfield>
> +fields, and zero out the <structfield>reserved</structfield> array of a
> +&v4l2-hw-freq-seek; and call the <constant>VIDIOC_S_HW_FREQ_SEEK</constant>
> +ioctl with a pointer to this structure.</para>
> +
> +    <para>The <structfield>rangelow</structfield> and
> +<structfield>rangehigh</structfield> fields can be set to a non-zero value to
> +tell the driver to search a specific band. If the &v4l2-tuner;
> +<structfield>capability</structfield> field has the
> +<constant>V4L2_TUNER_CAP_HWSEEK_PROG_LIM</constant> flag set, these values
> +must fall within one of the bands returned by &VIDIOC-ENUM-FREQ-BANDS;. If
> +the <constant>V4L2_TUNER_CAP_HWSEEK_PROG_LIM</constant> flag is not set,
> +then these values must exactly match those of one of the bands returned by
> +&VIDIOC-ENUM-FREQ-BANDS;.</para>

OK, I have some questions here:

1) If you have a multiband tuner, what should happen if both low and high are
zero? Currently it is undefined, other than that the seek should start from
the current frequency until it reaches some limit.

Halli, what does your hardware do? In particular, is the hwseek limited by the
US/Europe or Japan band range or can it do the full range? If I'm not mistaken
it is the former, right?

If it is the former, then you need to explicitly set low + high to ensure that
the hwseek uses the correct range because the driver can't guess which of the
overlapping bands to use.

2) What happens if the current frequency is outside the low/high range? The
hwseek spec says that the seek starts from the current frequency, so that might
mean that hwseek returns -ERANGE in this case.

Regards,

	Hans
