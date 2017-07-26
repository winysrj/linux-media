Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms-10.1blu.de ([178.254.4.101]:43532 "EHLO ms-10.1blu.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750918AbdGZHGl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Jul 2017 03:06:41 -0400
Received: from [139.6.3.95]
        by ms-10.1blu.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christoph@wempe.net>)
        id 1daGP2-0006dL-VJ
        for linux-media@vger.kernel.org; Wed, 26 Jul 2017 09:06:40 +0200
To: linux-media@vger.kernel.org
From: Christoph Wempe <christoph@wempe.net>
Subject: distro-specific hint for Raspbian
Message-ID: <ee2b53ed-7436-d310-1055-65062c10db2f@wempe.net>
Date: Wed, 26 Jul 2017 09:06:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I want to suggest to add a "distro-specific hint" for Raspbian.

I got this message:
--- snip ---
Checking if the needed tools for Raspbian GNU/Linux 8.0 (jessie) are 
available
ERROR: please install "lsdiff", otherwise, build won't work.
ERROR: please install "Proc::ProcessTable", otherwise, build won't work.
I don't know distro Raspbian GNU/Linux 8.0 (jessie). So, I can't provide 
you a hint with the package names.
--- snip ---

I solved the dependencies like suggested here: 
https://patchwork.linuxtv.org/patch/7067/ 
<https://patchwork.linuxtv.org/patch/7067/>

Since Raspbian is based on Debian, I guess it would be save to link this 
to `give_ubuntu_hints`.


Best regards
Christoph
