Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E871AC43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 14:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C15FE218AC
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 14:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbfBQOiZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Feb 2019 09:38:25 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:54763 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725795AbfBQOiY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Feb 2019 09:38:24 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id vNaFgUcYp4HFnvNaIgx3uF; Sun, 17 Feb 2019 15:38:23 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Helen Koike <helen.koike@collabora.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vimc: fix memory leak
Message-ID: <0b7d6f2b-379c-a4fd-4a16-3ae7545f42c1@xs4all.nl>
Date:   Sun, 17 Feb 2019 15:38:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfBgqNWo6bcxz8nMUvRgpEZIEEgItUpnSsLzgne1sd2f3Ah9Ow/N2a3hRNJ2kKrBAPy9+95kYm10R1/5orLB4fl7chIzpgTLzIKx9uQkZlSa/N9FlXPpP
 EcQL/GcvKohwx+GYaQ3tf9i7kR9BGbjuAJoMdPIlDOy62qXeATzJUVOoI8j6qQYN7BsroaoesOnjQuQSyhOpuF3Ipc/hWpcBAJzak9jbyAFD72p4UQJO6nF1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

media_device_cleanup() wasn't called, which caused a small
memory leak.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
index c2fdf3ea67ed..0fbb7914098f 100644
--- a/drivers/media/platform/vimc/vimc-core.c
+++ b/drivers/media/platform/vimc/vimc-core.c
@@ -220,6 +220,7 @@ static int vimc_comp_bind(struct device *master)

 err_mdev_unregister:
 	media_device_unregister(&vimc->mdev);
+	media_device_cleanup(&vimc->mdev);
 err_comp_unbind_all:
 	component_unbind_all(master, NULL);
 err_v4l2_unregister:
@@ -236,6 +237,7 @@ static void vimc_comp_unbind(struct device *master)
 	dev_dbg(master, "unbind");

 	media_device_unregister(&vimc->mdev);
+	media_device_cleanup(&vimc->mdev);
 	component_unbind_all(master, NULL);
 	v4l2_device_unregister(&vimc->v4l2_dev);
 }
