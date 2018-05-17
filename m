Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.51.251]:15688 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751664AbeEQKgI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 06:36:08 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 6BE35C73B
        for <linux-media@vger.kernel.org>; Thu, 17 May 2018 05:36:06 -0500 (CDT)
Subject: Re: [PATCH 01/11] media: tm6000: fix potential Spectre variant 1
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
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
Message-ID: <d34cf31f-6dc5-ee2d-ea6d-513dd5e8e5c3@embeddedor.com>
Date: Thu, 17 May 2018 05:36:03 -0500
MIME-Version: 1.0
In-Reply-To: <0f31a60b-911d-0140-3546-98317e2a0557@embeddedor.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/16/2018 08:14 PM, Gustavo A. R. Silva wrote:
> 
> 
> On 05/15/2018 02:39 PM, Dan Carpenter wrote:
>>> Dan,
>>>
>>> These are all the Spectre media issues I see smatch is reporting in
>>> linux-next-20180515:
>>>
>>> drivers/media/cec/cec-pin-error-inj.c:170 cec_pin_error_inj_parse_line()
>>> warn: potential spectre issue 'pin->error_inj_args'
>>> drivers/media/dvb-core/dvb_ca_en50221.c:1479 
>>> dvb_ca_en50221_io_write() warn:
>>> potential spectre issue 'ca->slot_info' (local cap)
>>> drivers/media/dvb-core/dvb_net.c:252 handle_one_ule_extension() warn:
>>> potential spectre issue 'p->ule_next_hdr'
>>>
>>> I pulled the latest changes from the smatch repository and compiled it.
>>>
>>> I'm running smatch v0.5.0-4459-g2f66d40 now. Is this the latest version?
>>>
>>> I wonder if there is anything I might be missing.
>>>
>>
>> You'd need to rebuild the db (possibly twice but definitely once).
>>
> 
> Hi Dan,
> 
> After rebuilding the db (once), these are all the Spectre media warnings 
> I get:
> 
> drivers/media/pci/ddbridge/ddbridge-core.c:233 ddb_redirect() warn: 
> potential spectre issue 'ddbs'
> drivers/media/pci/ddbridge/ddbridge-core.c:243 ddb_redirect() warn: 
> potential spectre issue 'pdev->port'
> drivers/media/pci/ddbridge/ddbridge-core.c:252 ddb_redirect() warn: 
> potential spectre issue 'idev->input'
> drivers/media/dvb-core/dvb_ca_en50221.c:1400 
> dvb_ca_en50221_io_do_ioctl() warn: potential spectre issue 
> 'ca->slot_info' (local cap)
> drivers/media/dvb-core/dvb_ca_en50221.c:1479 dvb_ca_en50221_io_write() 
> warn: potential spectre issue 'ca->slot_info' (local cap)
> drivers/media/dvb-core/dvb_net.c:252 handle_one_ule_extension() warn: 
> potential spectre issue 'p->ule_next_hdr'
> drivers/media/dvb-core/dvb_net.c:1483 dvb_net_do_ioctl() warn: potential 
> spectre issue 'dvbnet->device' (local cap)
> drivers/media/cec/cec-pin-error-inj.c:170 cec_pin_error_inj_parse_line() 
> warn: potential spectre issue 'pin->error_inj_args'
> 
> I just want to double check if you are getting the same output. In case 
> you are getting the same, then what Mauro commented about these issues:
> 
> https://patchwork.linuxtv.org/project/linux-media/list/?submitter=7277
> 
> being resolved by commit 3ad3b7a2ebaefae37a7eafed0779324987ca5e56 seems 
> to be correct.
> 

Interesting, I've rebuild the db twice and now I get a total of 75 
Spectre warnings in drivers/media

--
Gustavo
