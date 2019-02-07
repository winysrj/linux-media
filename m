Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB7FC282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 04:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A73F52175B
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 04:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfBGEfk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 23:35:40 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:58271 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726642AbfBGEfk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Feb 2019 23:35:40 -0500
Received: from localhost ([IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5])
        by smtp-cloud7.xs4all.net with ESMTPA
        id rbPVgqVs0BDyIrbPWgHeQU; Thu, 07 Feb 2019 05:35:39 +0100
Message-ID: <50eedf161ab41d1882185278404532e0@smtp-cloud7.xs4all.net>
Date:   Thu, 07 Feb 2019 05:35:37 +0100
From:   "Hans Verkuil" <hverkuil@xs4all.nl>
To:     linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: WARNINGS
X-CMAE-Envelope: MS4wfMHFUJIphIjbXXqiD7sr1ie+dDHunQ2/cT9EvV4QOE9m8K160Kz9rkyjToQJk3+z6AYqcvclxKmLri6MB1B8UYVzvXTWjObqahLatH+o7zmREaAXvLgQ
 6Tuu4JvUNz5Z93t/sCY6RAp2PASdFfAgVBcl89eFUJV/mdin5n8oiStegl+9C3UboNQ1IvJrqyO12x+6XDQ7OSpG0Avt87zM2rrAGSpl8K3c5UAY5Kh2tx+m
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Thu Feb  7 05:00:12 CET 2019
media-tree git hash:	f0ef022c85a899bcc7a1b3a0955c78a3d7109106
media_build git hash:	c23276037794bae357fa8d23e3a4f11af9ad46e9
v4l-utils git hash:	400ec9e6eb156b0eea9112bf27e14f9ae493eedb
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

http://www.xs4all.nl/~hverkuil/logs/Thursday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Thursday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
