Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55669 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab1AULDw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jan 2011 06:03:52 -0500
Received: by yxt3 with SMTP id 3so487748yxt.19
        for <linux-media@vger.kernel.org>; Fri, 21 Jan 2011 03:03:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=78fcRbeyx2cSyHKFuxaAqBCC6owQ70QO-G=Xx@mail.gmail.com>
References: <AANLkTi=78fcRbeyx2cSyHKFuxaAqBCC6owQ70QO-G=Xx@mail.gmail.com>
Date: Fri, 21 Jan 2011 22:03:51 +1100
Message-ID: <AANLkTinwU6FBueaqTXwJ9VXe6rJ5UjrG2FOBFM0Jp+1i@mail.gmail.com>
Subject: [patch] Re: media_build: build fails against (ubuntu) 2.6.32 on pvrusb2-debugifc.c
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The problem was the new check function was not being called.
Signed-off-by: vincent.mcintyre@gmail.com

diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.
index 438561a..f1dd577 100755
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -485,6 +485,7 @@ sub check_other_dependencies()
        check_vzalloc();
        check_flush_work_sync();
        check_autosuspend_delay();
+       check_hex_to_bin()
 }

 # Do the basic rules
