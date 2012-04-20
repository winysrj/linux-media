Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:35202 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197Ab2DTPTh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 11:19:37 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	=?UTF-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
Subject: [RFC PATCH 0/3] gspca: Implement VIDIOC_G_EXT_CTRLS and VIDIOC_S_EXT_CTRLS 
Date: Fri, 20 Apr 2012 17:19:08 +0200
Message-Id: <1334935152-16165-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <20120418153720.1359c7d2f2a3efc2c7c17b88@studenti.unina.it>
References: <20120418153720.1359c7d2f2a3efc2c7c17b88@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this is a first attempt at implementing VIDIOC_G_EXT_CTRLS and
VIDIOC_S_EXT_CTRLS, these ioclt are needed in order to make controls of
type different than V4L2_CTRL_CLASS_USER work in gspca.

An example of such a control is V4L2_CID_EXPOSURE_AUTO which a couple of gspca
subdrivers define but which can't be controlled from v4l2 userspace apps right
now.

Let me know what do you think and if you have any suggestion. If needed I will
add VIDIOC_TRY_EXT_CTRLS too.

Thanks,
   Antonio

Antonio Ospite (3):
  [media] gspca - main: rename get_ctrl to get_ctrl_index
  [media] gspca - main: factor out the logic to set and get controls
  [media] gspca - main: implement vidioc_g_ext_ctrls and
    vidioc_s_ext_ctrls

 drivers/media/video/gspca/gspca.c |  184 ++++++++++++++++++++++++-------------
 1 file changed, 119 insertions(+), 65 deletions(-)

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
