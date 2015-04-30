Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:33824 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbbD3KWT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 06:22:19 -0400
Received: by laat2 with SMTP id t2so40560470laa.1
        for <linux-media@vger.kernel.org>; Thu, 30 Apr 2015 03:22:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2a685cc104d1621c0519b35555d562f9d2d29cbd.1430222388.git.mchehab@osg.samsung.com>
References: <f35b661f37d4bcacaa5465465939b7f32869e48d.1430222388.git.mchehab@osg.samsung.com>
 <2a685cc104d1621c0519b35555d562f9d2d29cbd.1430222388.git.mchehab@osg.samsung.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 30 Apr 2015 11:21:47 +0100
Message-ID: <CA+V-a8uHygDaVjoTfsDw1fUTwU4nDkf5iQ-bhFneKRG-hs+ecA@mail.gmail.com>
Subject: Re: [PATCH 3/3] am437x: remove unused variable
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Benoit Parrot <bparrot@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 28, 2015 at 12:59 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> drivers/media/platform/am437x/am437x-vpfe.c: In function 'vpfe_get_subdev_input_index':
> drivers/media/platform/am437x/am437x-vpfe.c:1679:27: warning: variable 'sdinfo' set but not used [-Wunused-but-set-variable]
>   struct vpfe_subdev_info *sdinfo;
>                            ^
>
> Cc: Benoit Parrot <bparrot@ti.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
