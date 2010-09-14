Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <suchitagupta@yahoo.com>) id 1Ovc5C-0000O4-3z
	for linux-dvb@linuxtv.org; Tue, 14 Sep 2010 22:26:26 +0200
Received: from web55408.mail.re4.yahoo.com ([206.190.58.202])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with smtp
	for <linux-dvb@linuxtv.org>
	id 1Ovc5B-0003ac-88; Tue, 14 Sep 2010 22:26:25 +0200
Message-ID: <618132.61670.qm@web55408.mail.re4.yahoo.com>
Date: Tue, 14 Sep 2010 13:26:22 -0700 (PDT)
From: Suchita Gupta <suchitagupta@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] DSM-CC question
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

Hi,

First of all, I am new to this list, so I am not sire if this is right place for 
this question.
If not, please forgive me and point me to right list.

I am writing a DSMCC decoding implementation to persist it to local filesystem.
I am unable to understand few thiings related to "srg"

I know, it represents the top level directory. But how do I get the name of this 
directory?
I can extract the names of subdirs and files using name components but where is 
the name of top level directory?

Also, as far as I understand it, I can't start writing to the local filesystem 
until I have acquired the whole carousel.

Can, anyone please provide me some guidance.

Thanks in Advance,
rs


      

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
