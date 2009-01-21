Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web111407.mail.gq1.yahoo.com ([67.195.15.168])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <cncook001@yahoo.com>) id 1LPf00-0000ij-LY
	for linux-dvb@linuxtv.org; Wed, 21 Jan 2009 16:28:13 +0100
Date: Wed, 21 Jan 2009 07:27:36 -0800 (PST)
From: Craig Cook <cncook001@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <681581.38816.qm@web111407.mail.gq1.yahoo.com>
Subject: Re: [linux-dvb] DVICO Dual Digital 4 DVB-T Revision2 : Strange
	Remote Control Issue
Reply-To: linux-media@vger.kernel.org, cncook001@yahoo.com
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

>Is there a way to test this and/or reset  the card to its original state?

I had an earlier model Dvico Dual Tuner with similar problems when I first tried to make it work (linux drivers were not part of the kernel at that stage).  It would work in windows, but had problems in linux.  To resolve the firmware issue I removed the power cord from my pc and left it overnight.  Leaving the power cord attached was not good enough.  That seemed to clear any firmware on the card.  Next time I used it linux told me it detected the card "cold" and loaded firmware.  I think windows did the same thing.  If it didn't, I removed and reinstalled the windows drivers.

Simply rebooting the pc did not work either.

Craig


      

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
