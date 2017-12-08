Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.107]:36570 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752562AbdLHWCD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 17:02:03 -0500
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 8B7713231C2
        for <linux-media@vger.kernel.org>; Fri,  8 Dec 2017 15:40:53 -0600 (CST)
Date: Fri, 08 Dec 2017 15:40:53 -0600
Message-ID: <20171208154053.Horde.CXiWmPSkKLcMobpu2XjAujZ@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linuxtv-commits@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [git:media_tree/master] media: davinci: vpif_capture: add NULL
 check on devm_kzalloc return value
In-Reply-To: <E1eNLWx-0000ZC-IM@www.linuxtv.org>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Quoting Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> This is an automatic generated email to let you know that the  
> following patch were queued:
>
> Subject: media: davinci: vpif_capture: add NULL check on  
> devm_kzalloc return value
> Author:  Gustavo A. R. Silva <garsilva@embeddedor.com>
> Date:    Wed Nov 22 22:34:44 2017 -0500
>
> Check return value from call to devm_kzalloc() in order to prevent
> a NULL pointer dereference.
>
> This issue was detected with the help of Coccinelle.
>
> Fixes: 4a5f8ae50b66 ("[media] davinci: vpif_capture: get subdevs  
> from DT when available")
>
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>

Thank you, Hans and Mauro for reviewing my patches.

I wonder if the following patch managed to resolved the use-after-free bug:

https://patchwork.linuxtv.org/patch/45391/

Thanks!
--
Gustavo A. R. Silva
