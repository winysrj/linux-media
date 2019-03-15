Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C481BC43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 12:15:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 937E52186A
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 12:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbfCOMPQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 08:15:16 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4688 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727441AbfCOMPQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 08:15:16 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id AB5016800BE5C84EED1F;
        Fri, 15 Mar 2019 20:15:13 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.408.0; Fri, 15 Mar 2019
 20:15:10 +0800
Subject: Re: [PATCH v2] staging: davinci: drop pointless static qualifier in
 vpfe_resizer_init()
To:     Dan Carpenter <dan.carpenter@oracle.com>
References: <20190311143739.132064-1-maowenan@huawei.com>
 <20190311143551.GH2434@kadam>
CC:     <gregkh@linuxfoundation.org>, <Julia.Lawall@lip6.fr>,
        <kimbrownkd@gmail.com>, <colin.king@canonical.com>,
        <hans.verkuil@cisco.com>, <linux-media@vger.kernel.org>,
        <devel@driverdev.osuosl.org>, <kernel-janitors@vger.kernel.org>
From:   maowenan <maowenan@huawei.com>
Message-ID: <747c791f-9aed-8c68-8e76-1b48594418ac@huawei.com>
Date:   Fri, 15 Mar 2019 20:15:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190311143551.GH2434@kadam>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Ping...
Thank you.

On 2019/3/11 22:35, Dan Carpenter wrote:
> Thanks!
> 
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> regards,
> dan carpenter
> 
> 
> 

