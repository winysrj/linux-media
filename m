Return-Path: <SRS0=WxzW=ON=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC136C04EB8
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 20:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89CB120850
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 20:28:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89CB120850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=free.fr
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbeLDU2B (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 4 Dec 2018 15:28:01 -0500
Received: from lns-bzn-25-82-254-177-192.adsl.proxad.net ([82.254.177.192]:56151
        "EHLO maze.fork.zz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725855AbeLDU2B (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2018 15:28:01 -0500
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Dec 2018 15:28:01 EST
Received: from over.fork.zz (over.fork.zz [192.168.0.155])
        by maze.fork.zz (8.15.2/8.15.2) with ESMTPS id wB4KKasr001178
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-media@vger.kernel.org>; Tue, 4 Dec 2018 21:20:36 +0100
Received: from over.fork.zz (localhost [127.0.0.1])
        by over.fork.zz (8.15.2/8.15.2) with ESMTPS id wB4KKZVb024327
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <linux-media@vger.kernel.org>; Tue, 4 Dec 2018 21:20:35 +0100
Received: (from patrick@localhost)
        by over.fork.zz (8.15.2/8.15.2/Submit) id wB4KKYhp024326
        for linux-media@vger.kernel.org; Tue, 4 Dec 2018 21:20:34 +0100
From:   patrick9876@free.fr
To:     linux-media@vger.kernel.org
Subject: [PATCH] Add ir-rcmm-driver
Date:   Tue,  4 Dec 2018 21:20:24 +0100
Message-Id: <20181204202025.24279-1-patrick9876@free.fr>
X-Mailer: git-send-email 2.19.2
Reply-To: patrick9876@free.fr
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add support for RCMM infrared remote controls.

