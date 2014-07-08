Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:38916 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753293AbaGHT5q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jul 2014 15:57:46 -0400
Message-ID: <1404849460.932.35.camel@joe-AO725>
Subject: [PATCH] checkpatch: Warn on break after goto or return with same
 tab indentation
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Fabian Frederick <fabf@skynet.be>
Cc: Antti Palosaari <crope@iki.fi>, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Date: Tue, 08 Jul 2014 12:57:40 -0700
In-Reply-To: <20140709041215.3e1083201f5a400c37b820b0@skynet.be>
References: <1404840181-29822-1-git-send-email-fabf@skynet.be>
	 <53BC3A0E.4060505@iki.fi>
	 <20140709041215.3e1083201f5a400c37b820b0@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using break; after a goto or return is unnecessary so
emit a warning when the break is at the same indent level.

So this emits a warning on:

	switch (foo) {
	case 1:
		goto err;
		break;
	}

but not on:

	switch (foo) {
	case 1:
		if (bar())
			goto err;
		break;
	}

Signed-off-by: Joe Perches <joe@perches.com>
---
> AFAIK there's still no automatic detection of those cases.

There can be now...

 scripts/checkpatch.pl | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 496f9ab..fc22f22 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2439,6 +2439,16 @@ sub process {
 			}
 		}
 
+# check indentation of a line with a break;
+# if the previous line is a goto or return and is indented the same # of tabs
+		if ($sline =~ /^\+([\t]+)break\s*;\s*$/) {
+			my $tabs = $1;
+			if ($prevline =~ /^\+$tabs(?:goto|return)\b/) {
+				WARN("UNNECESSARY_BREAK",
+				     "break is not useful after a goto or return\n" . $hereprev);
+			}
+		}
+
 # discourage the addition of CONFIG_EXPERIMENTAL in #if(def).
 		if ($line =~ /^\+\s*\#\s*if.*\bCONFIG_EXPERIMENTAL\b/) {
 			WARN("CONFIG_EXPERIMENTAL",


