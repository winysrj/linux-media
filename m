Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:34518 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbbD3KYo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2015 06:24:44 -0400
Received: by laat2 with SMTP id t2so40601245laa.1
        for <linux-media@vger.kernel.org>; Thu, 30 Apr 2015 03:24:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f35b661f37d4bcacaa5465465939b7f32869e48d.1430222388.git.mchehab@osg.samsung.com>
References: <f35b661f37d4bcacaa5465465939b7f32869e48d.1430222388.git.mchehab@osg.samsung.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Thu, 30 Apr 2015 11:24:13 +0100
Message-ID: <CA+V-a8s_WjUT9VOD_P_mBYx-qFqFZVFBB8d-zuxSVm8sJGQsSw@mail.gmail.com>
Subject: Re: [PATCH 1/3] am437x-vpfe: really update the vpfe_ccdc_update_raw_params
 data
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Benoit Parrot <bparrot@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 28, 2015 at 12:59 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> drivers/media/platform/am437x/am437x-vpfe.c: In function 'vpfe_ccdc_update_raw_params':
> drivers/media/platform/am437x/am437x-vpfe.c:430:38: warning: variable 'config_params' set but not used [-Wunused-but-set-variable]
>   struct vpfe_ccdc_config_params_raw *config_params =
>                                       ^
>
> vpfe_ccdc_update_raw_params() is supposed to update the raw
> params at ccdc. However, it is just creating a local var and changing
> it.
>
> Compile-tested only.
>
> Cc: Benoit Parrot <bparrot@ti.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
