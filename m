Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 178FDC04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 13:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95C042081B
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 13:02:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95C042081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbeLENCS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 08:02:18 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:45263 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726909AbeLENCS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 08:02:18 -0500
Received: from [IPv6:2001:420:44c1:2579:257d:be73:2120:ab20] ([IPv6:2001:420:44c1:2579:257d:be73:2120:ab20])
        by smtp-cloud9.xs4all.net with ESMTPA
        id UWofgN3yRUylNUWoigwl1D; Wed, 05 Dec 2018 14:02:16 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT FIXES FOR v4.20] cedrus: move control definitions to
 mpeg2-ctrls.h
Message-ID: <6d544c88-58a8-e8b1-9e79-81513e11b149@xs4all.nl>
Date:   Wed, 5 Dec 2018 14:02:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfPN6p3ajhJT/2KcUVakXFgUB44oE001tc98TvAfIPHPqyNS92OcXIB7SIdWf7eqHqZs3Bd/zAQiv2v/ITWaaPhzEf121uwyvaDX+679wXpKA0eC5SVyu
 kf5AjAbnFZTtUEi/Iod6TlRm/Fxbhw7y7Y068dP+r5eEVI6qWcI6g6luDVqvFBoNVfAS7ttuZWQD8/C0l1JkHpIVWfTTxrSaRFMblflxiLXlRoT0jf92a4WY
 mwlghC5zh9QqgXXWdgKfRREplOwuj6w4yzENWaOC3WGgiqCwl8AhZSQA6+aWcd1TnIr6BRcPdHVJ+K6fO3fMDJuDYOSO2jhFabiWd1pXXUg=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This API is not stable enough yet to be exposed in the uAPI. Move it
to a kAPI header.

Regards,

	Hans

The following changes since commit 708d75fe1c7c6e9abc5381b6fcc32b49830383d0:

  media: dvb-pll: don't re-validate tuner frequencies (2018-11-23 12:27:18 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.21q2

for you to fetch changes up to f9a88dc4e8703bfa6a40229806fbb496e4111664:

  extended-controls.rst: add note to the MPEG2 state controls (2018-12-05 13:59:16 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Hans Verkuil (2):
      mpeg2-ctrls.h: move MPEG2 state controls to non-public header
      extended-controls.rst: add note to the MPEG2 state controls

 Documentation/media/uapi/v4l/extended-controls.rst | 10 +++++++
 drivers/media/v4l2-core/v4l2-ctrls.c               |  4 +--
 include/media/mpeg2-ctrls.h                        | 86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-ctrls.h                         |  6 ++++
 include/uapi/linux/v4l2-controls.h                 | 68 ----------------------------------------------
 include/uapi/linux/videodev2.h                     |  4 ---
 6 files changed, 104 insertions(+), 74 deletions(-)
 create mode 100644 include/media/mpeg2-ctrls.h
