Return-Path: <SRS0=npIJ=QD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF7CC282C0
	for <linux-media@archiver.kernel.org>; Sun, 27 Jan 2019 05:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F390214D8
	for <linux-media@archiver.kernel.org>; Sun, 27 Jan 2019 05:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbfA0F4u convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Sun, 27 Jan 2019 00:56:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53987 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbfA0F4u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Jan 2019 00:56:50 -0500
Received: from mail-pf1-f200.google.com ([209.85.210.200])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1gndR2-000051-Kz
        for linux-media@vger.kernel.org; Sun, 27 Jan 2019 05:56:48 +0000
Received: by mail-pf1-f200.google.com with SMTP id y88so11256284pfi.9
        for <linux-media@vger.kernel.org>; Sat, 26 Jan 2019 21:56:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=4xRVWx0P9o3ianN9URrhECoEWa4/HNDtRpiCoJtoqns=;
        b=OXV6BWwaXT2z0ahFCsGtFocfhu7Wso0+pUPntt7zqmhNpXZmyIjkZX3pd/+y2sQrnl
         4ZRMsMFUMxMWOIJq0WEVXLz572AWDaUtZdeNDMpT0o2zW3aDN0augGKXRkYPsrMfGO81
         4dXJlHvRI1w+Qb2JIlj2li0wk7+sltjdHZB89iEHl7uKddXzVx5rBxb1LH+YhyBuY67s
         aA/3pClXysLKh6rjY1kcaldlBNTFIywP9GZFtI+walJUgJeH35H7kUD5HPtTXDZd6bkS
         1KTew0mRaYzOsODtqs+LrAlK6wLiZ4hCumUigmwADhe6D7gJ1PmUSNAcmxUHytE7qLJv
         EY7A==
X-Gm-Message-State: AJcUukdunyNpvDslbSlORT5WNY/dlqa5dz+TJdThbp0AULS/TzfVDhTf
        rJfdz7JIHEsiu9eeFPkHE2U8L6gaF8ly0ixJP4s/MMKLLdkO0GAU6xgDypGeJCEr4NTZqRdoqfB
        ZJzDvzEpNYDfNo8W3if3KGls+Ha52t2vMXNKgNBym
X-Received: by 2002:a17:902:1008:: with SMTP id b8mr16666686pla.252.1548568607056;
        Sat, 26 Jan 2019 21:56:47 -0800 (PST)
X-Google-Smtp-Source: ALg8bN7Os6Lpx5j4KxfvMW6wGpkca+X4FORQ4PW8Q3HyyHzKub9YPLO+A7ws+TPjWYpZUgC6Oeug8g==
X-Received: by 2002:a17:902:1008:: with SMTP id b8mr16666677pla.252.1548568606720;
        Sat, 26 Jan 2019 21:56:46 -0800 (PST)
Received: from 2001-b011-380f-13aa-5df5-fc0f-304e-fb4c.dynamic-ip6.hinet.net (2001-b011-380f-13aa-5df5-fc0f-304e-fb4c.dynamic-ip6.hinet.net. [2001:b011:380f:13aa:5df5:fc0f:304e:fb4c])
        by smtp.gmail.com with ESMTPSA id t24sm53955958pfm.127.2019.01.26.21.56.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Jan 2019 21:56:46 -0800 (PST)
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: ipu3-imgu 0000:00:05.0: required queues are disabled
Message-Id: <7F8ED1B6-5070-437A-A745-AE017D8CE0DF@canonical.com>
Date:   Sun, 27 Jan 2019 13:56:42 +0800
Cc:     bingbu.cao@intel.com, yong.zhi@intel.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
To:     sakari.ailus@linux.intel.com
X-Mailer: Apple Mail (2.3445.102.3)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

We have a bug report [1] that the ipu3 doesn’t work.
Does ipu3 need special userspace to work?

[1] https://bugs.launchpad.net/bugs/1812114

Kai-Heng
