Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:34293 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753691AbdHWLBz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 07:01:55 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Hugues FRUCHET <hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] STM32 DCMI camera interface crop support
Message-ID: <54c92b09-71d7-907a-b159-cab8e49b8c62@xs4all.nl>
Date: Wed, 23 Aug 2017 13:01:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 0779b8855c746c90b85bfe6e16d5dfa2a6a46655:

  media: ddbridge: fix semicolon.cocci warnings (2017-08-20 10:25:22 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git stm32

for you to fetch changes up to 745df347907e36a5ecd0ac915d27b05ca4af38e9:

  stm32-dcmi: g_/s_selection crop support (2017-08-23 12:52:22 +0200)

----------------------------------------------------------------
Hugues Fruchet (4):
      stm32-dcmi: catch dma submission error
      stm32-dcmi: revisit control register handling
      stm32-dcmi: cleanup variable/fields namings
      stm32-dcmi: g_/s_selection crop support

 drivers/media/platform/stm32/stm32-dcmi.c | 491 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 430 insertions(+), 61 deletions(-)
