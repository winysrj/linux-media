Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt2.poste.it ([62.241.5.253])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1Jt2Df-0001UZ-5n
	for linux-dvb@linuxtv.org; Mon, 05 May 2008 17:03:12 +0200
Received: from nico2.od.loc (89.97.249.170) by relay-pt2.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 481E40370000AE8B for linux-dvb@linuxtv.org;
	Mon, 5 May 2008 17:03:06 +0200
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Mon, 5 May 2008 17:03:12 +0200
References: <481F1F7E.1030406@gmail.com>
In-Reply-To: <481F1F7E.1030406@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805051703.12390.Nicola.Sabbi@poste.it>
Subject: Re: [linux-dvb] LNB: L.O is 11300
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

On Monday 05 May 2008 16:53:50 vivian stewart wrote:
>   I think I may know what is wrong ... my LNB is weird well ... not
> for this part of the world so I think I need to make a custom
> sec.conf or something? any Ideas? I can watch tv with
> 'dvbstream...|mplayer' and 'mplayer dvb://' works with an edited
> channels.conf and 'scan -l 11300,11300,1 OptusD1' works on all
> listed transponders (file) from lyngsat. but no programs seem to
> tune to a list of actual transponders, including mythtv (finds
> channels and epg data but can't tune in channels). am I doomed to
> watch tv with mplayer and no remote control?
>
> L.O is 11300
> card is HVR3000


you must have changed the sources of mplayer, as the LOFs are fixed
at

#define SLOF (11700*1000UL)
#define LOF1 (9750*1000UL)
#define LOF2 (10600*1000UL)

while with dvbstream you can specify them on the command line

BTW, mplayer can accept commands from the remote control,
although it's not the best sw to watch tv

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
