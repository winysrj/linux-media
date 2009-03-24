Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34086 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1763422AbZCXQfd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 12:35:33 -0400
Message-ID: <49C90BCC.1080401@gmx.de>
Date: Tue, 24 Mar 2009 17:35:24 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [question] atsc and api v5
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While trying to update an application to API v5 some question arised.

Which type of "delivery_system" should be set for ATSC?
<frontend.h> says...

SYS_DVBC_ANNEX_AC,   <- european DVB-C
SYS_DVBC_ANNEX_B,      <- american ATSC QAM
..
SYS_ATSC,   <- oops, here we have ATSC again, cable and terrestrial not 
named? Is this VSB *only*?



Which one should i choose, "SYS_ATSC" for both (VSB and QAM),
or should i choose SYS_DVBC_ANNEX_B for ATSC cable and SYS_ATSC for VSB?

thanks,
Winfried



