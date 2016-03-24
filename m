Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:34383 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbcCXLX4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 07:23:56 -0400
Received: by mail-wm0-f41.google.com with SMTP id p65so269657453wmp.1
        for <linux-media@vger.kernel.org>; Thu, 24 Mar 2016 04:23:56 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org
Subject: [PATCH 0/3] [media] c8sectpfe: Various driver fixups
Date: Thu, 24 Mar 2016 11:23:49 +0000
Message-Id: <1458818632-25552-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This series includes a few fixes for the c8sectpfe Linux dvb demux driver.

The first fixes a bug introduced in the review process to the circular 
buffer WP management. The second re-works the firmware loading code to not
rely on the CONFIG_FW_LOADER_USER_HELPER_FALLBACK which was removed in
a previous patch. The third patch simly demotes a print statement to
dev_dbg.

regards,

Peter.

Peter Griffin (3):
  [media] c8sectpfe: Fix broken circular buffer wp management
  [media] c8sectpfe: Demote print to dev_dbg
  [media] c8sectpfe: Rework firmware loading mechanism

 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  | 69 ++++++++--------------
 1 file changed, 24 insertions(+), 45 deletions(-)

-- 
1.9.1

