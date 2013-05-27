Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:19572 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab3E0JEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 May 2013 05:04:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Diego Viola <diego.viola@gmail.com>
Subject: Re: [PATCH] Fix spelling of Qt in .desktop file (typo)
Date: Mon, 27 May 2013 11:03:59 +0200
Cc: linux-media@vger.kernel.org
References: <1369556151-4614-1-git-send-email-diego.viola@gmail.com>
In-Reply-To: <1369556151-4614-1-git-send-email-diego.viola@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201305271103.59617.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun 26 May 2013 10:15:51 Diego Viola wrote:
> Proper spelling of Qt is Qt, not QT.  "QT" is often confused with
> QuickTime, here is a minor patch to fix this issue in the .desktop file.

Thanks, I've committed this.

Regards,

	Hans

> 
> Signed-off-by: Diego Viola <diego.viola@gmail.com>
> ---
>  utils/qv4l2/qv4l2.desktop | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/utils/qv4l2/qv4l2.desktop b/utils/qv4l2/qv4l2.desktop
> index 00f3e33..69413e1 100644
> --- a/utils/qv4l2/qv4l2.desktop
> +++ b/utils/qv4l2/qv4l2.desktop
> @@ -1,5 +1,5 @@
>  [Desktop Entry]
> -Name=QT V4L2 test Utility
> +Name=Qt V4L2 test Utility
>  Name[pt]=Utilitário de teste V4L2
>  Comment=Allow testing Video4Linux devices
>  Comment[pt]=Permite testar dispositivos Video4Linux
> 
