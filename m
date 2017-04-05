Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40006
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755267AbdDENX2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 09:23:28 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH v2 01/21] tmplcvt: make the tool more robust
Date: Wed,  5 Apr 2017 10:22:55 -0300
Message-Id: <0dff47eebce7ab16a5a292c682a7b143b97a93a9.1491398120.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1491398120.git.mchehab@s-opensource.com>
References: <cover.1491398120.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1491398120.git.mchehab@s-opensource.com>
References: <cover.1491398120.git.mchehab@s-opensource.com>
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
index 909a73065e0a..6848f0a26fa5 100755
--- a/Documentation/sphinx/tmplcvt
+++ b/Documentation/sphinx/tmplcvt
@@ -7,13 +7,22 @@
 # fix \_
 # title line?
 #
+set -eu
+
+if [ "$#" != "2" ]; then
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
