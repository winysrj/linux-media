Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from holly.castlecore.com ([89.21.8.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@philpem.me.uk>) id 1JZCYS-0005ug-DD
	for linux-dvb@linuxtv.org; Tue, 11 Mar 2008 23:02:40 +0100
Message-ID: <47D701A7.40805@philpem.me.uk>
Date: Tue, 11 Mar 2008 22:03:19 +0000
From: Philip Pemberton <lists@philpem.me.uk>
MIME-Version: 1.0
To: ivor@ivor.org
References: <20080311110707.GA15085@mythbackend.home.ivor.org>
In-Reply-To: <20080311110707.GA15085@mythbackend.home.ivor.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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

ivor@ivor.org wrote:
> Not sure if this helps or adds that much to the discussion... (I think this was concluded before)
> But I finally switched back to kernel 2.6.22.19 on March 5th (with current v4l-dvb code) and haven't had any problems with the Nova-t 500 since. Running mythtv with EIT scanning enabled.

Is this a distribution kernel, or one built from virgin (i.e. unmodified from 
www.kernel.org or one of the mirrors) source code?

Is there any possibility of you uploading your .config file somewhere? I'm 
curious what kernel options you have set.. especially USB_SUSPEND (USB 
autosuspend -- not sure if this was added to 2.6.24 or if .22 had it as well; 
I don't have a .22 source tree at the moment).

I'm building a kernel from the 2.6.24.2 virgin source on Ubuntu to do some 
testing; I'd like to prove that the problem exists in 2.6.24 proper before 
screaming "kernel bug". But if 2.6.22 works, a bug is looking more and more 
likely.

Thanks,
-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
lists@philpem.me.uk           | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
