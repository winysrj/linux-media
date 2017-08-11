Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57147
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750868AbdHKAQ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 20:16:58 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH RESEND 0/3] v4l2-compat-ioctl32.c: better detect pointer controls
Date: Thu, 10 Aug 2017 21:16:49 -0300
Message-Id: <cover.1502409182.git.mchehab@s-opensource.com>
In-Reply-To: <f7340d67-cf7c-3407-e59a-aa0261185e82@xs4all.nl>
References: <f7340d67-cf7c-3407-e59a-aa0261185e82@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the past, only string controls were pointers. That changed when compounded
types got added, but the compat32 code was not updated.

We could just add those controls there, but maintaining it is flaw, as we
often forget about the compat code. So, instead, rely on the control type,
as this is always updated when new controls are added.

As both v4l2-ctrl and compat32 code are at videodev.ko module, we can
move the ctrl_is_pointer() helper function to v4l2-ctrl.c.

---

Re-sending this patch series, as it was c/c to the linux-doc ML by mistake.

Mauro Carvalho Chehab (3):
  media: v4l2-ctrls.h: better document the arguments for v4l2_ctrl_fill
  media: v4l2-ctrls: prepare the function to be used by compat32 code
  media: compat32: reimplement ctrl_is_pointer()

 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 18 +---------
 drivers/media/v4l2-core/v4l2-ctrls.c          | 49 +++++++++++++++++++++++++--
 include/media/v4l2-ctrls.h                    | 28 ++++++++++-----
 3 files changed, 67 insertions(+), 28 deletions(-)

-- 
2.13.3
