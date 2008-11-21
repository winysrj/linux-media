Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from portal.beam.ltd.uk ([62.49.82.227] helo=beam.beamnet)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <terry1@beam.ltd.uk>) id 1L3T7B-0006Kc-7f
	for linux-dvb@linuxtv.org; Fri, 21 Nov 2008 11:19:54 +0100
Message-ID: <49268B22.5040501@beam.ltd.uk>
Date: Fri, 21 Nov 2008 10:19:14 +0000
From: Terry Barnaby <terry1@beam.ltd.uk>
MIME-Version: 1.0
To: Terry Barnaby <terry1@beam.ltd.uk>
References: <492568A2.4030100@beam.ltd.uk>
In-Reply-To: <492568A2.4030100@beam.ltd.uk>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Twinhan VisionPlus DVB-T Card not working
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

Terry Barnaby wrote:
> Hi,
> 
> I am having a problem with the latest DVB drivers.
> I have a Twinhan VisionPlus DVB-T card (and other DVB cards) in my
> MythTv server running Fedora 8. This is running fine
> with the Fedora stock kernel: 2.6.26.6-49.fc8.
> 
> However, I have now added a Hauppauge DVB-S2 and so have been
> trying the latest DVB Mercurial DVB tree.
> This compiles and installs fine and the two DVB-T cards and the
> new DVB-S card are recognised and has /dev/dvb entries.
> The first DVB-T card, a Twinhan based on the SAA7133/SAA7135
> works fine but the Twinhan VisionPlus, which is Bt878 will not
> tune in.
> 
> Any ideas ?
> Has there been any recent changes to the Bt878 driver that could
> have caused this ?
> ...

I have been playing around with the bt8xx source code.
If I set "dst_algo = 1" in "bt8xx/dst.c" then my Twinhan VisionPlus
DVB-T appears to work.
This parameter appears to enable hardware rather than software tuning.
I assume there is some bug in the software tuning algorithm ...

What are the benefits of software tuning over hardware based tuning ?

Cheers



Terry

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
