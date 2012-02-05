Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:42742 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840Ab2BEMqa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Feb 2012 07:46:30 -0500
Received: by obcva7 with SMTP id va7so5851028obc.19
        for <linux-media@vger.kernel.org>; Sun, 05 Feb 2012 04:46:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328226891-8968-11-git-send-email-sakari.ailus@iki.fi>
References: <20120202235231.GC841@valkosipuli.localdomain>
	<1328226891-8968-11-git-send-email-sakari.ailus@iki.fi>
Date: Sun, 5 Feb 2012 18:16:30 +0530
Message-ID: <CA+V-a8vvtr=XzpCEQjbsDP3RTenxPpvFHQMFFdS3BA0F_UFo7g@mail.gmail.com>
Subject: Re: [PATCH v2 11/31] v4l: Document raw bayer 4CC codes
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari,

Thanks for the patch.

On 2/3/12, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Document guidelines how 4CC codes should be named. Only raw bayer is
> included currently. Other formats should be documented later on.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/video4linux/4CCs.txt |   32 ++++++++++++++++++++++++++++++++
>  1 files changed, 32 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/video4linux/4CCs.txt
>
> diff --git a/Documentation/video4linux/4CCs.txt
> b/Documentation/video4linux/4CCs.txt
> new file mode 100644
> index 0000000..bb4a97d
> --- /dev/null
> +++ b/Documentation/video4linux/4CCs.txt
> @@ -0,0 +1,32 @@
> +Guidelines for Linux4Linux pixel format 4CCs
> +============================================
> +
> +Guidelines for Video4Linux 4CC codes defined using v4l2_fourcc() are
> +specified in this document. First of the characters defines the nature of
> +the pixel format, compression and colour space. The interpretation of the
> +other three characters depends on the first one.
> +
> +Existing 4CCs may not obey these guidelines.
> +
> +Formats
> +=======
> +
> +Raw bayer
> +---------
> +
> +The following first charcters are used by raw bayer formats:
   A small spelling mistake 'charcters', just pointing out since its a
documentation file :-)

Regards,
--Prabhakar Lad

> +
> +	B: raw bayer, uncompressed
> +	b: raw bayer, DPCM compressed
> +	a: A-law compressed
> +	u: u-law compressed
> +
> +2nd character: pixel order
> +	B: BGGR
> +	G: GBRG
> +	g: GRBG
> +	R: RGGB
> +
> +3rd character: uncompressed bits-per-pixel 0--9, A--
> +
> +4th character: compressed bits-per-pixel 0--9, A--
> --
> 1.7.2.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
