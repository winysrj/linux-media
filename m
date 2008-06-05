Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out2.iol.cz ([194.228.2.87])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1K4KVL-0003OY-8R
	for linux-dvb@linuxtv.org; Thu, 05 Jun 2008 20:48:09 +0200
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Thu, 5 Jun 2008 20:47:29 +0200
References: <1212610778l.7239l.1l@manu-laptop>
In-Reply-To: <1212610778l.7239l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806052047.30008.ajurik@quick.cz>
Subject: Re: [linux-dvb] No lock on a particular transponder with TT S2-3200
Reply-To: ajurik@quick.cz
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

On Wednesday 04 of June 2008, manu wrote:
> 	Hi all,
> one more datapoint for the TT 3200 tuning problems. I solved all my
> locking problems by add 4MHz to the reported frequencies (coming from
> the stream tables); note that one of the transponders always locked
> even without this correction (its freq is 11093MHz, the others are :
> 11555, 11635, 11675MHz), so as you see the others are much higher.
> Now there is another transponder at 11495MHz but this one I cant lock
> on it even with my correction. 

Hi,

I have a little more problems with TT S2-3200 under linux. At DVB-S exists 
transponders to which is not possible to switch directly (when changing 
satellite), it is necessary to tune first to another transponder at same 
position (I'm using diseqc switch). At these transponders changing the 
frequency is not helpful.

At DVB-S2 transponders are some transponders at which is possible to get lock 
without problems. Also at some transponders it is possible to get lock when 
changing frequency by 4-5MHz after some minutes (typically 2 min.). But there 
exists some transponders where is practically impossible to get lock. 
Interesting is that those problematic transponders were without problems 
receivable some time ago. The change appeared when transponders were switched 
from Thor2 to Thor5 (same frequency but only FEC changed from 2/3 to 3/4 and 
pilot was switched off), also one transponder at HB 13.0E which was 
receivable two months ago is not receivable any more (don't know if pilot was 
switched off but other paremeters are the same).

So now I'm able to get lock on less then half of DVB-S2 HD programs which I'm 
able to watch. This is not very funny situation, even if all of these 
programs are without any problem receivable at the same PC but under Windows. 
So I'm nearly sure that problem is in driver.

If I could be helpful with debugging and testing I'll glad to cooperate.

BR,

Ales


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
