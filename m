Return-Path: <SRS0=vP0A=OZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C72BC43387
	for <linux-media@archiver.kernel.org>; Sun, 16 Dec 2018 10:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F41A1217FA
	for <linux-media@archiver.kernel.org>; Sun, 16 Dec 2018 10:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbeLPKhL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 16 Dec 2018 05:37:11 -0500
Received: from mout.gmx.net ([212.227.17.22]:40213 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbeLPKhL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Dec 2018 05:37:11 -0500
Received: from mail.dobel.click ([87.188.252.140]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MZwYd-1gqxzD0Mb1-00Lm91; Sun, 16
 Dec 2018 11:37:04 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 16 Dec 2018 11:37:02 +0100
From:   Markus Dobel <markus.dobel@gmx.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org,
        linux-media-owner@vger.kernel.org
Subject: Re: [PATCH] Revert 95f408bb Ryzen DMA related RiSC engine stall fixes
Organization: Old Europe
In-Reply-To: <20181206160145.2d23ac0e@coco.lan>
References: <3d7393a6287db137a69c4d05785522d5@gmx.de>
 <20181205090721.43e7f36c@coco.lan>
 <96c74fe9-d48f-5249-1b17-a8046493b383@nextdimension.cc>
 <5528BC99-512E-4CEC-AE26-99D3991AB598@gmx.de>
 <20181206160145.2d23ac0e@coco.lan>
Message-ID: <8858694d5934ce78e46ef48d6f90061a@gmx.de>
X-Sender: markus.dobel@gmx.de
User-Agent: Roundcube Webmail/1.3.8
X-Provags-ID: V03:K1:oxAO3uM3UFch4CbCn3/NYfRQ9bo5sKIzxFQs11WtpDCy7k0YnsB
 mBemhwZpqntdCy8MLEn861gcSIp1fRzndfYzXF69ZHGL73Ur8KqMeXwevQ6rW2C2lM6pXGL
 RazOi/bci9ZJSjOsCd+kJRWsSUbdzi5zIRUz707lOOZooalfMfmUC0IlSttFeGOEKqUMAgW
 aAtX6TlJJ91qRuCbhMhFw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:i3wdfTwvK64=:7+QDJFKznnowNxmgp2Zt2G
 PP5ZGN7Hye+5XPXK560mGt1LL9qhrZ1A7NIEnlVgLhOPOp0FVH4wkkUGf4GSyGT39uVAEzakr
 iwli6yBn7WSHlfD6J/+hafzcquVJqqIT9MKchFYlqhrMPF/+vffUwW/AhaqWOTRn2zqz7ePcQ
 JGmDDskT8J/GFTQqUSPtQX3GVeYIzNKICdM9R3YlKiO9ArrYlnWMPRbeDLmuK0N6K6AFpEgXx
 3bLOC7eseGGqWVDZjWk227SluJldJ9XfOuD7ETF8/kZ6f1cfvuBOK7hMIbXz/Xi2aYlwSQkmf
 gAO4YJcgr7gnzaQT67OxA9p+rfqjH7xzsIPoKNhaEmvCdditFyb3AcsWghKL2vWaqoUAYzu6l
 TRDEfeFBLf0ZAm76+y1vM2U4jJcIkTkMKPOABewQDxm3rDjj/MMVJE3bBgUQTzlFMAL060YyH
 esjDPUBRBB1CzgO1w0tWaYZIT61Ou1cmGyBsgnh6F0VW67o8y9VTG4cSHRwJD8ZMYM8u1noXK
 /vqtveTrN9fsdGxpKXJI5r6h1w9OPq23hrA/nkQx41bXXUDwdJY4rg+nS8q4ypcXOhvJSrsvy
 0iOK7NBmL8Gq3KVrE33xFE3QrBuCnYglULM2kv9mOueLDO2vQ2ciAwK9u5HRAE7zeTQw3y7Lj
 DWbtatDiK0/KqqQvFezcAqFwsu+nC55r1LGYRNyhg6N+1fr4PKgfFyxxzoUJAEMqLuL7Mgvw7
 yE3aGm3O1zD/MPvVYx3FLZrXzs7J86FW0ptE+rp8HjCTtLSvjfePyBQ7j69qD8zcKJv7aT8gF
 Kk+wiUtuC5v11hDyCLedRYSZxhDvWPM3Hagqlv7dLHLXlJ5hezTFLJ2DDKojalfKa+wTNZBZ9
 wmbjwI25raEEwr+8QwHbOm5YBsYXRLeyd3K/ImBC1R+jYeVLP/zIKqyPz2JILi
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 06.12.2018 19:01, Mauro Carvalho Chehab wrote:
> Em Thu, 06 Dec 2018 18:18:23 +0100
> Markus Dobel <markus.dobel@gmx.de> escreveu:
> 
>> Hi everyone,
>> 
>> I will try if the hack mentioned fixes the issue for me on the weekend 
>> (but I assume, as if effectively removes the function).
> 
> It should, but it keeps a few changes. Just want to be sure that what
> would be left won't cause issues. If this works, the logic that would
> solve Ryzen DMA fixes will be contained into a single point, making
> easier to maintain it.

Hi,

I wanted to have this setup running stable for a few days before 
replying, that's why I am answering only now.

But yes, as expected, with Mauro's hack, the driver has been stable for 
me for about a week, with several
scheduled recordings in tvheadend, none of them missed.

So, adding a reliable detection for affected chipsets, where the `if 
(1)` currently is, should work.

Regards,
Markus
