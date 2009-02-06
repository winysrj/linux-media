Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:54518 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbZBFC0Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2009 21:26:24 -0500
MIME-Version: 1.0
In-Reply-To: <A24693684029E5489D1D202277BE894416429FA1@dlee02.ent.ti.com>
References: <Acl1IyQQvIDQejCAQ5O/QnkHIBmt3w==>
	 <A24693684029E5489D1D202277BE894416429FA1@dlee02.ent.ti.com>
Date: Fri, 6 Feb 2009 11:26:23 +0900
Message-ID: <5e9665e10902051826k7863ea56v99bdff7ee429c832@mail.gmail.com>
Subject: Re: [REVIEW PATCH 11/14] OMAP34XXCAM: Add driver
From: DongSoo Kim <dongsoo.kim@gmail.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

This could be something trivial.

On Tue, Jan 13, 2009 at 11:03 AM, Aguirre Rodriguez, Sergio Alberto
<saaguirre@ti.com> wrote:
> +/**
> + * struct omap34xxcam_hw_config - struct for vidioc_int_g_priv ioctl
> + * @xclk: OMAP34XXCAM_XCLK_A or OMAP34XXCAM_XCLK_B
> + * @sensor_isp: Is sensor smart/SOC or raw
> + * @s_pix_sparm: Access function to set pix and sparm.
> + * Pix will override sparm
> + */
> +struct omap34xxcam_hw_config {
> +       int dev_index; /* Index in omap34xxcam_sensors */

I found "omap34xxcam_sensors" in your comment, but it couldn't found anywhere.
Let me guess that it means "omap34xxcam_videodev". Am I right?
Cheers.

Regards,
Nate
