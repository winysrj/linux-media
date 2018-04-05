Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f53.google.com ([209.85.160.53]:35761 "EHLO
        mail-pl0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751785AbeDEShI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Apr 2018 14:37:08 -0400
Received: by mail-pl0-f53.google.com with SMTP id 61-v6so18409740plb.2
        for <linux-media@vger.kernel.org>; Thu, 05 Apr 2018 11:37:08 -0700 (PDT)
Received: from wrs (S01060000f8106ce7.cg.shawcable.net. [68.146.194.195])
        by smtp.gmail.com with ESMTPSA id e3sm16477853pfb.120.2018.04.05.11.37.06
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 05 Apr 2018 11:37:06 -0700 (PDT)
Message-ID: <1522953425.28398.4.camel@gmail.com>
Subject: HVR1600 IR Blaster
From: Warren Sturm <warren.sturm@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 05 Apr 2018 12:37:05 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is there a way to get the IR Blaster of the HVR1600 card working under
v4.15+ kernels?

It seems that lrc_zilog BUGs under 4.15+ and has gone missing in 4.16.


Thanks.
