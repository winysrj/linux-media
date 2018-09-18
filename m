Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59816 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbeIRAbS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 20:31:18 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Jan Kara <jack@suse.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        linux-ext4@vger.kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: [PATCH] docs: fix some broken documentation references
Date: Mon, 17 Sep 2018 15:02:34 -0400
Message-Id: <6b47bf56b898c48a0dc3cd42283c9e5c7c23367a.1537210894.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some documentation files received recent changes and are
pointing to wrong places.

Those references can easily fixed with the help of a
script:

	$ ./scripts/documentation-file-ref-check --fix

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 Documentation/filesystems/dax.txt  | 2 +-
 Documentation/filesystems/ext2.txt | 2 +-
 MAINTAINERS                        | 4 ++--
 net/bridge/Kconfig                 | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/dax.txt b/Documentation/filesystems/dax.txt
index 70cb68bed2e8..bc393e0a22b8 100644
--- a/Documentation/filesystems/dax.txt
+++ b/Documentation/filesystems/dax.txt
@@ -75,7 +75,7 @@ exposure of uninitialized data through mmap.
 
 These filesystems may be used for inspiration:
 - ext2: see Documentation/filesystems/ext2.txt
-- ext4: see Documentation/filesystems/ext4.txt
+- ext4: see Documentation/filesystems/ext4/ext4.rst
 - xfs:  see Documentation/filesystems/xfs.txt
 
 
diff --git a/Documentation/filesystems/ext2.txt b/Documentation/filesystems/ext2.txt
index 81c0becab225..a45c9fc0747b 100644
--- a/Documentation/filesystems/ext2.txt
+++ b/Documentation/filesystems/ext2.txt
@@ -358,7 +358,7 @@ and are copied into the filesystem.  If a transaction is incomplete at
 the time of the crash, then there is no guarantee of consistency for
 the blocks in that transaction so they are discarded (which means any
 filesystem changes they represent are also lost).
-Check Documentation/filesystems/ext4.txt if you want to read more about
+Check Documentation/filesystems/ext4/ext4.rst if you want to read more about
 ext4 and journaling.
 
 References
diff --git a/MAINTAINERS b/MAINTAINERS
index 9989925f658d..078a4cf6d064 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -840,7 +840,7 @@ ANALOG DEVICES INC ADGS1408 DRIVER
 M:	Mircea Caprioru <mircea.caprioru@analog.com>
 S:	Supported
 F:	drivers/mux/adgs1408.c
-F:	Documentation/devicetree/bindings/mux/adgs1408.txt
+F:	Documentation/devicetree/bindings/mux/adi,adgs1408.txt
 
 ANALOG DEVICES INC ADP5061 DRIVER
 M:	Stefan Popa <stefan.popa@analog.com>
@@ -5515,7 +5515,7 @@ W:	http://ext4.wiki.kernel.org
 Q:	http://patchwork.ozlabs.org/project/linux-ext4/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
 S:	Maintained
-F:	Documentation/filesystems/ext4.txt
+F:	Documentation/filesystems/ext4/ext4.rst
 F:	fs/ext4/
 
 Extended Verification Module (EVM)
diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
index aa0d3b2f1bb7..3625d6ade45c 100644
--- a/net/bridge/Kconfig
+++ b/net/bridge/Kconfig
@@ -17,7 +17,7 @@ config BRIDGE
 	  other third party bridge products.
 
 	  In order to use the Ethernet bridge, you'll need the bridge
-	  configuration tools; see <file:Documentation/networking/bridge.txt>
+	  configuration tools; see <file:Documentation/networking/bridge.rst>
 	  for location. Please read the Bridge mini-HOWTO for more
 	  information.
 
-- 
2.17.1
