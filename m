Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06D2C282C4
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 03:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE4032190A
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 03:03:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=candragon.net header.i=@candragon.net header.b="pQXZS4yd";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SfkFjcov"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390408AbfBMDDd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 22:03:33 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38013 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390017AbfBMDDc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 22:03:32 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E9B74221EE;
        Tue, 12 Feb 2019 22:03:30 -0500 (EST)
Received: from web2 ([10.202.2.212])
  by compute6.internal (MEProxy); Tue, 12 Feb 2019 22:03:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=candragon.net;
         h=message-id:from:to:cc:mime-version:content-transfer-encoding
        :content-type:subject:date; s=fm1; bh=ekxEvDiCWM7HfNLYX07f3dFtvd
        3MdBRPQeQNymBRjI8=; b=pQXZS4ydDVp+afdlgcZ3O6RNgyfkCTvBtxcYbb39KB
        s+fi5qzTAexbTGd+0vtV19/n+anosUl2OmfqwhsmpyXcuMorpI7G3XP3m4oOlKRy
        p7t3fkHhCmxPPqcVHxjDWwySRvb3cbEFPjrMsWAVzqMMeJ9PvlZZCamo/dO8SYml
        +79AO4xY149SAaKycRPwOyG8uK2lRa3GpPClCNtAS2z46IW136SoiyqCtYzQfqSX
        B3z6kCzCrAs5n9eIf/rXtDDyp/MvX1pA7d/8OTrqFzSfdQ4hBAjGy5goxjCdEOwv
        oCgOInHmTFbvs+1p3LNNugKfK56QhjzqEShPypHBauvg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ekxEvD
        iCWM7HfNLYX07f3dFtvd3MdBRPQeQNymBRjI8=; b=SfkFjcov/DnArgxd8i9sTr
        +bfQmKMMkDCWMBWVKQddlxC03r3q3GcsqJdCljbtYqqW2LFzQmadw1Xyiq7bnWVr
        HV9cur4COSLfKzln7SLlTGX/t2WKixJUTxcYotQZsP7VTIeKNRvVWe/UFtAOASZw
        K+BMfVFM1wiw9RChD+cG7mnH1bzLBdpv33LSzQPD/WMBwZ1+FEcD7ayQ2Ys+pqeA
        K7K0DEyMQXc1WgCX9zq1d3EQGaqPQejs40TkY2vWw0jZrHrDlDMD2TG8byE9Igv5
        0zLvBluSvnh8kRVtEzRrMKp+gEQ3slPwokstYUZCLn+UXlBM21P9vQNIPuX0Ysew
        ==
X-ME-Sender: <xms:AoljXEdKnGLR1Ml92jW95fdKONS5uZMsgf2uvfUYPcGg8M75e92Gxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledruddtvddgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfquhhtnecuuegrihhlohhuthemucef
    tddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkhffvggfgtg
    foufffsehtjeertdertdejnecuhfhrohhmpeforghrkhcukghimhhmvghrmhgrnhcuoehm
    rghrkhestggrnhgurhgrghhonhdrnhgvtheqnecuffhomhgrihhnpehkvghrnhgvlhdroh
    hrghdprghrtghhlhhinhhugidrohhrghenucfrrghrrghmpehmrghilhhfrhhomhepmhgr
    rhhksegtrghnughrrghgohhnrdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:AoljXPiWbqXpWMwjIuNYUMokRL4ImZv5N5RQLeryrSjz1uPeocEmRg>
    <xmx:AoljXERi1naAJ_yHgjstLa3588N8YmoHujC0kPqn6H8fpsJsezHXFA>
    <xmx:AoljXE8_HsIUsdTkOYZSszsaO-i0O6NCOyLzAPQFio_1DUsp5CKpoA>
    <xmx:AoljXDjW_RiX76JLeUNLcum1hJ_NAX-bFparMhhUN0HKRH7L009Hfg>
Received: by mailuser.nyi.internal (Postfix, from userid 99)
        id 2FE8A6230E; Tue, 12 Feb 2019 22:03:30 -0500 (EST)
Message-Id: <1550027010.2460608.1656864112.3A25F771@webmail.messagingengine.com>
From:   Mark Zimmerman <mark@candragon.net>
To:     linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Mailer: MessagingEngine.com Webmail Interface - ajax-e97eb308
Subject: Regression in 4.20 - still present in 5.0-rc6
Date:   Tue, 12 Feb 2019 20:03:30 -0700
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Greetings:

This is to call your attention to a regression that showed up in kernel 4.20; the behavior is still present in 5.0-rc6.

Please look at https://bugzilla.kernel.org/show_bug.cgi?id=202565 for details.

Also, the forum post https://bbs.archlinux.org/viewtopic.php?id=244097 has further discussion and references a RedHat bug that may be relevant.

Thank you for your time,
-- Mark Zimmerman
