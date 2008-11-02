Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.dbmail.com ([160.92.190.1])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <cricky@dbmail.com>) id 1Kwif2-0006Hw-V9
	for linux-dvb@linuxtv.org; Sun, 02 Nov 2008 20:30:58 +0100
Received: from [192.168.1.212] (152.250-226-89.dsl.completel.net
	[89.226.250.152])
	by mwumf0204.dbmail.com (Postfix) with ESMTP id 1E31320000A3
	for <linux-dvb@linuxtv.org>; Sun,  2 Nov 2008 20:30:22 +0100 (CET)
Message-ID: <490DFFD3.3030806@dbmail.com>
Date: Sun, 02 Nov 2008 20:30:27 +0100
From: CRicky <cricky@dbmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Bad firmware download link for TDA10046
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

Hi,

I have a pinnacle PCTV PCI 310i, and after installing new linux, I 
wanted to download firmware TDA10045 and TDA10046. For the first, no 
issue, zip is donwloaded, and file is correctly extracted, but for 
TDA10046, I get a HTTP 404 error.
It seems that they changed the link to the file. So I have checked and 
found the new one:
http://www.technotrend.de/Dokumente/87/software/219/TT_PCI_2.19h_28_11_2006.zip
(seen from http://www.technotrend.de/2755/Downloads.html)

So, in the get_dvb_firmware script, I have replaced (for TDA10046 
subroutine), the bad following link by the one I indicated above:

my $url = "http://technotrend-online.com/download/software/219/$sourcefile";
=>
my $url = "http://technotrend.de/Dokumente/87/software/219/$sourcefile";


Sorry, I did not get it from CVS, so I did not make any patch.

Best regards,
CRicky.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
