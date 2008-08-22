Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.koalatelecom.com.au ([202.126.101.92])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <peter_s_d@fastmail.com.au>) id 1KWQa4-0006cz-Kk
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 08:57:09 +0200
From: "Peter D." <peter_s_d@fastmail.com.au>
To: linux-dvb@linuxtv.org
Date: Fri, 22 Aug 2008 16:56:53 +1000
References: <200808121443.27020.mldvb@mortal-soul.de>
In-Reply-To: <200808121443.27020.mldvb@mortal-soul.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808221656.53605.peter_s_d@fastmail.com.au>
Subject: Re: [linux-dvb] Possible SMP problems with budget_av/saa7134
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

On Tuesday 12 August 2008, Matthias Dahl wrote:
> Hello all.
>
> I am resending the following message because I didn't get any response so
> far and in addition I am putting it on cc' to the vdr devel list. I'd
> look into this issue myself, yet I don't have the necessary time to dive
> into the DVB tree. So please, if anyone knows how to debug this or has
> any hint where the problem could be located... I'd be more than grateful
> to hear about it.
>
> By the way, just today after a few minutes of uptime with vdr 1.7.0, I
> got those (increased the CAM check interval to 5 seconds btw):
>
> vdr: [3280] ERROR: can't write to CI adapter on device 0: Input/output
> error vdr: [3280] ERROR: can't write to CI adapter on device 0: Invalid
> argument
>
> And the CAM stopped working until I restarted vdr. In one forum post
> someone reported about similar problems with MythTV, so it's becoming
> more and more likely that this is indeed a problem within the dvb tree.
> And if it's a SMP problem, it should get fixed because multicore systems
> will be everywhere pretty soon.
>
> Thanks again.

I thought that I had physically damaged a motherboard and caused it 
to be unreliable.  Your post opens up another possibility.  

I use Kaffeine, a PCI dvb-t card and an X2 processor.  

It might run fine for a week and then lock up three times in an 
hour.  It was so annoying that I stopped using that machine as 
my main machine.  I have not noticed anything odd in the logs.  

That machine now has a vanilla 2.6.26.3 kernel and the 
"nosmp" flag.  It has been up for two hours now.  If you 
don't solve this in the next month, I'll post a follow-up.  ;-)  


> -------------------------------------------------------------------------
>---------
>
> Hello all.
>
> After minutes or hours or days of running vdr 1.4.7, I get the following
> messages in my syslog:
>
>    dvb_ca adapter 0: CAM tried to send a buffer larger than the ecount
> size! dvb_ca adapter 0: DVB CAM link initialisation failed :(
>
> When running vdr 1.6.x, the problems are even more frequent/worse and I
> get those:
>
>   dvb_ca adapter 0: CAM tried to send a buffer larger than the link
> buffer size (192 > 128)!
>   vdr: [3140] ERROR: can't write to CI adapter on device 0: Input/output
> error dvb_ca adapter 0: CAM tried to send a buffer larger than the ecount
> size! dvb_ca adapter 0: DVB CAM link initialisation failed :(
>
> The result is always the same, the CAM stops decrypting and I have to
> restart vdr. After a lot of searching around, I've learnt that I am not
> the only one with those problems and they seem to be related to multi
> core systems. I read that pining vdr down to one CPU core might help...
> and indeed it did.
>
> This cannot be a hardware related issue because...
>
>  1) meanwhile I switched from a NForce 590 SLI to a X48 chipset and thus
> also from an AMD64 X2 5600+ (Winchester) to an Intel Core2Duo E8400
> (Wolfdale)
>
>  2) I swapped my KNC One DVB-C Plus for a new one
>
> And the problems persist.
>
> I've already written a report to the vdr list which was unfortunately
> ignored and besides it looks more like a dvb issue itself.
>
> I was unable to test the kernel with nosmp or similar (which was reported
> by others to work just fine) because I need this machine to work on.
>
> I've attached detailed informations about my system and I'd be more than
> happy to help fix this once and for all, so one can savely rely on vdr
> again.
>
> Last but not least, I am using a AlphaCrypt Light module with 3.15
> firmware.
>
> Thanks a lot in advance for every help.
>
> Best regards,
> Matthias Dahl



-- 
sig goes here...
Peter D.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
