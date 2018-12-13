Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF76C67873
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4107220879
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 13:41:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4107220879
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbeLMNlT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 08:41:19 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:44278 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729473AbeLMNlS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 08:41:18 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud7.xs4all.net with ESMTPA
        id XREngf3iadllcXREpgEECH; Thu, 13 Dec 2018 14:41:15 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Subject: [RFCv5 PATCH 0/4] Add properties support to the media controller
Date:   Thu, 13 Dec 2018 14:41:09 +0100
Message-Id: <20181213134113.15247-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfHOaWAa9T0hX0cy0lvLPmonAa9fBNHICWnMmB+u3IVCGCsJHEggH9FjzVoprc6YFyE5n8/zTY61pZmuyKsRoUVYHLbEAvZBVXmnG4CxVUyorrptV0uC2
 B1EIofqPJQdckLt2fOP4UZNWYjF6ZXF7D5OLqnAfZQJMfausF1jJeKTiwvK22BSWk3anEzKqWtzu5A==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

The main changes since RFCv4 are:

- Dropped all the indexing code that I added to make it easier to
  traverse the topology. I still think that's a good idea, but that
  can be done in a future patch.
- Split the second patch into two: the first part adds the core support,
  the second adds the functions to let drivers add properties.

An updated v4l2-ctl and v4l2-compliance that can report properties
is available here:

https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=props2

Currently I support u64, s64 and const char * property types. And also
a 'group' type that groups sub-properties. But it can be extended to any
type including binary data if needed. No array support (as we have for
controls), but there are enough reserved fields in media_v2_prop
to add this if needed.

I added properties for entities and pads to vimc, so I could test this.

Regards,

	Hans

Hans Verkuil (4):
  uapi/linux/media.h: add property support
  media controller: add properties support
  media: add functions to add properties to objects
  vimc: add property test code

 drivers/media/media-device.c              | 129 ++++++++-
 drivers/media/media-entity.c              |  90 +++++-
 drivers/media/platform/vimc/vimc-common.c |  50 ++++
 include/media/media-device.h              |   6 +
 include/media/media-entity.h              | 322 ++++++++++++++++++++++
 include/uapi/linux/media.h                |  56 ++++
 6 files changed, 639 insertions(+), 14 deletions(-)

-- 
2.19.2

