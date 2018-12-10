Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E73E0C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 04:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE83D2084E
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 04:31:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AE83D2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbeLJEb6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 23:31:58 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:39258 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726187AbeLJEb5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Dec 2018 23:31:57 -0500
Received: from localhost ([IPv6:2001:983:e9a7:1:153f:c992:21d9:6742])
        by smtp-cloud7.xs4all.net with ESMTPA
        id WDETg3wd0QMWUWDEUg1rZA; Mon, 10 Dec 2018 05:31:56 +0100
Message-ID: <c578b257913b83bad34d1f9d3053b05c@smtp-cloud7.xs4all.net>
Date:   Mon, 10 Dec 2018 05:31:49 +0100
From:   "Hans Verkuil" <hverkuil@xs4all.nl>
To:     linux-media@vger.kernel.org
Subject: cron job: media_tree daily build: ERRORS
X-CMAE-Envelope: MS4wfA7tyJmPmnl6lHouxdlEcjEFzecrVmfh7N9mAnJoX1McxJQN/ARR7Q7XC6TYjuNLl5quONKbGXYTuzbMwn0+mKtWQjqivC1ID8qYRD5cA9PQu54RMAPk
 hiTq1rINuqH+gOZXapUvAtfarOYsaLGcxCGdxD28lB5bs+uEcHHyb6diFfe8dNPPSzJFKilcb1SJtbce4Q6fK82v5XYg+ZzLpcXHaaxyqAptNR+D0jIPteCz
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This message is generated daily by a cron job that builds media_tree for
the kernels and architectures in the list below.

Results of the daily build of media_tree:

date:			Mon Dec 10 05:00:11 CET 2018
media-tree git hash:	e159b6074c82fe31b79aad672e02fa204dbbc6d8
media_build git hash:	bd2896dbe1969af199b9f0569d1c60b0ab2859ff
v4l-utils git hash:	516595495957cbc18b578e6c1598bec21858b4e5
edid-decode git hash:	6def7bc83dfb0338632e06a8b14c93faa6af8879
gcc version:		i686-linux-gcc (GCC) 8.2.0
sparse version:		0.5.2
smatch version:		0.5.1
host hardware:		x86_64
host os:		4.18.0-3-amd64

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
linux-3.10.108-i686: ERRORS
linux-3.10.108-x86_64: ERRORS
linux-3.11.10-i686: ERRORS
linux-3.11.10-x86_64: ERRORS
linux-3.12.74-i686: ERRORS
linux-3.12.74-x86_64: ERRORS
linux-3.13.11-i686: ERRORS
linux-3.13.11-x86_64: ERRORS
linux-3.14.79-i686: ERRORS
linux-3.14.79-x86_64: ERRORS
linux-3.15.10-i686: ERRORS
linux-3.15.10-x86_64: ERRORS
linux-3.16.57-i686: ERRORS
linux-3.16.57-x86_64: ERRORS
linux-3.17.8-i686: ERRORS
linux-3.17.8-x86_64: ERRORS
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
linux-4.20-rc1-i686: OK
linux-4.20-rc1-x86_64: OK
apps: OK
spec-git: OK
sparse: WARNINGS

Logs weren't copied as they are too large (528 kB)

The Media Infrastructure API from this daily build is here:

http://www.xs4all.nl/~hverkuil/spec/index.html
