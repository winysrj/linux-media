Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-blr1.sasken.com ([203.200.200.72]:42935 "EHLO
	mta-blr1.sasken.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932543Ab3GWQwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 12:52:36 -0400
From: Krishna Kishore <krishna.kishore@sasken.com>
To: Chris Lee <updatelee@gmail.com>,
	Manu Abraham <abraham.manu@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Prof DVB-S2 USB device
Date: Tue, 23 Jul 2013 16:52:30 +0000
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Message-ID: <bd6fa917-9510-49e2-b4ff-b280fedb320a@exgedgfz01.sasken.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

#Sorry for sending to individual email ids

Hi,

     I am trying to use Prof DVB-S2 USB device with Linux host. Device gets detected. But, I am facing the following problems.

1.      It takes approximately 21 minutes to get /dev/dvb/adapter0/frontend0 and /dev/dvb/adapter0/demux0 to get created. This happens every time
2.      After /dev/dvb/adapter0/frontend0 gets created, when I use w_scan utility to scan for channels, it does not list the channels.
a.      In dmesg logs, I see DEMOD LOCK FAIL error continuously.

      Can you please help me?


Regards,
Kishore.



________________________________

SASKEN BUSINESS DISCLAIMER: This message may contain confidential, proprietary or legally privileged information. In case you are not the original intended Recipient of the message, you must not, directly or indirectly, use, disclose, distribute, print, or copy any part of this message and you are requested to delete it and inform the sender. Any views expressed in this message are those of the individual sender unless otherwise stated. Nothing contained in this message shall be construed as an offer or acceptance of any offer by Sasken Communication Technologies Limited ("Sasken") unless sent with that express intent and with due authority of Sasken. Sasken has taken enough precautions to prevent the spread of viruses. However the company accepts no liability for any damage caused by any virus transmitted by this email.
Read Disclaimer at http://www.sasken.com/extras/mail_disclaimer.html
