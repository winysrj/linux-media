Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:59107 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2KWRBn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 12:01:43 -0500
Message-ID: <50AFABF6.3040501@mihu.de>
Date: Fri, 23 Nov 2012 18:01:42 +0100
From: Michael Hunold <michael@mihu.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: add tda9840, tea6415c and tea6420 entries.
References: <1353676231-5684-1-git-send-email-hverkuil@xs4all.nl> <802fc6c93c32effb499c09a9b6c6f3af57efdd83.1353675798.git.hans.verkuil@cisco.com>
In-Reply-To: <802fc6c93c32effb499c09a9b6c6f3af57efdd83.1353675798.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

on 23.11.2012 14:10 Hans Verkuil said the following:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  MAINTAINERS |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 76b1c1d..c25ade7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7412,6 +7412,14 @@ T:	git git://linuxtv.org/mkrufky/tuners.git
>  S:	Maintained
>  F:	drivers/media/tuners/tda8290.*
>  
> +TDA9840 MEDIA DRIVER
> +M:	Hans Verkuil <hverkuil@xs4all.nl>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +W:	http://linuxtv.org
> +S:	Maintained
> +F:	drivers/media/i2c/tda9840*
> +
>  TEA5761 TUNER DRIVER
>  M:	Mauro Carvalho Chehab <mchehab@redhat.com>
>  L:	linux-media@vger.kernel.org
> @@ -7428,6 +7436,22 @@ T:	git git://linuxtv.org/media_tree.git
>  S:	Maintained
>  F:	drivers/media/tuners/tea5767.*
>  
> +TEA6415C MEDIA DRIVER
> +M:	Hans Verkuil <hverkuil@xs4all.nl>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +W:	http://linuxtv.org
> +S:	Maintained
> +F:	drivers/media/i2c/tea6415c*
> +
> +TEA6420 MEDIA DRIVER
> +M:	Hans Verkuil <hverkuil@xs4all.nl>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +W:	http://linuxtv.org
> +S:	Maintained
> +F:	drivers/media/i2c/tea6420*
> +
>  TEAM DRIVER
>  M:	Jiri Pirko <jpirko@redhat.com>
>  L:	netdev@vger.kernel.org

these drivers belong to the "Multimedia eXtension Board" which is
saa7146 based, so:

Acked-by: Michael Hunold <michael@mihu.de>

CU
Michael.
