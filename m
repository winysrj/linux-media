Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:48609 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751760AbdGUPwK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 11:52:10 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        "Hugues Fruchet" <hugues.fruchet@st.com>
Subject: [PATCH v1 0/2] OV9650 code cleanup
Date: Fri, 21 Jul 2017 17:49:39 +0200
Message-ID: <1500652181-971-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is a bunch of small fixes found when upstreaming
the OV9655 sensor driver based on OV9650 driver:
- Fix coding style (checkpatch --strict)
- Fix missing mutex_destroy, see http://www.mail-archive.com/linux-media@vger.kernel.org/msg115245.html

Hugues Fruchet (2):
  [media] ov9650: fix coding style
  [media] ov9655: fix missing mutex_destroy()

 drivers/media/i2c/ov9650.c | 67 +++++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 28 deletions(-)

-- 
1.9.1
