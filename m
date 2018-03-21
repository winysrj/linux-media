Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:45485 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751548AbeCURd4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 13:33:56 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] debugfs-cec-error-inj: document CEC error inj debugfs ABI
Message-ID: <c30b9188-84c5-d8b6-a274-2ce33dfd3b5f@xs4all.nl>
Date: Wed, 21 Mar 2018 18:33:51 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the core of the debugfs CEC error injection ABI.

The driver specific commands are documented elsewhere and
this file points to that documentation.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/ABI/testing/debugfs-cec-error-inj | 40 +++++++++++++++++++++++++
 MAINTAINERS                                     |  1 +
 2 files changed, 41 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-cec-error-inj

diff --git a/Documentation/ABI/testing/debugfs-cec-error-inj b/Documentation/ABI/testing/debugfs-cec-error-inj
new file mode 100644
index 000000000000..122b65c5fe62
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-cec-error-inj
@@ -0,0 +1,40 @@
+What:		/sys/kernel/debug/cec/*/error-inj
+Date:		March 2018
+Contact:	Hans Verkuil <hans.verkuil@cisco.com>
+Description:
+
+The CEC Framework allows for CEC error injection commands through
+debugfs. Drivers that support this will create an error-inj file
+through which the error injection commands can be given.
+
+The basic syntax is as follows:
+
+Leading spaces/tabs are ignored. If the next character is a '#' or the
+end of the line was reached, then the whole line is ignored. Otherwise
+a command is expected.
+
+It is up to the driver to decide what commands to implement. The only
+exception is that the command 'clear' without any arguments must be
+implemented and that it will remove all current error injection
+commands.
+
+This ensures that you can always do 'echo clear >error-inj' to clear any
+error injections without having to know the details of the driver-specific
+commands.
+
+Note that the output of 'error-inj' shall be valid as input to 'error-inj'.
+So this must work:
+
+	$ cat error-inj >einj.txt
+	$ cat einj.txt >error-inj
+
+Other than these basic rules described above this ABI is not considered
+stable and may change in the future.
+
+Drivers that implement this functionality must document the commands as
+part of the CEC documentation and must keep that documentation up to date
+when changes are made.
+
+The following CEC error injection implementations exist:
+
+- Documentation/media/uapi/cec/cec-pin-error-inj.rst
diff --git a/MAINTAINERS b/MAINTAINERS
index 4e59769cec0e..55a3c61e9cfb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3307,6 +3307,7 @@ F:	include/media/cec-notifier.h
 F:	include/uapi/linux/cec.h
 F:	include/uapi/linux/cec-funcs.h
 F:	Documentation/devicetree/bindings/media/cec.txt
+F:	Documentation/ABI/testing/debugfs-cec-error-inj

 CEC GPIO DRIVER
 M:	Hans Verkuil <hans.verkuil@cisco.com>
-- 
2.15.1
