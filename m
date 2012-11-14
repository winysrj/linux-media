Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61242 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab2KNSWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 13:22:42 -0500
Received: by mail-wi0-f178.google.com with SMTP id hm14so449723wib.1
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2012 10:22:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121031095702.41649bf9@infradead.org>
References: <1351598606-8485-1-git-send-email-fabio.estevam@freescale.com>
	<1351598606-8485-2-git-send-email-fabio.estevam@freescale.com>
	<20121031095702.41649bf9@infradead.org>
Date: Wed, 14 Nov 2012 16:22:40 -0200
Message-ID: <CAOMZO5BFZHWzsKF0mr2h0SRGxEdbz3J+fDEiOqY1BmfGCiCE9A@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] mx2_camera: Fix regression caused by clock conversion
From: Fabio Estevam <festevam@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, g.liakhovetski@gmx.de,
	kernel@pengutronix.de, gcembed@gmail.com,
	javier.martin@vista-silicon.com, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha,

On Wed, Oct 31, 2012 at 9:57 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:

> As it seems that those patches depend on some patches at the arm tree,
> the better is to merge them via -arm tree.
>
> So,
>
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Could you please apply this series via your tree?

Thanks,

Fabio Estevam
