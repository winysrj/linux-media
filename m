Return-Path: <SRS0=NtRf=QX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E07F6C43381
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 10:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3C0E222E0
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 10:05:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbfBPKFY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 05:05:24 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:39246 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726924AbfBPKFX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 05:05:23 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id uwqUgf6mVLMwIuwqXgaK7X; Sat, 16 Feb 2019 11:05:22 +0100
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: IPU3 smatch/sparse warnings
Message-ID: <d77618fc-085b-c120-579f-9239a73634fe@xs4all.nl>
Date:   Sat, 16 Feb 2019 11:05:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfK8/JaW8WR6QmO3JxjUEbuEvU0GIZheGWq7YXLQai8696jHz3L8Q194jJ56wzgOG8IcuY+CjSGvTS1AnWxA0/+7+KuI6ui691ZIeJWNqKxqrcwVELX/A
 heEYh0rmcFRZB3qujWJR5HdatT580is4c/pISKkQwT/wKs7NSfO99m/HPvvQnMuc05srpB46QEdd24HM0+BTo/JSFTQdQyk/aX9nZQa+nh6omoorzPbV9hW9
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

Can you take a look at the IPU3 smatch/sparse warnings?

See here: https://hverkuil.home.xs4all.nl/logs/Saturday.log

The two that concern me most are these:

/home/hans/work/build/media-git/drivers/staging/media/ipu3/include/intel-ipu3.h:2475:35: warning: 'awb_fr' offset 36756 in 'struct
ipu3_uapi_acc_param' isn't aligned to 32 [-Wpacked-not-aligned]

/home/hans/work/build/media-git/drivers/staging/media/ipu3/ipu3-abi.h:1250:1: warning: alignment 1 of 'struct imgu_abi_awb_fr_config' is
less than 32 [-Wpacked-not-aligned]

You can ignore these two sparse warnings:

/home/hans/work/build/media-git/drivers/staging/media/ipu3/ipu3-css-params.c:1743:15: warning: memset with byte count of 285120
/home/hans/work/build/media-git/drivers/staging/media/ipu3/ipu3-css-params.c:2284:15: warning: memset with byte count of 240832

They are bogus and they should disappear since I now added the
-fmemcpy-max-count=300000 option to sparse.

The other ipu3 warnings all seem trivial to fix.

I'm trying to get the build to run without sparse/smatch warnings, so
getting this fixed will be very useful.

Regards,

	Hans
