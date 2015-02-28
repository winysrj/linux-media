Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54351 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbbB1ROU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Feb 2015 12:14:20 -0500
Received: from axis700.grange ([87.78.139.61]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0LtZfc-1XT1241rs4-010y8p for
 <linux-media@vger.kernel.org>; Sat, 28 Feb 2015 18:14:16 +0100
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id D56A440BD9
	for <linux-media@vger.kernel.org>; Sat, 28 Feb 2015 18:14:11 +0100 (CET)
Date: Sat, 28 Feb 2015 18:14:11 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL] a fix for 4.0-rc1 + stable
Message-ID: <Pine.LNX.4.64.1502281811140.27769@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull and forward this fix.

The following changes since commit 895c8b7b4623d4f55e260e5dee2574b4f7113105:

  Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2015-02-27 16:18:33 -0800)

are available in the git repository at:


  git://linuxtv.org/gliakhovetski/v4l-dvb.git 4.0-rc1-fixes

for you to fetch changes up to ec7ed0078935780c54a4bb683b68e713e08b6037:

  soc-camera: Fix devm_kfree() in soc_of_bind() (2015-02-28 18:04:26 +0100)

----------------------------------------------------------------
Geert Uytterhoeven (1):
      soc-camera: Fix devm_kfree() in soc_of_bind()

 drivers/media/platform/soc_camera/soc_camera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Thanks
Guennadi
