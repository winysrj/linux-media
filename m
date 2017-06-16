Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.149.4]:13695 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751644AbdFPCVG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Jun 2017 22:21:06 -0400
Received: from cm15.websitewelcome.com (cm15.websitewelcome.com [100.42.49.9])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id A7E7D233D4
        for <linux-media@vger.kernel.org>; Thu, 15 Jun 2017 20:57:36 -0500 (CDT)
Date: Thu, 15 Jun 2017 20:57:36 -0500
Message-ID: <20170615205736.Horde.S1fREUR1Jdb2BaFvmp4ZiEO@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linuxtv-commits@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [git:media_tree/master] [media] s3c-camif: fix arguments
 position in a function call
In-Reply-To: <E1dKs0y-0002Hq-Vp@www.linuxtv.org>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Quoting Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> This is an automatic generated email to let you know that the  
> following patch were queued:
>
> Subject: [media] s3c-camif: fix arguments position in a function call
> Author:  Gustavo A. R. Silva <garsilva@embeddedor.com>
> Date:    Fri Jun 2 00:43:41 2017 -0300
>
> Fix the position of arguments so camif->colorfx_cb, camif->colorfx_cr
> are passed in proper order to the camif_hw_set_effect() function.
>
> Addresses-Coverity-ID: 1248800
> Addresses-Coverity-ID: 1269141
>
> [s.nawrocki@samsung.com: edited commit message ]

Thank you for your editing of the commit message. I will elaborate  
further in future patches.

Best regards.
--
Gustavo A. R. Silva
