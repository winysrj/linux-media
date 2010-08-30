Return-path: <mchehab@pedra>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:33709 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752147Ab0H3QbK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Aug 2010 12:31:10 -0400
Date: Mon, 30 Aug 2010 09:31:04 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
	Clemens Ladisch <clemens@ladisch.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] drm, video: fix use-before-NULL-check
Message-ID: <20100830093104.5aa22a0a@jbarnes-desktop>
In-Reply-To: <20100827210719.GD4703@outflux.net>
References: <20100827210719.GD4703@outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Fri, 27 Aug 2010 14:07:19 -0700
Kees Cook <kees.cook@canonical.com> wrote:

> Fix potential crashes due to use-before-NULL situations.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
>  drivers/gpu/drm/drm_fb_helper.c           |    3 ++-
>  drivers/media/video/em28xx/em28xx-video.c |    3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
> index de82e20..8dd7e6f 100644
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -94,10 +94,11 @@ static bool drm_fb_helper_connector_parse_command_line(struct drm_fb_helper_conn
>  	int i;
>  	enum drm_connector_force force = DRM_FORCE_UNSPECIFIED;
>  	struct drm_fb_helper_cmdline_mode *cmdline_mode;
> -	struct drm_connector *connector = fb_helper_conn->connector;
> +	struct drm_connector *connector;
>  
>  	if (!fb_helper_conn)
>  		return false;
> +	connector = fb_helper_conn->connector;
>  
>  	cmdline_mode = &fb_helper_conn->cmdline_mode;
>  	if (!mode_option)
> diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
> index 7b9ec6e..95a4b60 100644
> --- a/drivers/media/video/em28xx/em28xx-video.c
> +++ b/drivers/media/video/em28xx/em28xx-video.c
> @@ -277,12 +277,13 @@ static void em28xx_copy_vbi(struct em28xx *dev,
>  {
>  	void *startwrite, *startread;
>  	int  offset;
> -	int bytesperline = dev->vbi_width;
> +	int bytesperline;
>  
>  	if (dev == NULL) {
>  		em28xx_isocdbg("dev is null\n");
>  		return;
>  	}
> +	bytesperline = dev->vbi_width;
>  
>  	if (dma_q == NULL) {
>  		em28xx_isocdbg("dma_q is null\n");

Look fine to me.

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>


-- 
Jesse Barnes, Intel Open Source Technology Center
