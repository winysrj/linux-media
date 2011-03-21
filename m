Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:61546 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab1CUNXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 09:23:03 -0400
Date: Mon, 21 Mar 2011 14:22:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-sh@vger.kernel.org,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [PATCH 3/3] ARM: switch mackerel to dynamically manage the
 platform camera
In-Reply-To: <AANLkTikA0QDCLNSrM3FGobEzBBh9hcP_ZpyC+4YPSbx7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1103211421040.24139@axis700.grange>
References: <Pine.LNX.4.64.1102221049240.1380@axis700.grange>
 <Pine.LNX.4.64.1102221057040.1380@axis700.grange>
 <AANLkTikA0QDCLNSrM3FGobEzBBh9hcP_ZpyC+4YPSbx7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Magnus

On Wed, 16 Mar 2011, Magnus Damm wrote:

> On Tue, Feb 22, 2011 at 6:57 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Use soc_camera_platform helper functions to dynamically manage the
> > camera device.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  arch/arm/mach-shmobile/board-mackerel.c |   28 +++++++---------------------
> >  1 files changed, 7 insertions(+), 21 deletions(-)
> 
> Hi Guennadi,
> 
> Thanks for your work on this. The soc_camera_platform interface has
> become much much nicer with these patches.
> 
> I just tested patch 1/3 and patch 3/3 on my Mackerel board.

Thanks for testing!

> Unfortunately I get this printout on the console:
> 
> sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver attached to camera 0
> soc_camera_platform soc_camera_platform.0: Platform has not set
> soc_camera_device pointer!
> soc_camera_platform: probe of soc_camera_platform.0 failed with error -22
> sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver detached from camera 0
> 
> Without these two patches everything work just fine. Any ideas on how
> to fix it? I'd be happy to test V2. =)

Hm, yes, looks like I'm initialising the pointer too late. Could you, 
please, test the patch below on top, if it helps, I'll send v2.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index fbf4b79..6d7a4fd 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -50,6 +50,8 @@ static inline int soc_camera_platform_add(const struct soc_camera_link *icl,
 	if (!*pdev)
 		return -ENOMEM;
 
+	info->dev = dev;
+
 	(*pdev)->dev.platform_data = info;
 	(*pdev)->dev.release = release;
 
@@ -57,11 +59,10 @@ static inline int soc_camera_platform_add(const struct soc_camera_link *icl,
 	if (ret < 0) {
 		platform_device_put(*pdev);
 		*pdev = NULL;
-	} else {
-		info->dev = dev;
+		info->dev = NULL;
 	}
 
-	return 0;
+	return ret;
 }
 
 static inline void soc_camera_platform_del(const struct soc_camera_link *icl,
