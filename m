Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC62C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47C9C2064A
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfCEShR convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:37:17 -0500
Received: from relayout04-q02.e.movistar.es ([86.109.101.172]:55229 "EHLO
        relayout04-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbfCEShR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 13:37:17 -0500
Received: from relayout04-redir.e.movistar.es (relayout04-redir.e.movistar.es [86.109.101.204])
        by relayout04-out.e.movistar.es (Postfix) with ESMTP id 44DQbt3SvNz24J3;
        Tue,  5 Mar 2019 19:37:14 +0100 (CET)
Received: from [192.168.0.167] (unknown [47.62.122.75])
        (Authenticated sender: jareguero@telefonica.net)
        by relayout04.e.movistar.es (Postfix) with ESMTPA id 44DQbr5zmDz12gd;
        Tue,  5 Mar 2019 19:37:12 +0100 (CET)
Date:   Tue, 05 Mar 2019 19:37:18 +0100
User-Agent: K-9 Mail for Android
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH V3 0/3] Add support for the Avermedia TD310
To:     Linux media <linux-media@vger.kernel.org>,
        Sean Young <sean@mess.org>, Antti Palosaari <crope@iki.fi>,
        Andreas Kemnade <andreas@kemnade.info>,
        jose.alberto.reguero@gmail.com
From:   Jose Alberto Reguero <jareguero@telefonica.net>
Message-ID: <6B443429-325E-425A-A97B-FC8B335BF868@telefonica.net>
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-TnetOut-Country: IP: 47.62.122.75 | Country: ES
X-TnetOut-Information: AntiSPAM and AntiVIRUS on relayout04
X-TnetOut-MsgID: 44DQbr5zmDz12gd.A503D
X-TnetOut-SpamCheck: no es spam, Unknown
X-TnetOut-From: jareguero@telefonica.net
X-TnetOut-Watermark: 1552415834.35237@1v9dU48me4ODKIzn3RnHeQ
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Diferences from V2: changes as requested.

Jose Alberto Reguero
-- 
Enviado desde mi dispositivo Android con K-9 Mail. Por favor, disculpa mi brevedad.
