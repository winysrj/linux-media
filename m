Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56317 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759862Ab2JYOTr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 10:19:47 -0400
Received: by mail-wi0-f172.google.com with SMTP id hq12so6037468wib.1
        for <linux-media@vger.kernel.org>; Thu, 25 Oct 2012 07:19:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121025114624.7896b5d9@redhat.com>
References: <1349473981-15084-1-git-send-email-fabio.estevam@freescale.com>
	<1349473981-15084-2-git-send-email-fabio.estevam@freescale.com>
	<20121025113841.4e06cc3b@redhat.com>
	<20121025114624.7896b5d9@redhat.com>
Date: Thu, 25 Oct 2012 12:19:45 -0200
Message-ID: <CAOMZO5APJsvV7yXsLYKMPOKHMJzDqE_89KTuS6sWzvHGMnaXfQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: clk-imx27: Add missing clock for mx2-camera
From: Fabio Estevam <festevam@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sascha Hauer <s.hauer@pengutronix.de>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, kernel@pengutronix.de,
	g.liakhovetski@gmx.de, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, javier.martin@vista-silicon.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha,

On Thu, Oct 25, 2012 at 11:46 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:

>> As this patch is for arch/arm, I'm understanding that it will be merged
>> via arm tree. So,
>>
>> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> Forgot to comment: as patch 2 relies on this change, the better, IMHO, is
> to send both via the same tree. If you decide to do so, please get arm
> maintainer's ack, instead, and we can merge both via my tree.

Can you please send your Ack to this series so that Mauro can merge it
via his tree?

Thanks,

Fabio Estevam
