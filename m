Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41004 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933344AbdC3KqL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 06:46:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH v2 01/22] tmplcvt: make the tool more robust
Date: Thu, 30 Mar 2017 07:45:35 -0300
Message-Id: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, the script just assumes to be called at
Documentation/sphinx/. Change it to work on any directory,
and make it abort if something gets wrong.

Also, be sure that both parameters are specified.

That should avoid troubles like this:

$ Documentation/sphinx/tmplcvt Documentation/DocBook/writing_usb_driver.tmpl
sed: couldn't open file convert_template.sed: No such file or directory

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/sphinx/tmplcvt | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/sphinx/tmplcvt b/Documentation/sphinx/tmplcvt
index 909a73065e0a..31df8eb7feca 100755
--- a/Documentation/sphinx/tmplcvt
+++ b/Documentation/sphinx/tmplcvt
@@ -7,13 +7,22 @@
 # fix \_
 # title line?
 #
+set -eu
+
+if [ "$2" == "" ]; then
+	echo "$0 <docbook file> <rst file>"
+	exit
+fi
+
+DIR=$(dirname $0)
 
 in=$1
 rst=$2
 tmp=$rst.tmp
 
 cp $in $tmp
-sed --in-place -f convert_template.sed $tmp
+sed --in-place -f $DIR/convert_template.sed $tmp
 pandoc -s -S -f docbook -t rst -o $rst $tmp
-sed --in-place -f post_convert.sed $rst
+sed --in-place -f $DIR/post_convert.sed $rst
 rm $tmp
+echo "book writen to $rst"
-- 
2.9.3
