Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B1AFC282D7
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 04:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E4F72082F
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 04:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbfBDEzO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 3 Feb 2019 23:55:14 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:41643 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727598AbfBDEzO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Feb 2019 23:55:14 -0500
Received: from localhost ([IPv6:2001:983:e9a7:1:8d18:f1e9:cd64:4d1c])
        by smtp-cloud7.xs4all.net with ESMTPA
        id qWHmgSwwjBDyIqWHog6tsJ; Mon, 04 Feb 2019 05:55:12 +0100
Message-ID: <a7458b86be1add97c0a93b0f9b3ecde7@smtp-cloud7.xs4all.net>
Date:   Mon, 04 Feb 2019 05:55:10 +0100
From:   "Hans Verkuil" <hverkuil@xs4all.nl>
To:     linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: WARNINGS
X-CMAE-Envelope: MS4wfJmJbJU/lSXt5mhVgszZnuenjFHErnGMksj7Oebw4YyRLr8nQYIaxv19xWdGA5Iuoufai/tlyCqnVr1HHt/b4JWWxj+/sloMbwniM24vg07zITaEZS60
 Iws+rZqNQx0SDFhJGcvZZOQ00IjGj8Esntcpl1dacjyF0vctmjHkSrC7H5TIzDbBKV4xZiNCdM85OHya+PVs1/XG4fkYtgZrXcZSkGwj82AlVAHyvVlBUFmY
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Mon Feb  4 05:00:10 CET 2019
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

http://www.xs4all.nl/~hverkuil/logs/Monday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Monday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
