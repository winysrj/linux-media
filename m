Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web38803.mail.mud.yahoo.com ([209.191.125.94])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <krabaey@yahoo.com>) id 1KpnWX-0003fv-IU
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 19:17:37 +0200
Date: Tue, 14 Oct 2008 10:16:55 -0700 (PDT)
From: Koen Rabaey <krabaey@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <360596.65146.qm@web38803.mail.mud.yahoo.com>
Subject: Re: [linux-dvb] cx88_wakeup message with HVR4000
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





----- Original Message ----
> From: Steven Toth <stoth@linuxtv.org>
> To: Koen Rabaey <krabaey@yahoo.com>
> Cc: linux-dvb@linuxtv.org
> Sent: Tuesday, October 14, 2008 12:38:26 AM
> Subject: Re: [linux-dvb] cx88_wakeup message with HVR4000
> 
> Koen Rabaey wrote:
> > Hi,
> > 
> > I don't know if it is of any use to anyone, but when I do a dmesg after 
> booting, 
> > at the end I get (from time to time, not consistently, the number of buffers 
> also varies)
> > 
> > [  123.601789] cx88_wakeup: 7 buffers handled (should be 1)
> > [  123.751892] cx88_wakeup: 7 buffers handled (should be 1)
> > 
> > This does not seem to interfere with dvb playback however.
> > 
> > I'm owning an HVR4000, compiled with http://linuxtv.org/hg/~stoth/s2/ 
> > on a '2.6.27-4-generic' kernel.
> 
> FYI
> 
> http://linuxtv.org/hg/~stoth/s2-mfe/rev/6b6e9be35963
> 
> I've changed the message into a debug only message. It's still visible
> when running the driver in debug mode, but for normal users they should 
> not be bothered by this any more.
> 
> It will hopefully be merged this week. Thanks for raising this issue.
You're welcome
> 
> - Steve

Koen



      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
