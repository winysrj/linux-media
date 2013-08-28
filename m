Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4018 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab3H1G22 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 02:28:28 -0400
Received: from tschai.lan (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr1.xs4all.nl (8.13.8/8.13.8) with ESMTP id r7S6SPmq012951
	for <linux-media@vger.kernel.org>; Wed, 28 Aug 2013 08:28:27 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 75F4C2A0761
	for <linux-media@vger.kernel.org>; Wed, 28 Aug 2013 08:28:18 +0200 (CEST)
Message-ID: <521D9882.4080401@xs4all.nl>
Date: Wed, 28 Aug 2013 08:28:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] cx88 regression fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

Here is a fix for a cx88 regression introduced in 3.11.

Repost of an earlier pull request where I erroneously said that it was a 3.10
regression, which isn't true. The CC to stable is removed in this updated pull
request.

Regards,

	Hans

The following changes since commit 43054ecced8ae77c805470447d72da4fdc276e02:

  [media] davinci: vpif_capture: fix error return code in vpif_probe() (2013-08-26 07:54:47 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cx88fix

for you to fetch changes up to 5dce3635bf803cfe9dde84e00f5f9594439e6c02:

  cx88: Fix regression: CX88_AUDIO_WM8775 can't be 0. (2013-08-28 08:23:58 +0200)

----------------------------------------------------------------
Hans Verkuil (1):
      cx88: Fix regression: CX88_AUDIO_WM8775 can't be 0.

 drivers/media/pci/cx88/cx88.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
