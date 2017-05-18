Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40966
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756000AbdEROGz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 10:06:55 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Michael Buesch <m@bues.ch>
Subject: [PATCH 1/4] [media] tw5864, fc0011: better handle WARN_ON()
Date: Thu, 18 May 2017 11:06:43 -0300
Message-Id: <754069659fbb44b458d8a8bef67d8f3f235d0c87.1495116400.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As such macro will check if the expression is true, it may fall through, as
warned:

In file included from ./include/uapi/linux/stddef.h:1:0,
                 from ./include/linux/stddef.h:4,
                 from ./include/uapi/linux/posix_types.h:4,
                 from ./include/uapi/linux/types.h:13,
                 from ./include/linux/types.h:5,
                 from ./drivers/media/dvb-core/dvb_frontend.h:35,
                 from drivers/media/tuners/fc0011.h:4,
                 from drivers/media/tuners/fc0011.c:20:
drivers/media/tuners/fc0011.c: In function 'fc0011_set_params':
./include/linux/compiler.h:179:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
 # define unlikely(x) __builtin_expect(!!(x), 0)
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
./include/asm-generic/bug.h:109:2: note: in expansion of macro 'unlikely'
  unlikely(__ret_warn_on);     \
  ^~~~~~~~
drivers/media/tuners/fc0011.c:344:3: note: in expansion of macro 'WARN_ON'
   WARN_ON(1);
   ^~~~~~~
drivers/media/tuners/fc0011.c:345:2: note: here
  case 0:
  ^~~~
In file included from ./include/uapi/linux/stddef.h:1:0,
                 from ./include/linux/stddef.h:4,
                 from ./include/uapi/linux/posix_types.h:4,
                 from ./include/uapi/linux/types.h:13,
                 from ./include/linux/types.h:5,
                 from ./include/linux/list.h:4,
                 from ./include/linux/module.h:9,
                 from drivers/media/pci/tw5864/tw5864-video.c:17:
drivers/media/pci/tw5864/tw5864-video.c: In function 'tw5864_fmt_vid_cap':
./include/linux/compiler.h:179:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
 # define unlikely(x) __builtin_expect(!!(x), 0)
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
./include/asm-generic/bug.h:68:2: note: in expansion of macro 'unlikely'
  unlikely(__ret_warn_on);    \
  ^~~~~~~~
drivers/media/pci/tw5864/tw5864-video.c:547:3: note: in expansion of macro 'WARN_ON_ONCE'
   WARN_ON_ONCE(1);
   ^~~~~~~~~~~~
drivers/media/pci/tw5864/tw5864-video.c:548:2: note: here
  case STD_NTSC:
  ^~~~

On both cases, it means an error, so, let's return an error
code, to make gcc happy.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/tw5864/tw5864-video.c | 1 +
 drivers/media/tuners/fc0011.c           | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index 2a044be729da..e7bd2b8484e3 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -545,6 +545,7 @@ static int tw5864_fmt_vid_cap(struct file *file, void *priv,
 	switch (input->std) {
 	default:
 		WARN_ON_ONCE(1);
+		return -EINVAL;
 	case STD_NTSC:
 		f->fmt.pix.height = 480;
 		break;
diff --git a/drivers/media/tuners/fc0011.c b/drivers/media/tuners/fc0011.c
index 192b1c7740df..145407dee3db 100644
--- a/drivers/media/tuners/fc0011.c
+++ b/drivers/media/tuners/fc0011.c
@@ -342,6 +342,7 @@ static int fc0011_set_params(struct dvb_frontend *fe)
 	switch (vco_sel) {
 	default:
 		WARN_ON(1);
+		return -EINVAL;
 	case 0:
 		if (vco_cal < 8) {
 			regs[FC11_REG_VCOSEL] &= ~(FC11_VCOSEL_1 | FC11_VCOSEL_2);
-- 
2.9.3
