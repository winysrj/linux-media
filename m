Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759131Ab0DHVe0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Apr 2010 17:34:26 -0400
Message-ID: <4BBE4BDE.80500@redhat.com>
Date: Thu, 08 Apr 2010 18:34:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 8/8] V4L/DVB: ir-core: move subsystem internal calls to
 ir-core-priv.h
References: <cover.1270754989.git.mchehab@redhat.com> <20100408163716.70862743@pedra>
In-Reply-To: <20100408163716.70862743@pedra>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> ir-core.h has the kABI to be used by the bridge drivers, when needing to register
> IR protocols and pass IR events. However, the same file also contains IR subsystem
> internal calls, meant to be used inside ir-core and between ir-core and the raw
> decoders.
> 
> Better to move those functions to an internal header, for some reasons:
> 
> 1) Header will be a little more cleaner;
> 
> 2) It avoids the need of recompile everything (bridge/hardware drivers, etc),
>    just because a new decoder were added, or some other internal change were needed;
> 
> 3) Better organize the ir-core API, splitting the functions that are internal to
>    IR core and the ancillary drivers (decoders, lirc_dev) from the features that
>    should be exported to IR subsystem clients.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  create mode 100644 drivers/media/IR/ir-core-priv.h

This cleanup were too aggressive:

drivers/media/dvb/ttpci/budget-ci.c: In function ‘msp430_ir_interrupt’:
drivers/media/dvb/ttpci/budget-ci.c:163: error: implicit declaration of function ‘ir_keydown’

We need ir_keydown() / ir_repeat() for in-hardware decoders. I'm folding it
with this patch:

diff --git a/drivers/media/IR/ir-core-priv.h b/drivers/media/IR/ir-core-priv.h
index ab785bc..8d97d6c 100644
--- a/drivers/media/IR/ir-core-priv.h
+++ b/drivers/media/IR/ir-core-priv.h
@@ -62,8 +62,6 @@ struct ir_raw_event_ctrl {
 
 u32 ir_g_keycode_from_table(struct input_dev *input_dev,
                            u32 scancode);
-void ir_repeat(struct input_dev *dev);
-void ir_keydown(struct input_dev *dev, int scancode, u8 toggle);
 
 /*
  * Routines from ir-sysfs.c - Meant to be called only internally inside
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index 40b6250..ab3bd30 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -122,6 +122,9 @@ static inline int ir_input_register(struct input_dev *dev,
 
 void ir_input_unregister(struct input_dev *input_dev);
 
+void ir_repeat(struct input_dev *dev);
+void ir_keydown(struct input_dev *dev, int scancode, u8 toggle);
+
 /* From ir-raw-event.c */
 
 void ir_raw_event_handle(struct input_dev *input_dev);



-- 

Cheers,
Mauro
