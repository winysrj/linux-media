Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8923EC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 05:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55DF821773
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 05:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbfBTFNF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 00:13:05 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:49977 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbfBTFNF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 00:13:05 -0500
Received: from localhost ([IPv6:2001:983:e9a7:1:2ca2:3f58:752b:c293])
        by smtp-cloud9.xs4all.net with ESMTPA
        id wKBqgiLuII8AWwKBrgI0pM; Wed, 20 Feb 2019 06:13:03 +0100
Message-ID: <597d81bc67c35c1efd426d704454c82b@smtp-cloud9.xs4all.net>
Date:   Wed, 20 Feb 2019 06:13:02 +0100
From:   "Hans Verkuil" <hverkuil@xs4all.nl>
To:     linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
X-CMAE-Envelope: MS4wfBWl/LjIe5Yy/5wcHAXKAlNzmZiOH2+Q/YhYUqdJZfyCIQcX35wLqbhmAd6yQEAEATCugI/p5so36lcJJzv3e7ZqRs7YzxRC2fQr4LOxg/MTfrx4EvgQ
 BnpynV+V5jldrE5ye24+WKa1uhGlNpQYSj77MEefVlGRAUREztPx19BWbLBjA+rL6xiMAfuRsDI/amRulykfR2Sj3B+5uejhhHqgT+pKfTlcZ1xJ5qrMtd0m
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Wed Feb 20 05:00:11 CET 2019
media-tree git hash:	9fabe1d108ca4755a880de43f751f1c054f8894d
media_build git hash:	c23276037794bae357fa8d23e3a4f11af9ad46e9
v4l-utils git hash:	602c87b681d6ebd0f9ce15ce4421d735f01ef8c0
edid-decode git hash:	6def7bc83dfb0338632e06a8b14c93faa6af8879
gcc version:		i686-linux-gcc (GCC) 8.2.0
sparse version:		0.5.2
smatch version:		0.5.1
host hardware:		x86_64
host os:		4.19.0-1-amd64

linux-git-arm-at91: OK
linux-git-arm-davinci: OK
linux-git-arm-multi: OK
linux-git-arm-pxa: OK
linux-git-arm-stm32: OK
linux-git-arm64: OK
linux-git-i686: OK
linux-git-mips: OK
linux-git-powerpc64: OK
linux-git-sh: OK
linux-git-x86_64: OK
Check COMPILE_TEST: WARNINGS: SOC_CAMERA_MT9T031 SOC_CAMERA SOC_CAMERA_MT9M111 SOC_CAMERA_MT9V022 SOC_CAMERA_OV5642 SOC_CAMERA_OV9740 SOC_CAMERA_IMX074 SOC_CAMERA_MT9T031
linux-3.10.108-i686: OK
linux-3.10.108-x86_64: OK
linux-3.11.10-i686: OK
linux-3.11.10-x86_64: OK
linux-3.12.74-i686: OK
linux-3.12.74-x86_64: OK
linux-3.13.11-i686: OK
linux-3.13.11-x86_64: OK
linux-3.14.79-i686: OK
linux-3.14.79-x86_64: OK
linux-3.15.10-i686: OK
linux-3.15.10-x86_64: OK
linux-3.16.57-i686: OK
linux-3.16.57-x86_64: OK
linux-3.17.8-i686: OK
linux-3.17.8-x86_64: OK
linux-3.18.123-i686: OK
linux-3.18.123-x86_64: OK
linux-3.19.8-i686: OK
linux-3.19.8-x86_64: OK
linux-4.0.9-i686: OK
linux-4.0.9-x86_64: OK
linux-4.1.52-i686: OK
linux-4.1.52-x86_64: OK
linux-4.2.8-i686: OK
linux-4.2.8-x86_64: OK
linux-4.3.6-i686: OK
linux-4.3.6-x86_64: OK
linux-4.4.159-i686: OK
linux-4.4.159-x86_64: OK
linux-4.5.7-i686: OK
linux-4.5.7-x86_64: OK
linux-4.6.7-i686: OK
linux-4.6.7-x86_64: OK
linux-4.7.10-i686: OK
linux-4.7.10-x86_64: OK
linux-4.8.17-i686: OK
linux-4.8.17-x86_64: OK
linux-4.9.131-i686: OK
linux-4.9.131-x86_64: OK
linux-4.10.17-i686: OK
linux-4.10.17-x86_64: OK
linux-4.11.12-i686: OK
linux-4.11.12-x86_64: OK
linux-4.12.14-i686: OK
linux-4.12.14-x86_64: OK
linux-4.13.16-i686: OK
linux-4.13.16-x86_64: OK
linux-4.14.74-i686: OK
linux-4.14.74-x86_64: OK
linux-4.15.18-i686: OK
linux-4.15.18-x86_64: OK
linux-4.16.18-i686: OK
linux-4.16.18-x86_64: OK
linux-4.17.19-i686: OK
linux-4.17.19-x86_64: OK
linux-4.18.12-i686: OK
linux-4.18.12-x86_64: OK
linux-4.19.1-i686: OK
linux-4.19.1-x86_64: OK
linux-4.20.1-i686: OK
linux-4.20.1-x86_64: OK
linux-5.0-rc1-i686: OK
linux-5.0-rc1-x86_64: OK
apps: OK
spec-git: OK
virtme: ERRORS: Final Summary: 1878, Succeeded: 1873, Failed: 5, Warnings: 15
sparse: WARNINGS
smatch: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Wednesday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Wednesday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
