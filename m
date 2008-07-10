Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n6a.bullet.mail.tp2.yahoo.com ([203.188.202.100])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KGk1s-0006Mb-KB
	for linux-dvb@linuxtv.org; Thu, 10 Jul 2008 02:29:02 +0200
Date: Wed, 09 Jul 2008 20:26:36 -0400
From: manu <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Message-Id: <1215649596l.10185l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Question for M. Abraham and Dominik Kuhlen
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
I have to be direct sorry... But I dowloaded a patch from Dominik to 
support pctv452 or something like that. My interest here is that I have 
a TT 3200 with tuning problems (like others on this list) and the pctv 
card has stb6100 and stb0899 like my TT 3200. So I patched the 
stb6100/0899 files but with no improvment.
But I have seen that the pctv uhas different setting for the 
stb0899_s*_reg than the TT 3200. So my question is what can I try 
there? I am pretty sure that some reg settings are specific to each 
card but others seem to be independent of the way things are wired, so 
I'd like to try it out.
So question is: why the differences and do the tuning problems exist on 
the pctv card? And also do you think that the different reg settings 
can improve tuning?
Thx
Bye
Manu 



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
