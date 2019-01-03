Return-Path: <SRS0=A18R=PL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA73C43387
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 18:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45C3320815
	for <linux-media@archiver.kernel.org>; Thu,  3 Jan 2019 18:41:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ao2.it header.i=@ao2.it header.b="a+ZoGKQO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfACSk7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 3 Jan 2019 13:40:59 -0500
Received: from mail.ao2.it ([92.243.12.208]:58432 "EHLO ao2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfACSk7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Jan 2019 13:40:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=ao2.it; s=20180927;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=12B6QV5/0ZVpjb1c3K7IbQET7rA0YaFL0wX7U/B+68E=;
        b=a+ZoGKQOqXLXsgvFeXegQ7If3EZgd1F9tuw8l/HeOKWkE9xx1BPIfNaVTlIcsb9VrsfINCj9UNmLCpvRh5DCWiF2tRoc3c2PJNDQTiIGSfSLY7pYjH88AA5A+a3j4mes+1KsLn2EH9AGoXdSE0pOz1gIwg6RrJxWMU4+Jz/pZ75OizEzqVGCt10txjJac2oDz6tqj+htxKs/PJ938457u1Tke7Tcx7TVk3bePwEI+Hc6fp24eQhFu8DB3Swh/zhTA+jzZHgflkriCV0tfQDga1S1CUm5Q97KpK9M+Bc348SMUxuGIKRFPL0Qf6RdQtoKJgIyG06WCgCa21nZanDOGw==;
Received: from localhost ([::1] helo=jcn)
        by ao2.it with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <ao2@ao2.it>)
        id 1gf7Hq-0002wP-6d; Thu, 03 Jan 2019 19:00:06 +0100
Received: from ao2 by jcn with local (Exim 4.92-RC3)
        (envelope-from <ao2@ao2.it>)
        id 1gf7Io-0003Cw-KI; Thu, 03 Jan 2019 19:01:06 +0100
From:   Antonio Ospite <ao2@ao2.it>
To:     linux-media@vger.kernel.org
Cc:     Antonio Ospite <ao2@ao2.it>
Subject: [RFC PATCH 0/5] v4l2-ctl: list controls values in a machine-readable format
Date:   Thu,  3 Jan 2019 19:00:57 +0100
Message-Id: <20190103180102.12282-1-ao2@ao2.it>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20181124185256.74dc969bdb8f7ab79cf03d5d@ao2.it>
References: <20181124185256.74dc969bdb8f7ab79cf03d5d@ao2.it>
MIME-Version: 1.0
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

here is an experiment about listing controls values with v4l2-ctl in
a way that makes it more easy to reload them, I would use something like
that for https://git.ao2.it/v4l2-persistent-settings.git/

Patches 1 and 2 are just warm-up patches to get me familiar again with
the v4l2-ctrl codebase, patch 2 is a small preparatory cleanup, and
patches 4 and 5 showcase the idea.

Thanks,
   Antonio

Antonio Ospite (5):
  v4l2-ctl: list controls with menus when OptAll is specified
  v4l2-ctl: list once when both OptListCtrls and OptListCtrlsMenus are
    there
  v4l2-ctl: use a dedicated function to print the control class name
  v4l2-ctl: abstract the mechanism used to print the list of controls
  v4l2-ctl: add an option to list controls in a machine-readable format

 utils/v4l2-ctl/v4l2-ctl-common.cpp | 95 +++++++++++++++++++++++++-----
 utils/v4l2-ctl/v4l2-ctl.1.in       |  4 ++
 utils/v4l2-ctl/v4l2-ctl.cpp        |  3 +-
 utils/v4l2-ctl/v4l2-ctl.h          |  1 +
 4 files changed, 88 insertions(+), 15 deletions(-)

-- 
Antonio Ospite
https://ao2.it
https://twitter.com/ao2it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
