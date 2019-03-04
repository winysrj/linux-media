Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A2C2C43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 14:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CC9B20823
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 14:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbfCDO2x (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 09:28:53 -0500
Received: from mout.gmx.net ([212.227.17.22]:36603 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfCDO2x (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Mar 2019 09:28:53 -0500
Received: from [38.124.154.235] ([38.124.154.235]) by web-mail.gmx.net
 (3c-app-mailcom-bs16.server.lan [172.19.170.184]) (via HTTP); Mon, 4 Mar
 2019 15:28:51 +0100
MIME-Version: 1.0
Message-ID: <trinity-15b86e34-e163-4203-9e29-7183c42f7cb4-1551709731793@3c-app-mailcom-bs16>
From:   "Jason H" <jhihn@gmx.com>
To:     linux-media@vger.kernel.org
Subject: Spelling errors in lib/libv4l2/libv4l2.c
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 4 Mar 2019 15:28:51 +0100
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:f2uFfd0mFRX8ojZUNDrrPYvQAdrqW/vpwoUNeBTJbvBdsDEx8V0B/q/vhlWU5OJUdg1Kp
 gr1KPmT+rEcClyQDCwelQgClD5JtNluXkfRkhY2+PT/+SEUSBFeE5Y5tSlH7y0gW4EuweGN5Cxx0
 6CkPnrGjByX2f7ikwwpGO0+S7r+77xedC9KAPhdXLJoy495QtyCpy1MdP3LlFmzMC3aLzhKbR9tR
 ljcPKe6WetCbHlBHUnO84zSzMkeB+CHk+m2vtWXid4nzlSxovrhJC0kfe4RAQxcwIYgLxKMOxvW8
 M4=
X-UI-Out-Filterresults: notjunk:1;V03:K0:HCTxyo+6Zxg=:VieRKitCPu3BjFUS9S1Rcz
 2I1o8kDRC4A2/urtqW+n5AA0bom0HP8f8+1wEIzNKI5hdzldPLK7MyPMWNf2gFhaVMjqR8a8F
 cBDSaUCs8c13S/q2mFKhP5AhvZW+RAj/IgpIV9SEgRePEpH42ea5irZRqHIy654DPmwYLWbmq
 32SZlptOTePDh3fhHcayB1FRA9LB0v1NXdrxj9XeWECmTKnHJL3VSe3BkqkyH74llgCVxqcdJ
 L1LxYl9XZqtwgk8Fvj1wsilY2IvQFH9Sd9JnUFXz97EEwNOVoSIpkmOvb8TImH4W3IvtSqg8j
 VKL/XWvD3yHcMREMGvH2azvDpKs1ydGG/2+8m2h31m2C56QC0tnejfcxvFLmFJkDxSB/wbYAv
 +0z/cUtuRJ+SMJx35CQLEYpoX5wJ701ATghEjNpFodB3+f/UPoqw97w9Ya27opuR4S4PgScwe
 66aAlB4tyk8eAjv7YTItfwjpo/BbsQc90aQjVtY+dcKMMUb0q/dQbGUymXzZD56QNWkUQ0NdK
 8BiaC2Rj7e3VY0BsBipZi61Jpac9OyhUQTUah8PJGY5+GxJdNZl1bdEtSCGUuVVZTAXsZ2+gP
 Ecgpk4TbQvgpQ=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

A very minor point, but I've found some then/than confusion:

746: V4L2_LOG_ERR("attempting to open more then %d video devices\n",      // should be than
1038: V4L2_LOG_ERR("set_fmt gave us a different result then try_fmt!\n"); // should be than
1318:  /* No more buffers then we can manage please */                    // should be than

The rest of the 'then's in that file seem ok.
