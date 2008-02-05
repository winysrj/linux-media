Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from smtp107.rog.mail.re2.yahoo.com ([68.142.225.205])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <CityK@rogers.com>) id 1JMCj0-0007jT-8s
	for linux-dvb@linuxtv.org; Tue, 05 Feb 2008 02:35:50 +0100
Message-ID: <47A7BD4D.1060709@rogers.com>
Date: Mon, 04 Feb 2008 20:35:09 -0500
From: CityK <CityK@rogers.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb]  What is the MAC of a DVB card?
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

There is an article in the wiki: 
http://www.linuxtv.org/wiki/index.php/InternetDVB

In addition, there is a brief note (that may help provide an 
explanation) in some of the B2C2 based device articles as to why they 
are listed as network controllers: 
http://www.linuxtv.org/wiki/index.php/TechniSat_Air2PC-ATSC-PCI#Why_are_they_listed_as_a_.22network_controller.22_and_not_a_.22multimedia_controller.22_in_the_output_of_dmesg_or_lspci.3F

in essence - similar to a network controller -- receive and demodulate 
RF signals.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
