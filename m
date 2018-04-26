Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:41548 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754582AbeDZQZQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 12:25:16 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w3QGLEYI007290
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2018 17:25:15 +0100
Received: from mail-pg0-f72.google.com (mail-pg0-f72.google.com [74.125.83.72])
        by mx08-00252a01.pphosted.com with ESMTP id 2hg236jrf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2018 17:25:15 +0100
Received: by mail-pg0-f72.google.com with SMTP id x205so7293136pgx.19
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2018 09:25:14 -0700 (PDT)
MIME-Version: 1.0
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Thu, 26 Apr 2018 17:25:12 +0100
Message-ID: <CAAoAYcNiAMafVk+-JasZZso7JwEN79FQPpBuGmbQZRhdSuQEqw@mail.gmail.com>
Subject: Compressed formats - framed or unframed?
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All.

I'm trying to get a V4L2 M2M driver sorted for the Raspberry Pi to
allow access to the video codecs. Much of it is working fine.

One thing that isn't clear relates to video decode. Do the compressed
formats (eg V4L2_PIX_FMT_H264) have to be framed into one frame per
V4L2 buffer, or is providing unframed chunks of an elementary stream
permitted. The docs only say "H264 video elementary stream with start
codes.". Admittedly timestamps are nearly meaningless if you feed in
unframed data, but could potentially be interpolated.

What does other hardware support?

I could handle it either way, but there are some performance tweaks I
can do if I know the data must be framed.

Thanks in advance.
  Dave
