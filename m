Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sklave3.rackland.de ([88.198.248.38])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hadmut@danisch.de>) id 1Jrqd9-0006wj-9K
	for linux-dvb@linuxtv.org; Fri, 02 May 2008 10:28:35 +0200
Date: Fri, 2 May 2008 10:28:31 +0200
From: Hadmut Danisch <hadmut@danisch.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080502082831.GA26826@danisch.de>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] SAA7146 : DVB-C scan does not find all channels
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

maybe someone can give me a hint what's going wrong here:

I live in Germany, Karlsruhe, cable provider is Kabel-BW. 

My dvb-c settop box finds >> 300 dvb-c tv channels, more than 
100 of them unencrypted, as expected. 

But then, I have a dvb-c card in my ubuntu machine (kernel 2.6.24)
with a
 
 Philips Semiconductors SAA7146 (rev 01)

and the usual tv programs or tools like scan and w_scan never find 
more than around 40 channels. 


Any hint where to start solving the problem? 

regards
Hadmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
