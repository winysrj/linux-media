Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35662 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdE3MfF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 08:35:05 -0400
Received: by mail-pf0-f180.google.com with SMTP id n23so71285233pfb.2
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 05:35:04 -0700 (PDT)
Received: from ubuntu.windy (c122-106-153-7.carlnfd1.nsw.optusnet.com.au. [122.106.153.7])
        by smtp.gmail.com with ESMTPSA id m18sm23197401pfj.108.2017.05.30.05.35.02
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 May 2017 05:35:03 -0700 (PDT)
Date: Tue, 30 May 2017 22:35:10 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] Fix failure of media_build build script
Message-ID: <20170530123508.GA9404@ubuntu.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I was trying to run build --main-git without the --depth option and
it went splat. The attached series fixes my problem, possibly not
entirely correctly for all cases, in the first patch. The other two
patches are small cleanups that should make things more legible.

Vincent McIntyre (3):
  Use a better name for the upstream remote.
  Add a helper to simplify all the system-or-die calls
  Convert remaining system-or-die calls

 build | 76 +++++++++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 44 insertions(+), 32 deletions(-)

-- 
2.7.4
