Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48280 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752466AbZBRSlh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 13:41:37 -0500
Message-ID: <499C565E.3070108@gmx.de>
Date: Wed, 18 Feb 2009 19:41:34 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: linux/include/dvb/frontend.h : missing capability flags
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some time ago two new members were added in frontend.h  to
enum fe_code_rate:

-  FEC_3_5
-  FEC_9_10

But the matching capability flags for that are still missing, signalling 
applications support for those:

- FE_CAN_FEC_3_5
- FE_CAN_FEC_9_10

It would be possible to use  0x1000000, 0x2000000 for that to get some 
consistent and logically understandable file,
but there would be also the second possibility to remove
    FE_CAN_FEC_1_2
    FE_CAN_FEC_2_3
    FE_CAN_FEC_3_4
    FE_CAN_FEC_4_5
    FE_CAN_FEC_5_6
    FE_CAN_FEC_6_7
    FE_CAN_FEC_7_8
    FE_CAN_FEC_8_9

This would assume, that all related drivers supports all of these (what 
they should do anyway..).
This would also make sense, since all other frontend related properties 
except modulation are also not explicitly stated
(for example there's also no "FE_CAN_BANDWIDTH_6_MHZ or 
FE_CAN_GUARD_INTERVAL_1_8")

Opinions?


Secondly, inside frontend.h  "DTV_API_VERSION" is defined twice, line 
302 and 303:

#define DTV_API_VERSION                35
#define DTV_API_VERSION                35



Regards,
Winfried








