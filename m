Return-Path: <SRS0=8CHB=RF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0719AC43381
	for <linux-media@archiver.kernel.org>; Sat,  2 Mar 2019 20:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D419820836
	for <linux-media@archiver.kernel.org>; Sat,  2 Mar 2019 20:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfCBUWw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 2 Mar 2019 15:22:52 -0500
Received: from mail-svr1.cs.utah.edu ([155.98.64.241]:44602 "EHLO
        mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfCBUWw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2019 15:22:52 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail-svr1.cs.utah.edu (Postfix) with ESMTP id 399476500B9;
        Sat,  2 Mar 2019 13:22:51 -0700 (MST)
Received: from mail-svr1.cs.utah.edu ([127.0.0.1])
        by localhost (mail-svr1.cs.utah.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8v1UqtCHOx5r; Sat,  2 Mar 2019 13:22:50 -0700 (MST)
Received: from [192.168.3.5] (dhcp-155-97-238-209.usahousing.utah.edu [155.97.238.209])
        by smtps.cs.utah.edu (Postfix) with ESMTPSA id D5D7D6500B5;
        Sat,  2 Mar 2019 13:22:50 -0700 (MST)
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From:   Shaobo He <shaobo@cs.utah.edu>
Subject: Question about drivers/media/usb/uvc/uvc_v4l2.c
Message-ID: <8479deae-dedb-b7d2-58b7-8ff91f265eab@cs.utah.edu>
Date:   Sat, 2 Mar 2019 13:22:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello everyone,

This is Shaobo from Utah again. I've been bugging the mailing list with my 
patches. I have a quick question about a function in 
`drivers/media/usb/uvc/uvc_v4l2.c`. In `uvc_v4l2_try_format`, can 
`stream->nformats` be 0? I saw that in other files, this field could be zero 
which is considered as error cases. I was wondering if it's true for this 
function, too.

Thanks,
Shaobo
