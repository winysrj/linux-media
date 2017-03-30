Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45689
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932290AbdC3Ips (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 04:45:48 -0400
Date: Thu, 30 Mar 2017 05:45:39 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 04/22] gadget.rst: Enrich its ReST representation and
 add kernel-doc tag
Message-ID: <20170330054539.07efa73f@vento.lan>
In-Reply-To: <874lyb459y.fsf@intel.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
        <61bf3d87b32a57f5d223dc3fd0228c342ba1b4a0.1490813422.git.mchehab@s-opensource.com>
        <874lyb459y.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Mar 2017 10:01:29 +0300
Jani Nikula <jani.nikula@linux.intel.com> escreveu:

> On Wed, 29 Mar 2017, Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> > The pandoc conversion is not perfect. Do handwork in order to:
> >
> > - add a title to this chapter;
> > - use the proper warning and note markups;
> > - use kernel-doc to include Kernel header and c files;  
> 
> Please look at Documentation/sphinx/tmplcvt which takes care of all of
> that.

Ah, didn't know about such script!

Trying it here:

$ Documentation/sphinx/tmplcvt Documentation/DocBook/writing_usb_driver.tmpl 
sed: couldn't open file convert_template.sed: No such file or directory

It would be good to change the script for it to seek for convert_template.sed
at the right place.

So, please consider the following patch.

Regards,
Mauro


[PATCH] tmplcvt: make the tool more robust

Currently, the script just assumes to be called at
Documentation/sphinx/. Change it to work on any directory,
and make it abort if something gets wrong.

Also, be sure that both parameters are specified.

That should avoid troubles like this:

$ Documentation/sphinx/tmplcvt Documentation/DocBook/writing_usb_driver.tmpl
sed: couldn't open file convert_template.sed: No such file or directory

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

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
