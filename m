Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:46358 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751190AbdESKFY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 06:05:24 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: <linux-media@vger.kernel.org>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v1] ATMEL ISI code cleanup
Date: Fri, 19 May 2017 12:04:51 +0200
Message-ID: <1495188292-3113-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is a bunch of small fixes found when upstreaming
the ST DCMI driver based on ATMEL ISI driver.

Review remarks can be found here:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg112338.html:
- Ensure that ISI is clocked before starting sensor sub device.
- Remove un-needed type check in try_fmt().
- Use clamp() macro for ISC hardware capabilities.
- Fix wrong tabulation to space.

Please note that this was not tested on a real hardware,
only compiled in x86 environment to check build.

Hugues Fruchet (1):
  [media] atmel-isi: code cleanup

 drivers/media/platform/atmel/atmel-isi.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

-- 
1.9.1
