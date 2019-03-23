Return-Path: <SRS0=n2cC=R2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A961C43381
	for <linux-media@archiver.kernel.org>; Sat, 23 Mar 2019 04:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C72E20896
	for <linux-media@archiver.kernel.org>; Sat, 23 Mar 2019 04:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbfCWEtW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 23 Mar 2019 00:49:22 -0400
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:60373 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725976AbfCWEtW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Mar 2019 00:49:22 -0400
Received: from localhost ([IPv6:2001:983:e9a7:1:a03d:2e6d:2ff:f561])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 7YathlkZ1UjKf7Yauhcqzc; Sat, 23 Mar 2019 05:49:20 +0100
Message-ID: <d7573d1e619f48f6775432ac1d170248@smtp-cloud8.xs4all.net>
Date:   Sat, 23 Mar 2019 05:49:19 +0100
From:   "Hans Verkuil" <hverkuil@xs4all.nl>
To:     linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: WARNINGS
X-CMAE-Envelope: MS4wfAuQ01wsI7lx6/YnBGJP0pHo2Ki7TEB6z6CZfNu5BzYDAjJP+t+r75hNpZUXpKD9pC1KmOzkiMWC6FQ9+FH59Kb8BmmfCrkozSruwNRTbqDTQyWWE6Rc
 OEukHMXjys+wgtna6XfciQu5XeSUNUhK5JteRCVUDQ4T0mBtn351346Hi7aL/Tn+xiLsuWMA27vx0rxij4cC4k3zNt36S9/dl9m1iZDNTwBvCLqMOyf6VZIz
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Sat Mar 23 05:00:10 CET 2019
media-tree git hash:	8a3946cad244e8453e26f3ded5fe40bf2627bb30
media_build git hash:	7fb9ee4c605015dc0d4d983b9a3a8fd47d2290b6
v4l-utils git hash:	40fd5611c5176137c80616f6ee93b36f0d88f2d5
edid-decode git hash:	6def7bc83dfb0338632e06a8b14c93faa6af8879
gcc version:		i686-linux-gcc (GCC) 8.3.0
sparse repo:                   https://git.linuxtv.org/mchehab/sparse.git
sparse version:		0.6.0
smatch repo:                   https://git.linuxtv.org/mchehab/smatch.git
smatch version:		0.5.1
host hardware:		x86_64
host os:		4.19.0-2-amd64

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
linux-git-x86_64: WARNINGS
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
linux-3.16.63-i686: OK
linux-3.16.63-x86_64: OK
linux-3.17.8-i686: OK
linux-3.17.8-x86_64: OK
linux-3.18.136-i686: OK
linux-3.18.136-x86_64: OK
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
linux-4.4.167-i686: OK
linux-4.4.167-x86_64: OK
linux-4.5.7-i686: OK
linux-4.5.7-x86_64: OK
linux-4.6.7-i686: OK
linux-4.6.7-x86_64: OK
linux-4.7.10-i686: OK
linux-4.7.10-x86_64: OK
linux-4.8.17-i686: OK
linux-4.8.17-x86_64: OK
linux-4.9.162-i686: OK
linux-4.9.162-x86_64: OK
linux-4.10.17-i686: OK
linux-4.10.17-x86_64: OK
linux-4.11.12-i686: OK
linux-4.11.12-x86_64: OK
linux-4.12.14-i686: OK
linux-4.12.14-x86_64: OK
linux-4.13.16-i686: OK
linux-4.13.16-x86_64: OK
linux-4.14.105-i686: OK
linux-4.14.105-x86_64: OK
linux-4.15.18-i686: OK
linux-4.15.18-x86_64: OK
linux-4.16.18-i686: OK
linux-4.16.18-x86_64: OK
linux-4.17.19-i686: OK
linux-4.17.19-x86_64: OK
linux-4.18.20-i686: OK
linux-4.18.20-x86_64: OK
linux-4.19.28-i686: OK
linux-4.19.28-x86_64: OK
linux-4.20.15-i686: OK
linux-4.20.15-x86_64: OK
linux-5.0.1-i686: OK
linux-5.0.1-x86_64: OK
linux-5.1-rc1-i686: OK
linux-5.1-rc1-x86_64: WARNINGS
apps: OK
spec-git: OK
virtme: OK: Final Summary: 1981, Succeeded: 1981, Failed: 0, Warnings: 15
sparse: OK
smatch: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Saturday.log

Detailed regression test results are available here:

http://www.xs4all.nl/~hverkuil/logs/Saturday-test-media.log
http://www.xs4all.nl/~hverkuil/logs/Saturday-test-media-dmesg.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Saturday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
