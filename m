Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <o.endriss@gmx.de>) id 1Jvb1g-0007Oo-JF
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 18:37:26 +0200
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-dvb@linuxtv.org
Date: Mon, 12 May 2008 18:02:34 +0200
References: <482560EB.2000306@gmail.com>
	<200805121516.48002@orion.escape-edv.de> <48284A6B.2020602@gmx.net>
In-Reply-To: <48284A6B.2020602@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805121802.34413@orion.escape-edv.de>
Subject: Re: [linux-dvb] [PATCH] Fix the unc for the frontends tda10021	and
	stv0297
Reply-To: linux-dvb@linuxtv.org
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

P. van Gaans wrote:
> On 05/12/2008 03:16 PM, Oliver Endriss wrote:
> > @all:
> > 1. If nobody objects I will commit the patches.
> > 2. Please check and fix the other frontend drivers to follow the spec.
> 
> Will the behaviour of femon change, and if so, in what way?

For a correct driver unc would not return to 0 (unless the counter
wrapped).

> I use it now  
> to see at what points in time I've had hickups by writing femon's output 
> to a file and grep -nv "unc 0". This way I can see for example I've had 
> errors at 16:35 and 17:48. If this will still work after the patch, I'm 
> fine with it. If it won't work, will there be an alternative?

- Monitor the log for changes of the unc value.
- femon could be modified to display the delta value, or we might add an
  option (-U) to choose between absolute and delta unc display.

I am open to suggestions.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
