Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36275 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbcGMNtH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 09:49:07 -0400
Received: by mail-wm0-f66.google.com with SMTP id x83so5930045wma.3
        for <linux-media@vger.kernel.org>; Wed, 13 Jul 2016 06:48:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467874102-28365-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1467039471-19416-2-git-send-email-sakari.ailus@linux.intel.com> <1467874102-28365-1-git-send-email-sakari.ailus@linux.intel.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 13 Jul 2016 14:47:48 +0100
Message-ID: <CA+V-a8vZ1i=JCy8PRkhzC0ii+nR2ipGtZp6QosSUJdBPycgtfw@mail.gmail.com>
Subject: Re: [PATCH v2.2 09/10] v4l: 16-bit BGGR is always 16 bits
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Benoit Parrot <bparrot@ti.com>, Sekhar Nori <nsekhar@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 7, 2016 at 7:48 AM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> The V4L2_PIX_FMT_SBGGR16 format is documented to contain samples of fewer
> than 16 bits. However, we do have specific definitions for smaller sample
> sizes. Therefore, this note is redundant from the API point of view.
>
> Currently only two drivers, am437x and davinci, use the V4L2_PIX_FMT_SBGGR16
> pixelformat currently. The sampling precision is understood to be 16 bits in
> all current cases.
>
> Remove the note on sampling precision.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

>  Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml b/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
> index 6494b05..789160565 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-sbggr16.xml
> @@ -14,9 +14,7 @@
>  linkend="V4L2-PIX-FMT-SBGGR8">
>  <constant>V4L2_PIX_FMT_SBGGR8</constant></link>, except each pixel has
>  a depth of 16 bits. The least significant byte is stored at lower
> -memory addresses (little-endian). Note the actual sampling precision
> -may be lower than 16 bits, for example 10 bits per pixel with values
> -in range 0 to 1023.</para>
> +memory addresses (little-endian).</para>
>
>      <example>
>        <title><constant>V4L2_PIX_FMT_SBGGR16</constant> 4 &times; 4
> --
> 2.7.4
>
