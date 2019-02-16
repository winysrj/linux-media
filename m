Return-Path: <SRS0=NtRf=QX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63205C43381
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 04:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 327E6222A1
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 04:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394511AbfBPEpI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Feb 2019 23:45:08 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:55367 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729703AbfBPEpI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Feb 2019 23:45:08 -0500
Received: from localhost ([IPv6:2001:983:e9a7:1:512a:27ad:f0dd:d8db])
        by smtp-cloud7.xs4all.net with ESMTPA
        id urqbgcALOLMwIurqcgZSSU; Sat, 16 Feb 2019 05:45:06 +0100
Message-ID: <4227498bb90fa8be8856379f97ae46b4@smtp-cloud7.xs4all.net>
Date:   Sat, 16 Feb 2019 05:45:05 +0100
From:   "Hans Verkuil" <hverkuil@xs4all.nl>
To:     linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: OK
X-CMAE-Envelope: MS4wfDbhB2Id2hT/Ly95PWTk6HPJfchEc24UPydDuvm9UF+KnrkFjxkhgBdLeHqa+PkVt0Bg0kLx6y9MbOLEroUOa0E2aICTrZBvqszCGE6KFWnAXYkJ/nK5
 ZpVXdtvwUFaaRzyN/QAVHMtblVnMvwxtJO55SSF6csXNGgWDcy0TdrP1LbmiEv3vrhiRuNkuxctah6nXaGExD8qSUZ6PfMBrhvJfejHuKV+UkLEHcA8QHS+Q
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Sat Feb 16 05:00:11 CET 2019
media-tree git hash:	6fd369dd1cb65a032f1ab9227033ecb7b759656d
media_build git hash:	c23276037794bae357fa8d23e3a4f11af9ad46e9
v4l-utils git hash:	2e4f399e3d5d367d00d06e4c53b24feb744bed65
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
virtme: OK
virtme: Final Summary: 1947, Succeeded: 1947, Failed: 0, Warnings: 15
sparse: WARNINGS
smatch: ERRORS

Detailed results are available here:

http://www.xs4all.nl/~hverkuil/logs/Saturday.log

Full logs are available here:

http://www.xs4all.nl/~hverkuil/logs/Saturday.tar.bz2

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
