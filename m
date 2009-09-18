Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp102.mail.ukl.yahoo.com ([77.238.184.34])
	by mail.linuxtv.org with smtp (Exim 4.69)
	(envelope-from <sylvain@sipradius.com>) id 1Moeqp-0007RX-0A
	for linux-dvb@linuxtv.org; Fri, 18 Sep 2009 16:54:19 +0200
Message-ID: <4AB39EF2.3020807@sipradius.com>
Date: Fri, 18 Sep 2009 10:53:38 -0400
From: Sylvain LESAGE <sylvain@sipradius.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] choice between MPE and ULE in the code
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

I am working on ULE (ultra-lightweight encapsulation) and MPE 
(multi-protocol encapsulation) decapsulation of transport stream 
packets. I can't find, in the code of linuxDVB, where the choice is done 
between ULE or MPE when parsing the packets ?
Does someone has an idea ?

Thank you.
Sylvain LESAGE

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
