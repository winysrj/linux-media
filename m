Return-Path: <SRS0=0n2Q=QK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB49C169C4
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 04:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD71120823
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 04:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfBCEgx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 2 Feb 2019 23:36:53 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:49548 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726871AbfBCEgx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Feb 2019 23:36:53 -0500
Received: from localhost ([IPv6:2001:983:e9a7:1:c12e:5ef2:d887:a208])
        by smtp-cloud8.xs4all.net with ESMTPA
        id q9WUgq7VvNR5yq9WVgd6CX; Sun, 03 Feb 2019 05:36:51 +0100
Message-ID: <295243d1da9be7ed5e1e139e52e4e221@smtp-cloud8.xs4all.net>
Date:   Sun, 03 Feb 2019 05:36:50 +0100
From:   "Hans Verkuil" <hverkuil@xs4all.nl>
To:     linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: WARNINGS
X-CMAE-Envelope: MS4wfNjK43jBc1+iNKvhKUrY4hptHsdbAcg2PFkOnFgdgXaKYDs98urj1J2d62TQ/t/7sqHCqcAEcQm5rwj7xb34syo1+b1M7PGD/0oYSNRglKDug5z83CW9
 huacowQy6/LvPSqtBQCYfZRtU4ZvnQ/hOagu7yfaTeDwU23zGyCwZQnRInksbAo7XSAZ0hSkpyA3ky0mmsJxoYc7UJjp1GxcduwnG7JJVeFEaW4MOwep2p2W
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Sun Feb  3 05:00:11 CET 2019
media-tree git hash:	f0ef022c85a899bcc7a1b3a0955c78a3d7109106
media_build git hash:	c23276037794bae357fa8d23e3a4f11af9ad46e9
v4l-utils git hash:	9b9c62e464fc97824d64dc6abc1ad33727f77003
edid-decode git hash:	6def7bc83dfb0338632e06a8b14c93faa6af8879
gcc version:		i686-linux-gcc (GCC) 8.2.0
sparse version:		0.5.2
smatch version:		0.5.1
host hardware:		x86_64
host os:		4.19.0-1-amd64

linux-git-arm-at91: WARNINGS
linux-git-arm-davinci: WARNINGS
linux-git-arm-multi: WARNINGS
linux-git-arm-pxa: WARNINGS
linux-git-arm-stm32: WARNINGS
linux-git-arm64: WARNINGS
linux-git-i686: WARNINGS
linux-git-mips: WARNINGS
linux-git-powerpc64: WARNINGS
linux-git-sh: WARNINGS
linux-git-x86_64: WARNINGS
Check COMPILE_TEST: OK
linux-3.10.108-i686: WARNINGS
linux-3.10.108-x86_64: WARNINGS
linux-3.11.10-i686: WARNINGS
linux-3.11.10-x86_64: WARNINGS
linux-3.12.74-i686: WARNINGS
linux-3.12.74-x86_64: WARNINGS
linux-3.13.11-i686: WARNINGS
linux-3.13.11-x86_64: WARNINGS
linux-3.14.79-i686: WARNINGS
linux-3.14.79-x86_64: WARNINGS
linux-3.15.10-i686: WARNINGS
linux-3.15.10-x86_64: WARNINGS
linux-3.16.57-i686: WARNINGS
linux-3.16.57-x86_64: WARNINGS
linux-3.17.8-i686: WARNINGS
linux-3.17.8-x86_64: WARNINGS
linux-3.18.123-i686: WARNINGS
linux-3.18.123-x86_64: WARNINGS
linux-3.19.8-i686: WARNINGS
linux-3.19.8-x86_64: WARNINGS
linux-4.0.9-i686: WARNINGS
linux-4.0.9-x86_64: WARNINGS
linux-4.1.52-i686: WARNINGS
linux-4.1.52-x86_64: WARNINGS
linux-4.2.8-i686: WARNINGS
linux-4.2.8-x86_64: WARNINGS
linux-4.3.6-i686: WARNINGS
linux-4.3.6-x86_64: WARNINGS
linux-4.4.159-i686: WARNINGS
linux-4.4.159-x86_64: WARNINGS
linux-4.5.7-i686: WARNINGS
linux-4.5.7-x86_64: WARNINGS
linux-4.6.7-i686: WARNINGS
linux-4.6.7-x86_64: WARNINGS
linux-4.7.10-i686: WARNINGS
linux-4.7.10-x86_64: WARNINGS
linux-4.8.17-i686: WARNINGS
linux-4.8.17-x86_64: WARNINGS
linux-4.9.131-i686: WARNINGS
linux-4.9.131-x86_64: WARNINGS
linux-4.10.17-i686: WARNINGS
linux-4.10.17-x86_64: WARNINGS
linux-4.11.12-i686: WARNINGS
linux-4.11.12-x86_64: WARNINGS
linux-4.12.14-i686: WARNINGS
linux-4.12.14-x86_64: WARNINGS
linux-4.13.16-i686: WARNINGS
linux-4.13.16-x86_64: WARNINGS
linux-4.14.74-i686: WARNINGS
linux-4.14.74-x86_64: WARNINGS
linux-4.15.18-i686: WARNINGS
linux-4.15.18-x86_64: WARNINGS
linux-4.16.18-i686: WARNINGS
linux-4.16.18-x86_64: WARNINGS
linux-4.17.19-i686: WARNINGS
linux-4.17.19-x86_64: WARNINGS
linux-4.18.12-i686: WARNINGS
linux-4.18.12-x86_64: WARNINGS
linux-4.19.1-i686: WARNINGS
linux-4.19.1-x86_64: WARNINGS
linux-4.20.1-i686: WARNINGS
linux-4.20.1-x86_64: WARNINGS
linux-5.0-rc1-i686: WARNINGS
linux-5.0-rc1-x86_64: WARNINGS
apps: OK
spec-git: OK
sparse: WARNINGS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Sunday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Sunday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
