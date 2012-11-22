Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51638 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab2KVUCi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 15:02:38 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so8339781oag.19
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2012 12:02:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353349642-3677-133-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu> <1353349642-3677-133-git-send-email-wfp5p@virginia.edu>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 22 Nov 2012 16:50:38 +0530
Message-ID: <CA+V-a8sT2DrF0+HTDhe7_2JEbpxC79y8ayfLb-t3ovTchVXvzg@mail.gmail.com>
Subject: Re: [PATCH 133/493] remove use of __devexit_p
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: gregkh@linuxfoundation.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 19, 2012 at 11:51 PM, Bill Pemberton <wfp5p@virginia.edu> wrote:
> CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
> needed.
>
[snip]

>  drivers/media/platform/davinci/dm355_ccdc.c              | 2 +-
>  drivers/media/platform/davinci/dm644x_ccdc.c             | 2 +-
>  drivers/media/platform/davinci/isif.c                    | 2 +-
>  drivers/media/platform/davinci/vpbe_display.c            | 2 +-
>  drivers/media/platform/davinci/vpfe_capture.c            | 2 +-
>  drivers/media/platform/davinci/vpif.c                    | 2 +-
>  drivers/media/platform/davinci/vpss.c                    | 2 +-

Acked-by: Prabhakar Lad <prabhakar.lad@ti.com>
