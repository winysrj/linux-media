Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web38802.mail.mud.yahoo.com ([209.191.125.93])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <urishk@yahoo.com>) id 1L2rM7-0005mO-7p
	for linux-dvb@linuxtv.org; Wed, 19 Nov 2008 19:00:48 +0100
Date: Wed, 19 Nov 2008 10:00:12 -0800 (PST)
From: Uri Shkolnik <urishk@yahoo.com>
To: Andrea Venturi <a.venturi@avalpa.com>
In-Reply-To: <49244E4F.3000901@avalpa.com>
MIME-Version: 1.0
Message-ID: <101205.71076.qm@web38802.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH 1/2] Siano's SMS subsystems API - SmsHost
	support
Reply-To: urishk@yahoo.com
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




--- On Wed, 11/19/08, Andrea Venturi <a.venturi@avalpa.com> wrote:

> From: Andrea Venturi <a.venturi@avalpa.com>
> Subject: Re: [linux-dvb] [PATCH 1/2] Siano's SMS subsystems API - SmsHost support
> To: 
> Cc: linux-dvb@linuxtv.org
> Date: Wednesday, November 19, 2008, 7:35 PM
> Uri Shkolnik wrote:
> > Siano DTV module works with three subsystem API
> (DVB-API v3, DVB-API v5 (S2) and SmsHost)
> >
> > Until now, only the DVB-API v3 has been supported.
> > The following two patch's parts add the support
> for the two other APIs.
> >
> > The first adds the SmsHost API support. This API
> supports DTV standards yet to be fully supported by the
> DVB-API (CMMB, T-DMB and more).
> >   
> 
> hi, as i live in italy under one of the few trials of T-DMB
> network,  
> i'm interested in the T-DMB support.
> i happen to own a Cinergy Terratec Piranha based on a SMS
> 100x chipset 
> and under another OS i can lock and see the T-DMB services.
> i'd like to 
> do the same under linux.
> 
> is there some public spec about this SmsHost API to hack a
> simple 
> application to dump the TS from a T-DMB network?
> google doesn't return with much interesting..
> 
> thanx
> 
> andrea venturi
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Hi Andrea,

In order to use T-DMB you need FIB parser to start with. Do you have such parser? Later on you'll need service and components manager and some other stuff as well.

Maybe I can provide you with user-space C library (binary, not source code) that does that and many other T-DMB tasks, if you'll provide me with you system characteristics.


Regards,

Uri


      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
