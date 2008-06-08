Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1K5AS3-0004x8-NS
	for linux-dvb@linuxtv.org; Sun, 08 Jun 2008 04:16:13 +0200
Message-ID: <484B40E5.2070109@iinet.net.au>
Date: Sun, 08 Jun 2008 10:16:05 +0800
From: timf <timf@iinet.net.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] New scan file
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi all,

Could someone please tell me where do I send this new scan file which 
presently I have to manually copy into:
/usr/share/doc/dvb-utils/examples/scan/dvb-t

I think it can also be called dvb-apps

Here is mine for a dvb-t translator in Perth, Australia.
I have called it au-Perth_roleystone:

# Australia / Perth (Roleystone transmitter)
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
# SBS
T 704500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
# ABC
T 725500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# Seven
T 746500000 7MHz 2/3 NONE QAM64 8k 1/16 NONE
# Nine
T 767500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# Ten
T 788500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE


Regards,
Timf

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
