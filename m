Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:50196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab1CPUYg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 16:24:36 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2GKOZTL021241
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 16:24:35 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 1/6] docs: fix typo in lirc_device_interface.xml
Date: Wed, 16 Mar 2011 16:24:26 -0400
Message-Id: <1300307071-19665-2-git-send-email-jarod@redhat.com>
In-Reply-To: <1300307071-19665-1-git-send-email-jarod@redhat.com>
References: <1300307071-19665-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Reported-by: Daniel Burr <dburr@topcon.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 .../DocBook/v4l/lirc_device_interface.xml          |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/v4l/lirc_device_interface.xml b/Documentation/DocBook/v4l/lirc_device_interface.xml
index 68134c0..0e0453f 100644
--- a/Documentation/DocBook/v4l/lirc_device_interface.xml
+++ b/Documentation/DocBook/v4l/lirc_device_interface.xml
@@ -45,7 +45,7 @@ describing an IR signal are read from the chardev.</para>
 <para>The data written to the chardev is a pulse/space sequence of integer
 values. Pulses and spaces are only marked implicitly by their position. The
 data must start and end with a pulse, therefore, the data must always include
-an unevent number of samples. The write function must block until the data has
+an uneven number of samples. The write function must block until the data has
 been transmitted by the hardware.</para>
 </section>
 
-- 
1.7.1

