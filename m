Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:48742 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbZGVGoW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 02:44:22 -0400
Date: Wed, 22 Jul 2009 08:44:11 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Brian Johnson <brijohn@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Add gspca sn9c20x subdriver entry to MAINTAINERS file
Message-ID: <20090722084411.44019897@tele>
In-Reply-To: <1248029936-6888-1-git-send-email-brijohn@gmail.com>
References: <1248029936-6888-1-git-send-email-brijohn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 19 Jul 2009 14:58:56 -0400
Brian Johnson <brijohn@gmail.com> wrote:

> Signed-off-by: Brian Johnson <brijohn@gmail.com>
> ---
>  MAINTAINERS |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 18c3f0c..a28944f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2599,6 +2599,14 @@ T:	git
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
> S:	Maintained F:	drivers/media/video/gspca/pac207.c
>  
> +GSPCA SN9C20X SUBDRIVER
> +P:	Brian Johnson
> +M:	brijohn@gmail.com
> +L:	linux-media@vger.kernel.org
> +T:	git
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
> +S:	Maintained +F:	drivers/media/video/gspca/sn9c20x.c
> +
>  GSPCA T613 SUBDRIVER
>  P:	Leandro Costantino
>  M:	lcostantino@gmail.com

Acked-by: Jean-Francois Moine <moinejf@free.fr>

-- 
Ken ar c'hentañ|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
