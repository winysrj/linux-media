Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from tichy.grunau.be ([85.131.189.73])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janne-dvb@grunau.be>) id 1LD32s-0001M8-2Z
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 21:31:03 +0100
From: Janne Grunau <janne-dvb@grunau.be>
To: Alan Nisota <alannisota@gmail.com>
Date: Wed, 17 Dec 2008 21:31:11 +0100
References: <200812161740.46186.janne-dvb@grunau.be>
	<4947EC68.6080403@gmail.com>
In-Reply-To: <4947EC68.6080403@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812172131.13072.janne-dvb@grunau.be>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] (Try 2) Convert GP8PSK module to use S2API
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

On Tuesday 16 December 2008 18:59:04 Alan Nisota wrote:
> Janne, Thanks for your' response.  Hopefuly this patch addresses all of
> your concerns.

yes, patch looks fine

> I am not including the API changes at the moment.  I'll try again on
> that after this gets committed (the number of folks working with DCII is
> very small, as far as I'm aware, so the other modulation types can be
> handled later)

I've only limited knowledge of DVB-S so I can't really say much about it. 
Your original change might be better than my suggestions.

> There were a fewquestions which I'll try to answer here as well:
> > Do the values for the FEC in cmd[9] depend on the
> > modulation?
>
> Yes, each modulation can have completely different meanings for cmd[9]

ugly but ok. I just wanted to make sure it's correct.

> > I would prefer a S2API command DTV_TURBO_MODES over duplicating
> > modulations. Especially since the the implemtation in the driver
> > differs only for QPSK and QPSK_TURBO.
>
> The downside to this is that it requires more changes inside of the
> user-space software to do something special with these modulations.
> They really are completely different than non-turbo modes.  But as the
> only interesting case is Turbo-QPSK, and I'm not sure which satellites
> even broadcast it, that may be ok.

It seemed wasteful to add 7 new modulations which might be only supported by 
a single frontend. Especially if we add the FE_CAN_X flags.

I would like someone else to look at the API changes. I'll send a merge 
request for this patch to the v4l-dvb maintainer. Thanks for the patch.

Janne

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
