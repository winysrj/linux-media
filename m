Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:42087 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751125AbdFBMSf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Jun 2017 08:18:35 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v52CDumC012139
        for <linux-media@vger.kernel.org>; Fri, 2 Jun 2017 13:18:34 +0100
Received: from mail-wm0-f71.google.com (mail-wm0-f71.google.com [74.125.82.71])
        by mx07-00252a01.pphosted.com with ESMTP id 2apxuyawfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Fri, 02 Jun 2017 13:18:33 +0100
Received: by mail-wm0-f71.google.com with SMTP id 139so16780361wmf.5
        for <linux-media@vger.kernel.org>; Fri, 02 Jun 2017 05:18:33 -0700 (PDT)
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
To: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>
Subject: [PATCH 0/3] tc358743: minor driver fixes
Date: Fri,  2 Jun 2017 13:18:11 +0100
Message-Id: <cover.1496397071.git.dave.stevenson@raspberrypi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These 3 patches for TC358743 came out of trying to use the
existing driver with a new Raspberry Pi CSI-2 receiver driver.

A couple of the subdevice API calls were not implemented or
otherwise gave odd results. Those are fixed.

The TC358743 interface board being used didn't have the IRQ
line wired up to the SoC. "interrupts" is listed as being
optional in the DT binding, but the driver didn't actually
function if it wasn't provided.

Dave Stevenson (3):
  [media] tc358743: Add enum_mbus_code
  [media] tc358743: Setup default mbus_fmt before registering
  [media] tc358743: Add support for platforms without IRQ line

 drivers/media/i2c/tc358743.c | 59 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

-- 
2.7.4
