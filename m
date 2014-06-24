Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40422 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753248AbaFXO6M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 10:58:12 -0400
Date: Tue, 24 Jun 2014 15:57:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Denis Carikli <denis@eukrea.com>, dri-devel@lists.freedesktop.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v14 06/10] drm: drm_display_mode: add signal polarity
	flags
Message-ID: <20140624145745.GR32514@n2100.arm.linux.org.uk>
References: <1402913484-25910-1-git-send-email-denis@eukrea.com> <1402913484-25910-6-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402913484-25910-6-git-send-email-denis@eukrea.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 16, 2014 at 12:11:20PM +0200, Denis Carikli wrote:
> We need a way to pass signal polarity informations
>   between DRM panels, and the display drivers.
> 
> To do that, a pol_flags field was added to drm_display_mode.
> 
> Signed-off-by: Denis Carikli <denis@eukrea.com>

This patch needs an ack from the DRM people - can someone review it
please?  This series has now been round 14 revisions and it's about
time it was properly reviewed - or a statement made if it's
unacceptable.

> ---
> ChangeLog v13->v14:
> - Fixed DRM_MODE_FLAG_POL_DE_HIGH's description.
> ChangeLog v12->v13:
> - Added Docbook documentation for pol_flags the struct field.
> - Removed the _PRESERVE	defines: it was used by patches
>   against the imx_drm driver. Now theses patches have been
>   adapted not to require that defines.
> ChangeLog v11->v12:
> - Rebased: This patch now applies against drm_modes.h
> - Rebased: It now uses the new DRM_MODE_FLAG_POL_DE flags defines names
> 
> ChangeLog v10->v11:
> - Since the imx-drm won't be able to retrive its regulators
>   from the device tree when using display-timings nodes,
>   and that I was told that the drm simple-panel driver 
>   already supported that, I then, instead, added what was
>   lacking to make the eukrea displays work with the
>   drm-simple-panel driver.
> 
>   That required a way to get back the display polarity
>   informations from the imx-drm driver without affecting
>   userspace.
> ---
>  Documentation/DocBook/drm.tmpl |   30 ++++++++++++++++++++++++++++++
>  include/drm/drm_modes.h        |    6 ++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/Documentation/DocBook/drm.tmpl b/Documentation/DocBook/drm.tmpl
> index 7df3134..22d435f 100644
> --- a/Documentation/DocBook/drm.tmpl
> +++ b/Documentation/DocBook/drm.tmpl
> @@ -2292,6 +2292,36 @@ void intel_crt_init(struct drm_device *dev)
>              and <structfield>height_mm</structfield> fields are only used internally
>              during EDID parsing and should not be set when creating modes manually.
>            </para>
> +          <para>
> +            The <structfield>pol_flags</structfield> value represents the display
> +            signal polarity flags, it can be a combination of
> +            <variablelist>
> +              <varlistentry>
> +                <term>DRM_MODE_FLAG_POL_PIXDATA_NEGEDGE</term>
> +                 <listitem><para>
> +                     drive pixel data on falling edge, sample data on rising edge.
> +                 </para></listitem>
> +              </varlistentry>
> +              <varlistentry>
> +                <term>DRM_MODE_FLAG_POL_PIXDATA_POSEDGE</term>
> +                <listitem><para>
> +                  Drive pixel data on rising edge, sample data on falling edge.
> +                </para></listitem>
> +              </varlistentry>
> +              <varlistentry>
> +                <term>DRM_MODE_FLAG_POL_DE_LOW</term>
> +                <listitem><para>
> +                  data-enable pulse is active low
> +                </para></listitem>
> +              </varlistentry>
> +              <varlistentry>
> +                <term>DRM_MODE_FLAG_POL_DE_HIGH</term>
> +                <listitem><para>
> +                  data-enable pulse is active high
> +                </para></listitem>
> +              </varlistentry>
> +            </variablelist>
> +          </para>
>          </listitem>
>          <listitem>
>            <synopsis>int (*mode_valid)(struct drm_connector *connector,
> diff --git a/include/drm/drm_modes.h b/include/drm/drm_modes.h
> index 91d0582..c5cbe31 100644
> --- a/include/drm/drm_modes.h
> +++ b/include/drm/drm_modes.h
> @@ -93,6 +93,11 @@ enum drm_mode_status {
>  
>  #define DRM_MODE_FLAG_3D_MAX	DRM_MODE_FLAG_3D_SIDE_BY_SIDE_HALF
>  
> +#define DRM_MODE_FLAG_POL_PIXDATA_NEGEDGE	BIT(1)
> +#define DRM_MODE_FLAG_POL_PIXDATA_POSEDGE	BIT(2)
> +#define DRM_MODE_FLAG_POL_DE_LOW		BIT(3)
> +#define DRM_MODE_FLAG_POL_DE_HIGH		BIT(4)
> +
>  struct drm_display_mode {
>  	/* Header */
>  	struct list_head head;
> @@ -144,6 +149,7 @@ struct drm_display_mode {
>  	int vrefresh;		/* in Hz */
>  	int hsync;		/* in kHz */
>  	enum hdmi_picture_aspect picture_aspect_ratio;
> +	unsigned int pol_flags;
>  };
>  
>  /* mode specified on the command line */
> -- 
> 1.7.9.5
> 

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
