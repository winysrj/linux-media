Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 239DDC65BAF
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 17:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E81F32080F
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 17:36:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E81F32080F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbeLLRgv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 12:36:51 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:50458 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727799AbeLLRgv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 12:36:51 -0500
Received: from [IPv6:2001:983:e9a7:1:d5c3:7636:7173:44a0] ([IPv6:2001:983:e9a7:1:d5c3:7636:7173:44a0])
        by smtp-cloud8.xs4all.net with ESMTPA
        id X8R9gktT0uDWoX8RAgJATS; Wed, 12 Dec 2018 18:36:49 +0100
Subject: [PATCH v6 3/2] MAINTAINERS: added include/trace/events/pwc.h
To:     "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     matwey.kornilov@gmail.com, tfiga@chromium.org,
        laurent.pinchart@ideasonboard.com, stern@rowland.harvard.edu,
        ezequiel@collabora.com, hdegoede@redhat.com, mchehab@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, isely@pobox.com,
        bhumirks@gmail.com, colin.king@canonical.com,
        kieran.bingham@ideasonboard.com, keiichiw@chromium.org
References: <20181109190327.23606-1-matwey@sai.msu.ru>
 <20181109190327.23606-2-matwey@sai.msu.ru>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <339893a9-d5a9-00b1-86ad-2c9c8b4fb10f@xs4all.nl>
Date:   Wed, 12 Dec 2018 18:36:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181109190327.23606-2-matwey@sai.msu.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfIxvWTe85HkBpdBHlM+iRT4Snl9J+61nTN7Bwb5U8VfsMFjY3VHmaFoCpw/DPwEUkL5rESfJCoZggWbdMhAow4KZ9fn16i71qgGpS7p9egAGoyaodYMG
 C0lkA+hMQzdwP7HYrAbVlfM/1NTsRI7c1FuKc23p1g0TSEuXGiWPcvbuOD0BUitktH90sfDiP6jQbW5rPmUb7DEL3LCqW6e4jEwCJJK7+K5LoEwsi/8tT+lt
 zULLDHZw+WdR3YVD4wdOJTNAWXokPXbArDdFiDv2RjHdV+BkDgqmgjJMFMbJ3e8pHOfNw9POmyLWkBDCjI43G33SVTxLYFZUnP/lnQF8HwnsZV4Uwo6sxJrj
 PqfMQoPsVTlaWWKM7s8aT1uygUr6ySNw1UB3WTHArC9rmGfCv+xf0GRr719qP+Nh4ueqAzL0BmP9BeQw6WicaHzaiMeTnb5eHyM9s1MTCmb8I+b4Hc0z5Aig
 pDthadW/tGdZFS+rkc5Bj53b8TPMINd9eq5vIxLzuoHNnFAFFsq7Lz2OA/O89U0N7ZUS03jAg9Ua/o1WF9sb4rHz4ftXaCTvsxuyQ7ncy+fTnAEPBiO42/2C
 1CeoKiSGNf5FqBIQUsUI+PKSuxRmNHEJOsbEuG9RV8CzAzdFdvHvxKCbub8XFsD03UI0NfdrLi7XJLb/2AF7Zw4Yl9ntixQELxfLVAvp3UefisxyPbUuK4IQ
 7HC8RsulrNXUOZFhOVSEvFAAf8yMpFasottMzy+Qz56+fv2HmpiA2qZYahoXo0IH7PVs1hETutYJUqJXS9wKiwXLLuqZzkThJHCmhlUIBiJ7DSksk6cW3w==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Added include/trace/events/pwc.h to the list of files.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
Will include this patch as part of the pull request.
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3e9f1710ed13..3ce9533bca26 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12191,6 +12191,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Odd Fixes
 F:	drivers/media/usb/pwc/*
+F:	include/trace/events/pwc.h

 PWM FAN DRIVER
 M:	Kamil Debski <kamil@wypas.org>
-- 
2.19.2


