Return-Path: <SRS0=HJwa=PE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E12BC43444
	for <linux-media@archiver.kernel.org>; Thu, 27 Dec 2018 18:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 343FF2148D
	for <linux-media@archiver.kernel.org>; Thu, 27 Dec 2018 18:47:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="mKP/AazL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbeL0Srg (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 27 Dec 2018 13:47:36 -0500
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:45092 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbeL0Srf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Dec 2018 13:47:35 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 2C280DA5
        for <linux-media@vger.kernel.org>; Thu, 27 Dec 2018 18:47:34 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id URYUOcfSJ_Ik for <linux-media@vger.kernel.org>;
        Thu, 27 Dec 2018 12:47:34 -0600 (CST)
Received: from mail-it1-f200.google.com (mail-it1-f200.google.com [209.85.166.200])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id EEE9CD94
        for <linux-media@vger.kernel.org>; Thu, 27 Dec 2018 12:47:33 -0600 (CST)
Received: by mail-it1-f200.google.com with SMTP id i12so21858983ita.3
        for <linux-media@vger.kernel.org>; Thu, 27 Dec 2018 10:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=R8nR53dNPd4RYPIl91TKd+B/1F15cdvfufgqwiC+HME=;
        b=mKP/AazLphlUONbLVF6BerQHnDX5VcSCQPoteYj5kP2RSopvJQBKxh18Mg/ispBTMn
         k32Qw4K2op+j4n3FZYZ/lxc/6G7mWtlrAuR4UJiWjn26+NqGhf4jQY3IWyDUkboHM+11
         nLvQmqY08YYKZG95TddCasZUyg/KfO4HmxmdvJDFdY4xCLfGLvJzNktn+q+AYhhXgnXt
         4kK3ZNjvMsh+Ui3gfdGkPnpqNEeRzpz/ZR0HwrRgTWKCpuF48s5TuFzzuWlaqqk58KkP
         upcUPw7fsK+QQEGS+5ftZXogFRyjT9eMfjYQm+CPIC49KIrrB8CSQfM1tkbdMl7cEdEi
         eK+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=R8nR53dNPd4RYPIl91TKd+B/1F15cdvfufgqwiC+HME=;
        b=N1JgEJPyP/LKCxnJiEI8DlrX0NzcZWG4L9hBxSfhn50os67oKCeAYVEMk19o0oh85j
         KGbSUNRwh9+pjRYKRpoExzOHzxdbAsKZN8UfzPP44hP2Vhz6FpUauyZaSF5CFSrTgTGp
         Bmvj8HhyUQz9hUhbk3VeFAs4GiVMbCYairgjY/lP7urpIvRwxG/pDdPHVt9d8Z9dI5aP
         FYT4J4tRnxZkT9YEjA1gfUhJ2XogtjNCXmaDHegAi2o/DXqZHRiDvPlZrnHgow/6RW/2
         Cvos2yTUWJ0nI4+mW5tYbs8qetSR66TKY5/Nz0AflxpUj+fnY/f9eircHcuZWjdYw2DT
         SlUw==
X-Gm-Message-State: AJcUukfLdRTLjnKfUQacXYWCat9I+Ax5EyPpwMtZ+uVvL4PPCWUcqVaX
        RoNv1+NNx9tQrVbFUNR/A1NBhYMiDYn2D3h/1fey1lXWe7vigpC/iRfSJQphs0RyrXGqYFM9dQD
        8hH1IlbGK2zxVVQyGGeUI7FFa/6o=
X-Received: by 2002:a6b:ec08:: with SMTP id c8mr13681066ioh.37.1545936453536;
        Thu, 27 Dec 2018 10:47:33 -0800 (PST)
X-Google-Smtp-Source: ALg8bN6jgwFjI+E6d1bcp6f8irS/8kUsBjUWYNzVOgwf/pSsEWK0zB3uwYFjR7wTo8Jb1PN88ZZcCw==
X-Received: by 2002:a6b:ec08:: with SMTP id c8mr13681058ioh.37.1545936453277;
        Thu, 27 Dec 2018 10:47:33 -0800 (PST)
Received: from cs-u-syssec1.cs.umn.edu (cs-u-syssec1.cs.umn.edu. [134.84.121.78])
        by smtp.gmail.com with ESMTPSA id b91sm15173806itd.26.2018.12.27.10.47.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Dec 2018 10:47:32 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: dvb: add return value check on Write16
Date:   Thu, 27 Dec 2018 12:47:20 -0600
Message-Id: <20181227184722.23576-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Write16 can return an error code -1 when the i2c_write fails. The
fix checks for these failures and returns the error upstream

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/media/dvb-frontends/drxd_hard.c | 30 ++++++++++++++++---------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index 684d428efb0d..0a5b15bee1d7 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -1144,6 +1144,8 @@ static int EnableAndResetMB(struct drxd_state *state)
 
 static int InitCC(struct drxd_state *state)
 {
+	int status = 0;
+
 	if (state->osc_clock_freq == 0 ||
 	    state->osc_clock_freq > 20000 ||
 	    (state->osc_clock_freq % 4000) != 0) {
@@ -1151,14 +1153,17 @@ static int InitCC(struct drxd_state *state)
 		return -1;
 	}
 
-	Write16(state, CC_REG_OSC_MODE__A, CC_REG_OSC_MODE_M20, 0);
-	Write16(state, CC_REG_PLL_MODE__A, CC_REG_PLL_MODE_BYPASS_PLL |
-		CC_REG_PLL_MODE_PUMP_CUR_12, 0);
-	Write16(state, CC_REG_REF_DIVIDE__A, state->osc_clock_freq / 4000, 0);
-	Write16(state, CC_REG_PWD_MODE__A, CC_REG_PWD_MODE_DOWN_PLL, 0);
-	Write16(state, CC_REG_UPDATE__A, CC_REG_UPDATE_KEY, 0);
+	status |= Write16(state, CC_REG_OSC_MODE__A, CC_REG_OSC_MODE_M20, 0);
+	status |= Write16(state, CC_REG_PLL_MODE__A,
+				CC_REG_PLL_MODE_BYPASS_PLL |
+				CC_REG_PLL_MODE_PUMP_CUR_12, 0);
+	status |= Write16(state, CC_REG_REF_DIVIDE__A,
+				state->osc_clock_freq / 4000, 0);
+	status |= Write16(state, CC_REG_PWD_MODE__A, CC_REG_PWD_MODE_DOWN_PLL,
+				0);
+	status |= Write16(state, CC_REG_UPDATE__A, CC_REG_UPDATE_KEY, 0);
 
-	return 0;
+	return status;
 }
 
 static int ResetECOD(struct drxd_state *state)
@@ -1312,7 +1317,10 @@ static int SC_SendCommand(struct drxd_state *state, u16 cmd)
 	int status = 0, ret;
 	u16 errCode;
 
-	Write16(state, SC_RA_RAM_CMD__A, cmd, 0);
+	status = Write16(state, SC_RA_RAM_CMD__A, cmd, 0);
+	if (status < 0)
+		return status;
+
 	SC_WaitForReady(state);
 
 	ret = Read16(state, SC_RA_RAM_CMD_ADDR__A, &errCode, 0);
@@ -1339,9 +1347,9 @@ static int SC_ProcStartCommand(struct drxd_state *state,
 			break;
 		}
 		SC_WaitForReady(state);
-		Write16(state, SC_RA_RAM_CMD_ADDR__A, subCmd, 0);
-		Write16(state, SC_RA_RAM_PARAM1__A, param1, 0);
-		Write16(state, SC_RA_RAM_PARAM0__A, param0, 0);
+		status |= Write16(state, SC_RA_RAM_CMD_ADDR__A, subCmd, 0);
+		status |= Write16(state, SC_RA_RAM_PARAM1__A, param1, 0);
+		status |= Write16(state, SC_RA_RAM_PARAM0__A, param0, 0);
 
 		SC_SendCommand(state, SC_RA_RAM_CMD_PROC_START);
 	} while (0);
-- 
2.17.1

