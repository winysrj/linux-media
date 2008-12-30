Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.169])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LHk4S-0007Tl-Ls
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 20:16:07 +0100
Received: by ug-out-1314.google.com with SMTP id x30so1058680ugc.16
	for <linux-dvb@linuxtv.org>; Tue, 30 Dec 2008 11:16:01 -0800 (PST)
Date: Tue, 30 Dec 2008 20:15:54 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Dmitry Podyachev <vdp@teletec.com.ua>
In-Reply-To: <495A6A08.90909@teletec.com.ua>
Message-ID: <alpine.DEB.2.00.0812302005410.29535@ybpnyubfg.ybpnyqbznva>
References: <mailman.1.1230548402.10016.linux-dvb@linuxtv.org>
	<495A0E46.6030903@teletec.com.ua>
	<alpine.DEB.2.00.0812301329490.29535@ybpnyubfg.ybpnyqbznva>
	<495A6A08.90909@teletec.com.ua>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvb-t config for Ukraine_Kiev (ua)
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

Posting an update to the list...

On Tue, 30 Dec 2008, Dmitry Podyachev wrote:

> > I think the following parameters can be used in place of
> > `AUTO' for all the above...
> > FEC 2/3
> > Guard Interval 1/32

> hmm, I have problems when use not auto (fec 2/3, GI 1/32):

Actually, I have found another site; apparently at 634MHz,
the FEC used may be 3/4, while 2/3 is used for all others,
and all have GI 1/32...
www.dvbtonline.com


> > Can you verify this by parsing the NIT info on PID 16
> > (PID 0x10) on all frequencies?  This matches the results
> > from 650MHz below...
> >   
> ok, I try, but I see it only at 650MHz...

What you would need to do, is to use something like
`dvbsnoop -s ts -tssubdecode -if [foo] 16'
after using something like `dvbstream' to record from
each frequency, writing to file `-o:[foo]' -- or using
`tzap' to tune each frequency, and `dvbsnoop' on the
tuner output directly.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
