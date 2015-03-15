Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38337 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbbCOTME (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 15:12:04 -0400
Received: by wifj2 with SMTP id j2so26315279wif.1
        for <linux-media@vger.kernel.org>; Sun, 15 Mar 2015 12:12:03 -0700 (PDT)
Message-ID: <5505D981.5040704@googlemail.com>
Date: Sun, 15 Mar 2015 20:12:01 +0100
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

> diff --git a/lib/libv4l-exynos4-camera/Makefile.am b/lib/libv4l-exynos4-camera/Makefile.am
> new file mode 100644
> index 0000000..23c60c6
> --- /dev/null
> +++ b/lib/libv4l-exynos4-camera/Makefile.am
> @@ -0,0 +1,7 @@
> +if WITH_V4L_PLUGINS
> +libv4l2plugin_LTLIBRARIES = libv4l-exynos4-camera.la
> +endif
> +
> +libv4l_exynos4_camera_la_SOURCES = libv4l-exynos4-camera.c ../../utils/media-ctl/libmediactl.c ../../utils/media-ctl/libv4l2subdev.c ../../utils/media-ctl/libv4l2media_ioctl.c ../../utils/media-ctl/mediatext.c
> +libv4l_exynos4_camera_la_CFLAGS = -fvisibility=hidden -std=gnu99

Please use $(CFLAG_VISIBILITY) instead of -fvisibility=hidden. Also c99
is default. If you don't need GNU extensions, please drop the -std=gnu99.

Thanks,
Gregor
