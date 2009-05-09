Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50761 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752218AbZEITpg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 May 2009 15:45:36 -0400
Date: Sat, 9 May 2009 21:45:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] soc-camera: Fix section mismatch warning
In-Reply-To: <20090509062726.22d18182@pedra.chehab.org>
Message-ID: <Pine.LNX.4.64.0905092139020.10748@axis700.grange>
References: <Pine.LNX.4.64.0905071841331.9460@axis700.grange>
 <20090509062726.22d18182@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

modpost needs a __refdata marker in driver structs to ensure references to
.probe and .remove functions from .devinit.text and .devexit.text sections
respectively are valid. Add __refdata to soc_camera_pdrv platform driver.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

> Applied, but it is not producing two section mismatches. Please fix it and send
> this patch alone, ASAP, since I intend to fold it together with your patch, at my -git.

Below. Also available as usual from

http://linuxtv.org/hg/~gliakhovetski/v4l-dvb

changeset

01/01: soc-camera: Fix section mismatch warning
http://linuxtv.org/hg/~gliakhovetski/v4l-dvb?cmd=changeset;node=203422fec1b2

 drivers/media/video/soc_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index fecd7e7..2014e9e 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1203,7 +1203,7 @@ static int __devexit soc_camera_pdrv_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver soc_camera_pdrv = {
+static struct platform_driver __refdata soc_camera_pdrv = {
 	.probe	= soc_camera_pdrv_probe,
 	.remove	= __exit_p(soc_camera_pdrv_remove),
 	.driver	= {
-- 
1.6.2.4

