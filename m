Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42167C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 07:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BEC420830
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 07:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730513AbfCZHh2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 03:37:28 -0400
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:47208 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726413AbfCZHh2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 03:37:28 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 8geBh2tSoUjKf8geEhjvpJ; Tue, 26 Mar 2019 08:37:27 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [ANN] edid-decode: synced with latest CTA-861.4 and CTA-861.5
 standards
Message-ID: <817b4f86-bf58-4487-43d3-c99748ed5d48@xs4all.nl>
Date:   Tue, 26 Mar 2019 08:37:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfKdGwnop/ZZ49cADST29MWqv8bMWTycXNnQ4uvd8ldaD0TcuTgUxEbCnJ1sQQkygu0658EOFnQS3KSqlGAbmItT74PF+WVfBP6qgUTTPQVorBheIBF79
 HiLXxqogcggh6CZ7aoZ+Wh6rZt4W/GwRUZ+jHXcDy4xskH3pEbt8i0uGwK2G1hDufXGarbP15264XA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

For those who care about this:

I've updated the edid-decode utility to include the new CTA-861.4 and .5 standards.
The .5 has been released a while ago, the .4 standard was released yesterday.

Most of the changes relate to audio and speaker mappings (if you want to, you
can now signal support for 22.2 speakers!), but for video the only new thing
is support for the ICtCp colorspace.

Regards,

	Hans
