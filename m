Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F39C10F03
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 22:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 785A220857
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 22:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553551424;
	bh=cYceWHLXgd0ZbP67Wnfb1QLOpi8GB5Jj/gHlszcazYg=;
	h=From:Cc:Subject:Date:To:List-ID:From;
	b=cBdeWiyfYvNdystLAqCflJh3zVpK9TP6ZHhYVnHeio61rhtxVabBh97B/h/5wTGtn
	 z6N6XsgswX9Vckdo1UTPSKaxp9ekQkw09LNAhvnoKGa/AcwjtFbGyaPKSxcbPB2gRA
	 bN1k2hbfnhcwV9bjzw3QomLKt6hEfpIAmqVVr0qQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730614AbfCYWDm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 18:03:42 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54884 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729297AbfCYWDm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 18:03:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DCEd9pndkJqN+Z2KGl6O2wjOrX5b+csUxDXYqFfAMW4=; b=cSMtRpY9Cc4h51hBX7+xUqxDJ
        3RG9WSvFR13dvAGdtq1MPx03cLw8c7MDRc42yHQjZy7sD4ylzN1wNmhWlAdwIBFoGvq1N7C5oBOUm
        cdg5HcvNqrM4AtuJ0U/RHe+GJb0a3/tuwNogDheqRXsn5cnv+1vhagPqO4QEr6xk87ec9edzHGklX
        e7YMBzoFMQO4iZWZ3tAffpUdJBaPi9zCHbqTUgOSaNLRuHFzBB6yP4+17jYYl3p8AzvoNF9q1DjiF
        +YTWw2yWS+Q+P3wipuP3abisRVrc0Fkv3WfVKrGXKPhVgGhwsAgUBv9OKhz4wo1vFdz0OE7/5hgmq
        4s8C57r+w==;
Received: from 177.41.113.24.dynamic.adsl.gvt.net.br ([177.41.113.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h8Xgz-0001YI-ON; Mon, 25 Mar 2019 22:03:41 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1h8Xgw-0001ae-Fs; Mon, 25 Mar 2019 18:03:38 -0400
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        linux-renesas-soc@vger.kernel.org,
        Andy Gross <andy.gross@linaro.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        David Brown <david.brown@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 0/5] Fix smatch warnings
Date:   Mon, 25 Mar 2019 18:03:32 -0400
Message-Id: <cover.1553551369.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Fix smatch warnings on media subsystem.

Mauro Carvalho Chehab (5):
  media: cx2341x: replace badly designed macros
  media: pwc-ctl: pChoose can't be NULL
  media: sti/delta: remove uneeded check
  media: rcar-dma: p_set can't be NULL
  media: hfi_parser: don't trick gcc with a wrong expected size

 drivers/media/common/cx2341x.c                | 151 +++++++++++-------
 .../media/platform/qcom/venus/hfi_helper.h    |   4 +-
 drivers/media/platform/rcar-vin/rcar-dma.c    |   2 +-
 drivers/media/platform/sti/delta/delta-ipc.c  |   6 +-
 drivers/media/usb/pwc/pwc-ctrl.c              |  17 +-
 5 files changed, 107 insertions(+), 73 deletions(-)

-- 
2.20.1


