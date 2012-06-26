Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab2FZHig (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 03:38:36 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q5Q7ca2v025267
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 26 Jun 2012 03:38:36 -0400
Received: from gromit.localnet (dhcp-24-116.brq.redhat.com [10.34.24.116])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q5Q7cYsb025252
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 26 Jun 2012 03:38:36 -0400
From: Jirka Klimes <jklimes@redhat.com>
To: linux-media@vger.kernel.org
Reply-To: Jirka Klimes <jklimes@redhat.com>
Subject: dvb-apps: remove broken and not functional dvbscan
Date: Tue, 26 Jun 2012 09:38:34 +0200
Message-ID: <1969729.Q46QkrbvB0@gromit>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvb-apps' "dvbsca"n from util/dvbscan/ doesn't work. It exits with "Unable to 
query frontend status".
By looking into source code I've found there's a bug in 
util/dvbscan/dvbscan.c:309 that uses DVBFE_INFO_QUERYTYPE_IMMEDIATE return 
value instead of DVBFE_INFO_LOCKSTATUS. However, a further look reveals that 
scanning is not actually implemented and according to commit status (just  a 
few on 2006-11-20) it is evident that the code is abandoned.

I suggest removing the code in favor of util/scan that works OK. The broken 
dvbscan in the tree causes confusion as some users don't know there's another 
scanning tool that actually works. 
Another suggestion is to rename "scan" to "scandvb" otherwise it can collide 
with other tools and some distributions rename it thus anyway.

Cheers,
Jirka

