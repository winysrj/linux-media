Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B4E1C43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3BE020656
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 08:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfAOIzD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 03:55:03 -0500
Received: from shell.v3.sk ([90.176.6.54]:51303 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfAOIzD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 03:55:03 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id BFE454CD04;
        Tue, 15 Jan 2019 09:55:00 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id QDI1Fe3PvacR; Tue, 15 Jan 2019 09:54:54 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id ED34B4CC77;
        Tue, 15 Jan 2019 09:54:53 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4Vi8Rk1j4g4h; Tue, 15 Jan 2019 09:54:53 +0100 (CET)
Received: from belphegor.brq.redhat.com (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id B024B4B474;
        Tue, 15 Jan 2019 09:54:52 +0100 (CET)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/5] ov7670 fixes
Date:   Tue, 15 Jan 2019 09:54:43 +0100
Message-Id: <20190115085448.1400135-1-lkundrak@v3.sk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

here are the ov7670 patches originally from the "media: make Marvell came=
ra
work on DT-based OLPC XO-1.75" updated to apply cleanly on top of
<git://linuxtv.org/sailus/media_tree.git> master as requested.

I've also added "ov7670: Remove useless use of a ret variable" with my Ac=
k
slapped on it.

Lubo



