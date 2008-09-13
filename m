Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 202.7.249.79.dynamic.rev.aanet.com.au ([202.7.249.79]
	helo=home.singlespoon.org.au)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <paulc@singlespoon.org.au>) id 1KeOep-0007Op-8y
	for linux-dvb@linuxtv.org; Sat, 13 Sep 2008 08:31:00 +0200
Received: from [192.168.3.112] (unknown [192.168.3.112])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by home.singlespoon.org.au (Postfix) with ESMTP id A88D7644013
	for <linux-dvb@linuxtv.org>; Sat, 13 Sep 2008 16:34:24 +1000 (EST)
Message-ID: <48CB5D7A.3040403@singlespoon.org.au>
Date: Sat, 13 Sep 2008 16:28:10 +1000
From: Paul Chubb <paulc@singlespoon.org.au>
MIME-Version: 1.0
To: linux dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] why opensource will fail
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
     now that I have your attention:-{)=

I believe that this community has a real problem. There appears to be 
little willingness to help and mentor newcomers. This will limit the 
effectiveness of the community because it will hinder expansion of 
people who are both willing and able to work on the code. Eventually 
this issue  will lead to the community dying simply because you have 
people leaving but few joining.

The card I was working on has been around for  a while now. There have 
been three attempts so far to get it working with Linux. Two in this 
community and one against the mcentral.de tree. Both attempts in this 
community have failed not because of a lack of willingness of the people 
involved to do the hard yards but because of the inability of the 
community to mentor and help newcomers.

The third attempt by a Czech programmer succeeded, however it is 
dependent on the mcentral.de tree and the author appears to have made no 
attempt to get the patch into the tree. The original instructions to 
produce a driver set are in Czech. However instructions in english for 
2.6.22 are available - ubuntu gutsy. I will soon be putting up 
instructions for 2.6.24 - hardy. They may even work  for later revisions 
since the big issue was incompatible versioning.

I understand from recent posts to this list that many in the community 
are disturbed by the existence of mcentral.de. Well every person from 
now on who wants to run the Leadtek Winfast DTV1800H will be using that 
tree. Since the card is excellent value for what it is, there should be 
lots of them. Not helping newcomers who are trying to add cards has led 
and will lead to increased fragmentation.

And before you say or think that we are all volunteers here, I am a 
volunteer also. I have spent close to 3 weeks on this code and it is 
very close to working. The biggest difference between working code in 
the mcentral.de tree and the patch I was working on is the firmware that 
is used.

Finally you might consider that if few developers are prepared to work 
on the v4l-dvb tree, then much of the fun will disappear because those 
few will have to do everything.

Cheers Paul

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
