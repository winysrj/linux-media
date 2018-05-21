Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway22.websitewelcome.com ([192.185.47.79]:28205 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753130AbeEUQTb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 12:19:31 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 489CDB620A
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 11:18:54 -0500 (CDT)
Subject: Re: [PATCH 01/11] media: tm6000: fix potential Spectre variant 1
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <3d4973141e218fb516422d3d831742d55aaa5c04.1524499368.git.gustavo@embeddedor.com>
 <20180423152455.363d285c@vento.lan>
 <3ab9c4c9-0656-a08e-740e-394e2e509ae9@embeddedor.com>
 <20180423161742.66f939ba@vento.lan>
 <99e158c0-1273-2500-da9e-b5ab31cba889@embeddedor.com>
 <20180426204241.03a42996@vento.lan>
 <df8010f1-6051-7ff4-5f0e-4a436e900ec5@embeddedor.com>
 <20180515085953.65bfa107@vento.lan> <20180515141655.idzuh2jfdkuu5grs@mwanda>
 <f342d8d6-b5e6-0cbf-d002-9561b79c90e4@embeddedor.com>
 <20180515193936.m25kzyeknsk2bo2c@mwanda>
 <0f31a60b-911d-0140-3546-98317e2a0557@embeddedor.com>
 <d34cf31f-6dc5-ee2d-ea6d-513dd5e8e5c3@embeddedor.com>
 <20180517083440.14e6b975@vento.lan> <20180517084324.3242c257@vento.lan>
 <20180517091340.7d8c62b2@vento.lan>
 <5921004a-a7d3-59c9-2ef4-b6a490390d3f@embeddedor.com>
Message-ID: <b3c23490-4113-c56f-8511-eea6cb054c48@embeddedor.com>
Date: Mon, 21 May 2018 11:18:52 -0500
MIME-Version: 1.0
In-Reply-To: <5921004a-a7d3-59c9-2ef4-b6a490390d3f@embeddedor.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/17/2018 01:08 PM, Gustavo A. R. Silva wrote:
> 
> BTW, Mauro, you sent a patch to fix an spectre v1 issue in this file 
> yesterday: dvb_ca_en50221.c:1480, but it seems there is another instance 
> of the same issue some lines above:
> 
> diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c 
> b/drivers/media/dvb-core/dvb_ca_en50221.c
> index 1310526..7edd9db 100644
> --- a/drivers/media/dvb-core/dvb_ca_en50221.c
> +++ b/drivers/media/dvb-core/dvb_ca_en50221.c
> @@ -1398,6 +1398,7 @@ static int dvb_ca_en50221_io_do_ioctl(struct file 
> *file,
> 
>                  info->type = CA_CI_LINK;
>                  info->flags = 0;
> +               slot = array_index_nospec(slot, ca->slot_count + 1);
>                  sl = &ca->slot_info[slot];
>                  if ((sl->slot_state != DVB_CA_SLOTSTATE_NONE) &&
>                      (sl->slot_state != DVB_CA_SLOTSTATE_INVALID)) {
> 
> 

Hi Mauro,

Just to let you know, I was running smatch during the weekend and the 
tool is still reporting all these Spectre media warnings (and a lot more):

https://patchwork.linuxtv.org/project/linux-media/list/?submitter=7277

Thanks
--
Gustavo
