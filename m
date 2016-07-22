Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbcGVOqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 10:46:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH] doc-rst: kernel-doc: fix handling of address_space tags
Date: Fri, 22 Jul 2016 11:46:36 -0300
Message-Id: <263bbae9c1bf6ea7c14dad8c29f9b3148b2b5de7.1469198779.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RST cpp:function handler is very pedantic: it doesn't allow any
macros like __user on it:

	Documentation/media/kapi/dtv-core.rst:28: WARNING: Error when parsing function declaration.
	If the function has no return type:
	  Error in declarator or parameters and qualifiers
	  Invalid definition: Expecting "(" in parameters_and_qualifiers. [error at 8]
	    ssize_t dvb_ringbuffer_pkt_read_user (struct dvb_ringbuffer * rbuf, size_t idx, int offset, u8 __user * buf, size_t len)
	    --------^
	If the function has a return type:
	  Error in declarator or parameters and qualifiers
	  If pointer to member declarator:
	    Invalid definition: Expected '::' in pointer to member (function). [error at 37]
	      ssize_t dvb_ringbuffer_pkt_read_user (struct dvb_ringbuffer * rbuf, size_t idx, int offset, u8 __user * buf, size_t len)
	      -------------------------------------^
	  If declarator-id:
	    Invalid definition: Expecting "," or ")" in parameters_and_qualifiers, got "*". [error at 102]
	      ssize_t dvb_ringbuffer_pkt_read_user (struct dvb_ringbuffer * rbuf, size_t idx, int offset, u8 __user * buf, size_t len)
	      ------------------------------------------------------------------------------------------------------^

So, we have to remove it from the function prototype.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 41eade332307..4394746cc1aa 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1848,6 +1848,10 @@ sub output_function_rst(%) {
 	}
 	$count++;
 	$type = $args{'parametertypes'}{$parameter};
+
+	# RST doesn't like address_space tags at function prototypes
+	$type =~ s/__(user|kernel|iomem|percpu|pmem|rcu)\s*//;
+
 	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
 	    # pointer-to-function
 	    print $1 . $parameter . ") (" . $2;
-- 
2.7.4


