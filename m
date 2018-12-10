Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEC3C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 22:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9905C2084E
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 22:27:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9905C2084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729787AbeLJW0s (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 17:26:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42642 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729778AbeLJW0p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 17:26:45 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wBAMNk7d098834
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 17:26:44 -0500
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2p9vpnbf05-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Mon, 10 Dec 2018 17:26:44 -0500
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.ibm.com>;
        Mon, 10 Dec 2018 22:26:43 -0000
Received: from b03cxnp07028.gho.boulder.ibm.com (9.17.130.15)
        by e32.co.us.ibm.com (192.168.1.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 10 Dec 2018 22:26:40 -0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id wBAMQdoK21102730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 10 Dec 2018 22:26:39 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37B5D6A047;
        Mon, 10 Dec 2018 22:26:39 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDA626A04D;
        Mon, 10 Dec 2018 22:26:37 +0000 (GMT)
Received: from oc6728276242.ibm.com (unknown [9.85.155.148])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 10 Dec 2018 22:26:37 +0000 (GMT)
From:   Eddie James <eajames@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        hverkuil@xs4all.nl, Eddie James <eajames@linux.ibm.com>
Subject: [PATCH v7 1/2] dt-bindings: media: Add Aspeed Video Engine binding documentation
Date:   Mon, 10 Dec 2018 16:26:30 -0600
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1544480791-92746-1-git-send-email-eajames@linux.ibm.com>
References: <1544480791-92746-1-git-send-email-eajames@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 18121022-0004-0000-0000-000014C02F85
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010210; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000270; SDB=6.01129916; UDB=6.00587094; IPR=6.00910049;
 MB=3.00024647; MTD=3.00000008; XFM=3.00000015; UTC=2018-12-10 22:26:42
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 18121022-0005-0000-0000-000089CE914C
Message-Id: <1544480791-92746-2-git-send-email-eajames@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-12-10_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1812100200
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Document the bindings.

Signed-off-by: Eddie James <eajames@linux.ibm.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/media/aspeed-video.txt     | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/aspeed-video.txt

diff --git a/Documentation/devicetree/bindings/media/aspeed-video.txt b/Documentation/devicetree/bindings/media/aspeed-video.txt
new file mode 100644
index 0000000..78b464a
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/aspeed-video.txt
@@ -0,0 +1,26 @@
+* Device tree bindings for Aspeed Video Engine
+
+The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs can
+capture and compress video data from digital or analog sources.
+
+Required properties:
+ - compatible:		"aspeed,ast2400-video-engine" or
+			"aspeed,ast2500-video-engine"
+ - reg:			contains the offset and length of the VE memory region
+ - clocks:		clock specifiers for the syscon clocks associated with
+			the VE (ordering must match the clock-names property)
+ - clock-names:		"vclk" and "eclk"
+ - resets:		reset specifier for the syscon reset associated with
+			the VE
+ - interrupts:		the interrupt associated with the VE on this platform
+
+Example:
+
+video-engine@1e700000 {
+    compatible = "aspeed,ast2500-video-engine";
+    reg = <0x1e700000 0x20000>;
+    clocks = <&syscon ASPEED_CLK_GATE_VCLK>, <&syscon ASPEED_CLK_GATE_ECLK>;
+    clock-names = "vclk", "eclk";
+    resets = <&syscon ASPEED_RESET_VIDEO>;
+    interrupts = <7>;
+};
-- 
1.8.3.1

