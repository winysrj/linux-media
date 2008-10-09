Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out2.iol.cz ([194.228.2.87])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1KnuFz-00089L-Mx
	for linux-dvb@linuxtv.org; Thu, 09 Oct 2008 14:04:40 +0200
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org,
 newspaperman_germany@yahoo.com
Date: Thu, 9 Oct 2008 14:04:05 +0200
References: <17614.72727.qm@web23205.mail.ird.yahoo.com>
In-Reply-To: <17614.72727.qm@web23205.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810091404.05506.ajurik@quick.cz>
Subject: Re: [linux-dvb] [vdr] stb0899 and tt s2-3200
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

On Thursday 09 of October 2008, Newsy Paper wrote:
> Hi Igor, hi Goga777,
>
> it's not working with SR 30000 FEC 3/4 dvb-s2 8PSK, still the same problem.
>
> kind regards
>
> Newsy
>

It seems that patch from 
http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027264.html is not 
applied. The internal PLL must be disabled when setting new frequency as is 
written in stb6100 documentation.

Regards,

Ales

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
