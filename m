Return-Path: <SRS0=qapk=PV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF91C43387
	for <linux-media@archiver.kernel.org>; Sun, 13 Jan 2019 04:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 089CB2086C
	for <linux-media@archiver.kernel.org>; Sun, 13 Jan 2019 04:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfAMEg1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 12 Jan 2019 23:36:27 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:42361 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726525AbfAMEg1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Jan 2019 23:36:27 -0500
Received: from localhost ([IPv6:2001:983:e9a7:1:c88:52ce:2009:69f0])
        by smtp-cloud8.xs4all.net with ESMTPA
        id iXVYg2eOjNR5yiXVZgE8de; Sun, 13 Jan 2019 05:36:25 +0100
Message-ID: <68cb44c32e9fb90daa40ec045fa7d34c@smtp-cloud8.xs4all.net>
Date:   Sun, 13 Jan 2019 05:36:24 +0100
From:   "Hans Verkuil" <hverkuil@xs4all.nl>
To:     linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: OK
X-CMAE-Envelope: MS4wfIeOMBdQJQq70r0NhVdsq3ar4Q5f4R/47W6zNDykltYNDPeTyLTs73VEm1bVVnSC/PlpQpvZ+ssENqR2tcM+MDof9ds4Ck8fr5MlOLuDx09th9F2CjF/
 s4JCFy4j52hNj4oZn1gwCdW6BQz1TKOkKDzsKHB5HahZgP0NqgvHB8S1q4P9BinTnIIeh9AWpeyJIsn+tD7OLfNeO43JGOPo8gKKTR43usBqTZxymd0kAsfU
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Sun Jan 13 05:00:11 CET 2019
media-tree git hash:	1e0d0a5fd38192f23304ea2fc2b531fea7c74247
media_build git hash:	8851c6e626dac550d6798e162c6b4f5a41bc13ec
v4l-utils git hash:	a4f1a58d1138f26b5e2cc294687598ba323eeeca
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
Check COMPILE_TEST: OK
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
sparse: WARNINGS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Sunday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Sunday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
