Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62289 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964918Ab2LFHyW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2012 02:54:22 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so6019546oag.19
        for <linux-media@vger.kernel.org>; Wed, 05 Dec 2012 23:54:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353349642-3677-234-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu> <1353349642-3677-234-git-send-email-wfp5p@virginia.edu>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 6 Dec 2012 13:24:02 +0530
Message-ID: <CA+V-a8u05u-kZUtx758yJSkXGWfgxLEqXnd7G2gDB5hWwhuB=g@mail.gmail.com>
Subject: Re: [PATCH 234/493] media: remove use of __devinit
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: gregkh@linuxfoundation.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	mjpeg-users@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 19, 2012 at 11:53 PM, Bill Pemberton <wfp5p@virginia.edu> wrote:
> CONFIG_HOTPLUG is going away as an option so __devinit is no longer
> needed.
> ---
[Snip]
...
>  drivers/media/platform/davinci/dm355_ccdc.c        |  2 +-
>  drivers/media/platform/davinci/dm644x_ccdc.c       |  2 +-
>  drivers/media/platform/davinci/isif.c              |  2 +-
>  drivers/media/platform/davinci/vpbe.c              |  2 +-
>  drivers/media/platform/davinci/vpbe_display.c      |  6 ++---
>  drivers/media/platform/davinci/vpfe_capture.c      |  2 +-
>  drivers/media/platform/davinci/vpif.c              |  2 +-
>  drivers/media/platform/davinci/vpss.c              |  2 +-

Acked-by: Prabhakar Lad <prabhakar.lad@ti.com>

Regards,
--Prabhakar

> --
> 1.8.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
