Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 334F4C43387
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 15:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CD4E206C0
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 15:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbeLNPnf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 10:43:35 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:58683 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726520AbeLNPnf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 10:43:35 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud7.xs4all.net with ESMTPA
        id XpcSgqK2FdllcXpcTgJJAC; Fri, 14 Dec 2018 16:43:33 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 0/2] v4l2-mem2mem: add job_write() to support encoders
Date:   Fri, 14 Dec 2018 16:43:14 +0100
Message-Id: <20181214154316.62011-1-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfE2gd1jVKlCvESmiEaleHmfcQkPS1Y+WCzIGqEPxfP1Dvz3AEIleISlttyV3C9tAlKxNeMeUh7zF5CWbtvS5qdQstEl+EqB0ltW7BhlE2I29OpS9ZHoo
 sSTH4FL+lhmIZMhqtD8LxD+nODtUwTLtuC8DHgpIxUBFR46b5Up8DE/tmL6PQMYwbwPL/smtglIdBmjanqqCTmHN340tVkAMubaKIBd3kmTlIJM+WaeSMVLl
 895mSFr4tirjeq2kJ2oVm3xESK8pPijQv8KTYyipU+P+JjWEzGLRVl6wpu+0gG/o
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

The m2m framework is not quite symmetrical: decoders can process multiple
output buffers in job_ready until enough buffers have arrived so a frame
can be decoded.

However, encoders do not have an equivalent where multiple capture buffers
can be used to write the compressed frame. They expect that the provided
capture buffer is always large enough to contain the full compressed
frame.

This patch adds a job_write() callback and a v4l2_m2m_job_writing()
function to tell the m2m framework that the job isn't finished but that
it is waiting for more capture buffers so it can write the remaining
compressed data to the buffers.

The first patch adds the support for this to the m2m framework, the
second patch adapts vicodec to use it.

Let me know if there are any comments! It would be even better if this
could be tested in a real stateful encoder.

Regards,

	Hans

Hans Verkuil (2):
  v4l2-mem2mem: add job_write callback
  vicodec: add encoder support to write to multiple buffers

 drivers/media/platform/vicodec/vicodec-core.c | 91 +++++++++++++++----
 drivers/media/v4l2-core/v4l2-mem2mem.c        | 61 +++++++++++--
 include/media/v4l2-mem2mem.h                  | 27 +++++-
 3 files changed, 152 insertions(+), 27 deletions(-)

-- 
2.19.2

