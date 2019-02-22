Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46EE0C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 00:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A3A3207E0
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 00:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfBVArz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 19:47:55 -0500
Received: from mail-svr1.cs.utah.edu ([155.98.64.241]:56517 "EHLO
        mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfBVArz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 19:47:55 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail-svr1.cs.utah.edu (Postfix) with ESMTP id 6CDE86500C0;
        Thu, 21 Feb 2019 17:47:54 -0700 (MST)
Received: from mail-svr1.cs.utah.edu ([127.0.0.1])
        by localhost (mail-svr1.cs.utah.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JtVRTEwqXE11; Thu, 21 Feb 2019 17:47:54 -0700 (MST)
Received: from [192.168.3.5] (dhcp-155-97-238-209.usahousing.utah.edu [155.97.238.209])
        by smtps.cs.utah.edu (Postfix) with ESMTPSA id DC35B6500B5;
        Thu, 21 Feb 2019 17:47:53 -0700 (MST)
To:     linux-media@vger.kernel.org, mchehab@kernel.org,
        hverkuil-cisco@xs4all.nl, sakari.ailus@linux.intel.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From:   Shaobo He <shaobo@cs.utah.edu>
Subject: Never checked NULL pointer in drivers/media/v4l2-core/videobuf-core.c
Message-ID: <4cf23e03-bcb5-8d29-afc9-4ab532dfa477@cs.utah.edu>
Date:   Thu, 21 Feb 2019 17:47:52 -0700
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

I found that macro `CALLPTR` in drivers/media/v4l2-core/videobuf-core.c can 
evaluate to NULL yet all its usages (__videobuf_copy_to_user, 
__videobuf_copy_stream) are never NULL checked. I doubt but am not completely 
sure that use cases of the CALLPTR macro can accept NULL pointers. Please let me 
know if it makes sense or not.

Best,
Shaobo
