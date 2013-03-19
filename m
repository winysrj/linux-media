Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f174.google.com ([209.85.128.174]:50573 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab3CSPlo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 11:41:44 -0400
Received: by mail-ve0-f174.google.com with SMTP id pb11so526895veb.33
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2013 08:41:44 -0700 (PDT)
From: Eduardo Valentin <edubezval@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 0/4] media: si4713: minor updates
Date: Tue, 19 Mar 2013 11:41:30 -0400
Message-Id: <1363707694-27224-1-git-send-email-edubezval@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro and Hans,

Here are a couple of minor changes for si4713 FM transmitter driver.

These changes are also available here:
https://git.gitorious.org/si4713/si4713.git

All best,

Eduardo Valentin (4):
  media: radio: CodingStyle changes on si4713
  media: radio: correct module license (==> GPL v2)
  media: radio: add driver owner entry for radio-si4713
  media: radio: add module alias entry for radio-si4713

 drivers/media/radio/radio-si4713.c |   57 ++++++++++++++++++-----------------
 1 files changed, 29 insertions(+), 28 deletions(-)

-- 
1.7.7.1.488.ge8e1c

