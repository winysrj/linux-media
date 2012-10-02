Return-path: <linux-media-owner@vger.kernel.org>
Received: from ftp.poss.co.nz ([210.54.213.75]:1878 "EHLO riffraff.iposs.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751401Ab2JBKmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2012 06:42:16 -0400
From: Michael West <michael@iposs.co.nz>
To: Michael West <michael@iposs.co.nz>,
	Martin Burnicki <martin.burnicki@burnicki.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 2 Oct 2012 23:42:10 +1300
Subject: RE: Current media_build doesn't succeed building on kernel 3.1.10
Message-ID: <DCBB30B3D32C824F800041EE82CABAAE03203D63BAD7@duckworth.iposs.co.nz>
References: <201209302052.42723.martin.burnicki@burnicki.net>
 <20121001110241.2f5ab052@redhat.com>
 <201210012131.13441.martin.burnicki@burnicki.net>
 <DCBB30B3D32C824F800041EE82CABAAE03203D63BAD2@duckworth.iposs.co.nz>
In-Reply-To: <DCBB30B3D32C824F800041EE82CABAAE03203D63BAD2@duckworth.iposs.co.nz>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Was looking to make a better fix than trying to just remove that line while the Make was busy running so I made a quick simple backports patch.
This patch can be applied to the media_build git and it will remove the devm_regulator_bulk_get function call that is not supported in pre 3.4 kernels from s5k4ecgx.c.  I'm sure there are better ways to fix this build problem but this seems to work for now anyway.
---
 backports/backports.txt       |    3 +++
 backports/v3.3_s5k4ecgx.patch |   12 ++++++++++++
 2 files changed, 15 insertions(+)
 create mode 100644 backports/v3.3_s5k4ecgx.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index 5554d9e..274945d 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -24,6 +24,9 @@
 add api_version.patch
 add pr_fmt.patch
 
+[3.3.255]
+add v3.3_s5k4ecgx.patch
+
 [3.1.255]
 add v3.1_no_export_h.patch
 add v3.1_no_pm_qos.patch
diff --git a/backports/v3.3_s5k4ecgx.patch b/backports/v3.3_s5k4ecgx.patch
new file mode 100644
index 0000000..0e44163
--- /dev/null
+++ b/backports/v3.3_s5k4ecgx.patch
@@ -0,0 +1,12 @@
+diff -r drivers/media/i2c/s5k4ecgx.c
+--- a/drivers/media/i2c/s5k4ecgx.c	2012-10-02 15:32:07.309032679 +1300
++++ b/drivers/media/i2c/s5k4ecgx.c	2012-10-02 15:31:22.052994719 +1300
+@@ -974,8 +974,6 @@
+ 	for (i = 0; i < S5K4ECGX_NUM_SUPPLIES; i++)
+ 		priv->supplies[i].supply = s5k4ecgx_supply_names[i];
+ 
+-	ret = devm_regulator_bulk_get(&client->dev, S5K4ECGX_NUM_SUPPLIES,
+-				 priv->supplies);
+ 	if (ret) {
+ 		dev_err(&client->dev, "Failed to get regulators\n");
+ 		goto out_err2;
-- 
1.7.9.5
