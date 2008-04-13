Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pcl6.ibercom.com ([213.195.69.254])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <adriancapel@openforyou.com>) id 1Jkq0t-0002R1-FZ
	for linux-dvb@linuxtv.org; Sun, 13 Apr 2008 02:24:08 +0200
Message-ID: <20080413022332.yrtb5tk3ic8ckcgw@webmail.openforyou.com>
Date: Sun, 13 Apr 2008 02:23:32 +0200
From: adriancapel@openforyou.com
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Problems with ASUS My Cinema U3000 Mini
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


The device is properly recognized but I can not tune channels.

scandvb shows me the following error: "WARNING: filter timeout pid 0x0011"


# scandvb /usr/share/dvb-apps/scan/dvb-t/es-Collserola > channels.conf
scanning /usr/share/dvb-apps/scan/dvb-t/es-Collserola
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 514000000 0 2 9 3 1 3 0
initial transponder 570000000 0 2 9 3 1 3 0
initial transponder 794000000 0 2 9 3 1 3 0
initial transponder 818000000 0 2 9 3 1 3 0
initial transponder 834000000 0 2 9 3 1 3 0
initial transponder 842000000 0 2 9 3 1 3 0
initial transponder 850000000 0 2 9 3 1 3 0
initial transponder 858000000 0 2 9 3 1 3 0
>>> tune to:  
>>> 514000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:  
>>> 570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000



I am using kernel 2.6.24.4 and the latest version of v4l-dvb.

For installation of v4l-db follow indications:

http://www.linuxtv.org/wiki/index.php/Asus_My-Cinema-U3000_Mini



Possible bug?


Thanks



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
