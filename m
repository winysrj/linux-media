Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:51232 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750988AbeC3GQu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Mar 2018 02:16:50 -0400
Received: by mail-wm0-f53.google.com with SMTP id v21so14181936wmc.1
        for <linux-media@vger.kernel.org>; Thu, 29 Mar 2018 23:16:50 -0700 (PDT)
MIME-Version: 1.0
From: asadpt iqroot <asadptiqroot@gmail.com>
Date: Fri, 30 Mar 2018 11:46:49 +0530
Message-ID: <CA+gCWtL1HiZjNaZ87RRET+tHrdzSaqor=-vQUssnaGN+6iFOdg@mail.gmail.com>
Subject: V4l2 Sensor driver and V4l2 ctrls
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

In reference sensor drivers, they used the
V4L2_CID_DV_RX_POWER_PRESENT v4l2 ctrl.
It is a standard ctrl and created using v4l2_ctrl_new_std().

The doubts are:

1. Whether in our sensor driver, we need to create this Control Id or
not. How to take the decision on this. Since this is the standard
ctrl. When we need to use these standard ctrls??

2. In Sensor driver, the ctrls creation is anything depends on the
bridge driver.
Based on bridge driver, whether we need to create any ctrls in Sensor driver.

This question belongs to design of the sensor driver.



Thanks & Regards
