Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbZAMUmF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2009 15:42:05 -0500
Date: Tue, 13 Jan 2009 18:41:32 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	Sakari Ailus <sakari.ailus@nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	"Nagalla, Hari" <hnagalla@ti.com>
Subject: Re: [REVIEW PATCH 04/14] OMAP: CAM: Add ISP user header and
 register defs
Message-ID: <20090113184132.08bd5b20@pedra.chehab.org>
In-Reply-To: <A24693684029E5489D1D202277BE894416429F9A@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE894416429F9A@dlee02.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 12 Jan 2009 20:03:15 -0600
"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com> wrote:

> +/* ISP Private IOCTLs */
> +#define VIDIOC_PRIVATE_ISP_CCDC_CFG    \
> +       _IOWR('V', BASE_VIDIOC_PRIVATE + 1, struct ispccdc_update_config)
> +#define VIDIOC_PRIVATE_ISP_PRV_CFG \
> +       _IOWR('V', BASE_VIDIOC_PRIVATE + 2, struct ispprv_update_config)
> +#define VIDIOC_PRIVATE_ISP_AEWB_CFG \
> +       _IOWR('V', BASE_VIDIOC_PRIVATE + 4, struct isph3a_aewb_config)
> +#define VIDIOC_PRIVATE_ISP_AEWB_REQ \
> +       _IOWR('V', BASE_VIDIOC_PRIVATE + 5, struct isph3a_aewb_data)
> +#define VIDIOC_PRIVATE_ISP_HIST_CFG \
> +       _IOWR('V', BASE_VIDIOC_PRIVATE + 6, struct isp_hist_config)
> +#define VIDIOC_PRIVATE_ISP_HIST_REQ \
> +       _IOWR('V', BASE_VIDIOC_PRIVATE + 7, struct isp_hist_data)
> +#define VIDIOC_PRIVATE_ISP_AF_CFG \
> +       _IOWR('V', BASE_VIDIOC_PRIVATE + 8, struct af_configuration)
> +#define VIDIOC_PRIVATE_ISP_AF_REQ \
> +       _IOWR('V', BASE_VIDIOC_PRIVATE + 9, struct isp_af_data)

Are those new ioctl meant to be used by the userspace API? If so, we need to
understand each one, since maybe some of them make some sense to be in the
public API. Also, a proper documentation should be provided for all of those
ioctls.

Cheers,
Mauro
