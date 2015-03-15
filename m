Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36352 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbbCOTHf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 15:07:35 -0400
Received: by wibg7 with SMTP id g7so22547748wib.1
        for <linux-media@vger.kernel.org>; Sun, 15 Mar 2015 12:07:33 -0700 (PDT)
Message-ID: <5505D874.4060004@googlemail.com>
Date: Sun, 15 Mar 2015 20:07:32 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-media@vger.kernel.org
CC: hdegoede@redhat.com, hans.verkuil@cisco.com,
	b.zolnierkie@samsung.com, kyungmin.park@samsung.com,
	sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH/RFC v4 11/11] Add a libv4l plugin for Exynos4 camera
References: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com> <1416586480-19982-12-git-send-email-j.anaszewski@samsung.com>
In-Reply-To: <1416586480-19982-12-git-send-email-j.anaszewski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/11/14 17:14, Jacek Anaszewski wrote:

> diff --git a/lib/Makefile.am b/lib/Makefile.am
> index 3a0e19c..56b3a9f 100644
> --- a/lib/Makefile.am
> +++ b/lib/Makefile.am
> @@ -5,7 +5,12 @@ SUBDIRS = \
>  	libv4l2rds \
>  	libv4l-mplane
>  
> +if WITH_V4LUTILS
> +SUBDIRS += \
> +	libv4l-exynos4-camera
> +endif

Why do you depend on WITH_V4LUTILS for a libv4l plugin? This looks
wrong. WITH_V4LUTILS is intended to only switch off the utilities in
utils (see root Makefile.am).

Thanks,
Gregor
