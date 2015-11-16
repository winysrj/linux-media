Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35530 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbbKPLHA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 06:07:00 -0500
MIME-Version: 1.0
In-Reply-To: <1447452318-19028-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1447452318-19028-1-git-send-email-Julia.Lawall@lip6.fr>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Mon, 16 Nov 2015 11:06:28 +0000
Message-ID: <CA+V-a8twtHnGM-ycRjpyKb64E1G1tVh2w=3Oq-vGavrNS+Tx-g@mail.gmail.com>
Subject: Re: [PATCH] [media] i2c: constify v4l2_ctrl_ops structures
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 13, 2015 at 10:05 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> These v4l2_ctrl_ops structures are never modified, like all the other
> v4l2_ctrl_ops structures, so declare them as const.
>
> Done with the help of Coccinelle.
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
