Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38394 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1INDFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 23:05:54 -0400
Received: by bkbzt4 with SMTP id zt4so1132883bkb.19
        for <linux-media@vger.kernel.org>; Tue, 13 Sep 2011 20:05:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315938892-20243-2-git-send-email-scott.jiang.linux@gmail.com>
References: <1315938892-20243-1-git-send-email-scott.jiang.linux@gmail.com> <1315938892-20243-2-git-send-email-scott.jiang.linux@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 13 Sep 2011 23:05:33 -0400
Message-ID: <CAMjpGUc6cbcO-LtE=ZLXY5LkF_W8GCosyPkKW3P007ucBw-KzQ@mail.gmail.com>
Subject: Re: [uclinux-dist-devel] [PATCH 2/4] v4l2: add adv7183 decoder driver
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	uclinux-dist-devel@blackfin.uclinux.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 13, 2011 at 14:34, Scott Jiang wrote:
> --- /dev/null
> +++ b/drivers/media/video/adv7183_regs.h
>
> +#define        ADV7183_IN_CTRL            0x00 /* Input control */

should be a space after the #define, not a tab

> --- /dev/null
> +++ b/include/media/adv7183.h
>
> +#define        ADV7183_16BIT_OUT   1

same here
-mike
