Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33848 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751221AbdB0CFf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Feb 2017 21:05:35 -0500
Received: by mail-qk0-f194.google.com with SMTP id s186so13970899qkb.1
        for <linux-media@vger.kernel.org>; Sun, 26 Feb 2017 18:04:29 -0800 (PST)
Received: from ?IPv6:2604:6000:1315:40e3:4962:a086:e12b:910a? ([2604:6000:1315:40e3:4962:a086:e12b:910a])
        by smtp.gmail.com with ESMTPSA id m30sm9595005qtg.10.2017.02.26.17.57.21
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Feb 2017 17:57:22 -0800 (PST)
To: linux-media@vger.kernel.org
From: bill murphy <gc2majortom@gmail.com>
Subject: Kaffeine commit b510bff2 won't compile
Message-ID: <bafdb165-261c-0129-e0dc-29819a55ca43@gmail.com>
Date: Sun, 26 Feb 2017 20:57:20 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Can someone double check me on this?

It seems there might be a missing header,
in the src directory, preventing the last commit from
compiling. The commit prior compiles fine. So not that big a deal, just 
letting folks know what I ran in to.

I don't see this file, 'log.h', anywhere in the src directory. Guessing 
it wasn't 'added' for tracking?

git://anongit.kde.org/kaffeine

diff between master and previous commit...just a snippet, as other files 
are including the same missing header.

diff --git a/src/dvb/dvbcam_linux.cpp b/src/dvb/dvbcam_linux.cpp
index ceb9dbd..5c9c575 100644
--- a/src/dvb/dvbcam_linux.cpp
+++ b/src/dvb/dvbcam_linux.cpp
@@ -18,11 +18,7 @@
   * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
   */

-#include <KLocalizedString>
-#include <QDebug>
-#if QT_VERSION < 0x050500
-# define qInfo qDebug
-#endif
+#include "../log.h"

  #include <errno.h>
  #include <fcntl.h>

where compile complains of that missing header...

Scanning dependencies of target kaffeine
[ 20%] Building CXX object 
src/CMakeFiles/kaffeine.dir/dvb/dvbcam_linux.cpp.o
/home/user/src2/kaffeine/src/dvb/dvbcam_linux.cpp:21:20: fatal error: 
../log.h: No such file or directory
compilation terminated.

Regards,

Bill
