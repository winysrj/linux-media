Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3113 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaH2Kxf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Aug 2014 06:53:35 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr12.xs4all.nl (8.13.8/8.13.8) with ESMTP id s7TArVNv057862
	for <linux-media@vger.kernel.org>; Fri, 29 Aug 2014 12:53:33 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 56DE22A0757
	for <linux-media@vger.kernel.org>; Fri, 29 Aug 2014 12:53:28 +0200 (CEST)
Message-ID: <54005BA8.1040904@xs4all.nl>
Date: Fri, 29 Aug 2014 12:53:28 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.17] cx18: fix kernel oops
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit b250392f7b5062cf026b1423e27265e278fd6b30:

  [media] media: ttpci: fix av7110 build to be compatible with CONFIG_INPUT_EVDEV (2014-08-21 15:25:38 -0500)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cx18

for you to fetch changes up to cda8742f8990ab5e2ca405d6cbe038b7f03e61e4:

  cx18: fix kernel oops with tda8290 tuner (2014-08-26 08:20:08 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      cx18: fix kernel oops with tda8290 tuner

 drivers/media/pci/cx18/cx18-driver.c | 1 +
 1 file changed, 1 insertion(+)
