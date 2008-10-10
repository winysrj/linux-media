Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <britney.fransen@gmail.com>) id 1KoRDU-0000p3-1y
	for linux-dvb@linuxtv.org; Sat, 11 Oct 2008 01:16:19 +0200
Received: by yw-out-2324.google.com with SMTP id 3so252128ywj.41
	for <linux-dvb@linuxtv.org>; Fri, 10 Oct 2008 16:16:10 -0700 (PDT)
Message-Id: <4D1DA692-ECF0-44E5-AC73-C804E19D6F31@gmail.com>
From: Britney Fransen <britney.fransen@gmail.com>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Fri, 10 Oct 2008 18:16:08 -0500
Subject: [linux-dvb] DVICO FusionHDTV 5 Lite Reception Corruption
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

Hello,

I am seeing some reception corruption on only one QAM channel with my  
DVICO FusionHDTV5 Lite and the latest tip of the v4l-dvb driver.  At  
first I thought that the problem was my cable company however the  
reception of that channel is perfect on all other digital tuners in  
the house.  Then I stumbled across this YouTube video: http://www.youtube.com/watch?v=rH1tsiPB8us 
  showing the same issue I have experienced.

In testing I found when I roll back to rev 6557 of the driver all the  
artifacts go away and the channel reception is perfectly clear.   From  
the current revision (9114) of the driver if I roll back to 6558 I  
still see the artifacts.  6557 always fixes the problem.  Another  
oddity is once I am at 6557 I can upgrade to 6600 I think and not have  
an issue. But again once I get up to a certain revision (haven't taken  
the time to narrow it down exactly which number it is) I get the  
reception problems and downgrading just 1 or 2 revisions won't fix it,  
I have to go back to 6557.

I am considering adding a usb tuner to my setup and that would require  
me to run a later revision of the v4l-dvb driver to support the new  
tuner but I don't want to loose the functionality of my Fusion 5 lite  
card.  If anyone has any suggestions or if I can provide info to help  
troubleshoot and squash this bug let me know.

Thanks,
Britney

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
