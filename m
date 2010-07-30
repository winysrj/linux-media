Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:37244 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab0G3Nmr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 09:42:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sergio Aguirre <saaguirre@ti.com>
Subject: Re: [media-ctl PATCH 1/3] Create initial .gitignore file
Date: Fri, 30 Jul 2010 15:42:38 +0200
Cc: linux-media@vger.kernel.org
References: <1279124246-12187-1-git-send-email-saaguirre@ti.com> <1279124246-12187-2-git-send-email-saaguirre@ti.com>
In-Reply-To: <1279124246-12187-2-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007301542.38731.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

Thanks for the patch, and sorry for the delay. Applied.

On Wednesday 14 July 2010 18:17:24 Sergio Aguirre wrote:
> The idea of this file is to ignore build generated files, and also
> the "standard" patches subfolder, used by quilt for example.
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  .gitignore |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>  create mode 100644 .gitignore
> 
> diff --git a/.gitignore b/.gitignore
> new file mode 100644
> index 0000000..1e56cf5
> --- /dev/null
> +++ b/.gitignore
> @@ -0,0 +1,4 @@
> +*.o
> +media-ctl
> +
> +patches/*

-- 
Regards,

Laurent Pinchart
