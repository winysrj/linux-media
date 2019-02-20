Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B398AC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 21:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8143D2086C
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 21:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfBTVf5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 16:35:57 -0500
Received: from relayout04-q02.e.movistar.es ([86.109.101.172]:31217 "EHLO
        relayout04-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbfBTVf5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 16:35:57 -0500
Received: from relayout04-redir.e.movistar.es (relayout04-redir.e.movistar.es [86.109.101.204])
        by relayout04-out.e.movistar.es (Postfix) with ESMTP id 444WB32MHHz201y;
        Wed, 20 Feb 2019 22:35:55 +0100 (CET)
Received: from [192.168.0.161] (static-146-187-224-77.ipcom.comunitel.net [77.224.187.146])
        (Authenticated sender: jareguero@telefonica.net)
        by relayout04.e.movistar.es (Postfix) with ESMTPA id 444WB15m1Nz109c;
        Wed, 20 Feb 2019 22:35:53 +0100 (CET)
Date:   Wed, 20 Feb 2019 22:35:59 +0100
User-Agent: K-9 Mail for Android
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH V2 0/2] Add suport for Avermedia TD310
To:     Linux media <linux-media@vger.kernel.org>,
        Sean Young <sean@mess.org>, Antti Palosaari <crope@iki.fi>,
        jose.alberto.reguero@gmail.com
From:   Jose Alberto Reguero <jareguero@telefonica.net>
Message-ID: <C871471F-F133-4B54-A809-90ECD324E4AA@telefonica.net>
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-TnetOut-Country: IP: 77.224.187.146 | Country: ES
X-TnetOut-Information: AntiSPAM and AntiVIRUS on relayout04
X-TnetOut-MsgID: 444WB15m1Nz109c.A8F51
X-TnetOut-SpamCheck: no es spam, Unknown
X-TnetOut-From: jareguero@telefonica.net
X-TnetOut-Watermark: 1551303355.20331@qHeASdH/Y3HHufkKeE693Q
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This serie add support for Avermedia TD310 usb stik.

Jose Alberto Reguero
-- 
Enviado desde mi dispositivo Android con K-9 Mail. Por favor, disculpa mi brevedad.
