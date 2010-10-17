Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4702 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653Ab0JQUOp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 16:14:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/v2.6.37] [media] Add driver for Siliconfile SR030PC30 VGA camera
Date: Sun, 17 Oct 2010 22:14:15 +0200
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <E1P7Yvq-0001kW-Pf@www.linuxtv.org>
In-Reply-To: <E1P7Yvq-0001kW-Pf@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010172214.15773.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, October 17, 2010 21:28:29 Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media_tree.git tree:
> 
> Subject: [media] Add driver for Siliconfile SR030PC30 VGA camera
> Author:  Sylwester Nawrocki <s.nawrocki@samsung.com>
> Date:    Mon Oct 11 13:33:57 2010 -0300
> 
> Add an I2C/v4l2-subdev driver for Siliconfile SR030PC30 VGA
> camera sensor with Image Signal Processor. SR030PC30 is
> the low resolution camera sensor on Samsung Aquila boards.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  drivers/media/video/Kconfig     |    6 +
>  drivers/media/video/Makefile    |    1 +
>  drivers/media/video/sr030pc30.c |  893 +++++++++++++++++++++++++++++++++++++++
>  include/media/sr030pc30.h       |   21 +
>  4 files changed, 921 insertions(+), 0 deletions(-)

It fails to compile with this error:

drivers/media/video/sr030pc30.c: In function ‘sr030pc30_probe’:
drivers/media/video/sr030pc30.c:834: error: implicit declaration of function ‘kzalloc’
drivers/media/video/sr030pc30.c:834: warning: assignment makes pointer from integer without a cast
drivers/media/video/sr030pc30.c: In function ‘sr030pc30_remove’:
drivers/media/video/sr030pc30.c:858: error: implicit declaration of function ‘kfree’

Here is the patch to fix this:

diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/video/sr030pc30.c
index f82e1f3..ec8d875 100644
--- a/drivers/media/video/sr030pc30.c
+++ b/drivers/media/video/sr030pc30.c
@@ -18,6 +18,7 @@
 
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-mediabus.h>


Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
