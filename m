Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,TVD_SPACE_RATIO,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25EC7C04EB8
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 00:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCFD320834
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 00:29:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCFD320834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=free.fr
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbeLEA3m (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 4 Dec 2018 19:29:42 -0500
Received: from lns-bzn-25-82-254-177-192.adsl.proxad.net ([82.254.177.192]:57205
        "EHLO maze.fork.zz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725904AbeLEA3l (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2018 19:29:41 -0500
Received: from over.fork.zz (over.fork.zz [192.168.0.155])
        by maze.fork.zz (8.15.2/8.15.2) with ESMTPS id wB50Td7f002527
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Dec 2018 01:29:39 +0100
Received: from over.fork.zz (localhost [127.0.0.1])
        by over.fork.zz (8.15.2/8.15.2) with ESMTPS id wB50TcPE020919
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 5 Dec 2018 01:29:38 +0100
Received: (from patrick@localhost)
        by over.fork.zz (8.15.2/8.15.2/Submit) id wB50Ta7t020918;
        Wed, 5 Dec 2018 01:29:36 +0100
From:   patrick9876@free.fr
To:     linux-media@vger.kernel.org
Cc:     sean@mess.org, linux-media-owner@vger.kernel.org
Subject: [PATCHv2] Add ir-rcmm-driver
Date:   Wed,  5 Dec 2018 01:29:32 +0100
Message-Id: <20181205002933.20870-1-patrick9876@free.fr>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <c44581638d2525bc383a75413259f708@free.fr>
References: <c44581638d2525bc383a75413259f708@free.fr>
Reply-To: patrick9876@free.fr
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Fix typo RC_PROTO_BIT_RCMM issue.

