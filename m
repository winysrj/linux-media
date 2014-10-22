Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1189 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbaJVJpR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 05:45:17 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id s9M9jE2p027066
	for <linux-media@vger.kernel.org>; Wed, 22 Oct 2014 11:45:16 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.61.200.78] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 1E25E2A0432
	for <linux-media@vger.kernel.org>; Wed, 22 Oct 2014 11:45:03 +0200 (CEST)
Message-ID: <54477CA9.5090602@xs4all.nl>
Date: Wed, 22 Oct 2014 11:45:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] mem2mem_testdev: rename to vim2m
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is identical to https://patchwork.linuxtv.org/patch/26044/ except for being
rebased to v3.18-rc1.

Regards,

	Hans

The following changes since commit 1ef24960ab78554fe7e8e77d8fc86524fbd60d3c:

   Merge tag 'v3.18-rc1' into patchwork (2014-10-21 08:32:51 -0200)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git vim2m

for you to fetch changes up to 456e598de9719ddf0dfe69f37909759a35ab20d2:

   mem2mem_testdev: rename to vim2m. (2014-10-22 11:42:32 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
       mem2mem_testdev: rename to vim2m.

  drivers/media/platform/Kconfig                        |   4 +-
  drivers/media/platform/Makefile                       |   2 +-
  drivers/media/platform/{mem2mem_testdev.c => vim2m.c} | 221 +++++++++++++++++++++++++++----------------------------
  3 files changed, 113 insertions(+), 114 deletions(-)
  rename drivers/media/platform/{mem2mem_testdev.c => vim2m.c} (81%)
