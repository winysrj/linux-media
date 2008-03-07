Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n7a.bullet.ukl.yahoo.com ([217.146.183.155])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1JXkuO-0002ZU-55
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 23:19:20 +0100
Date: Fri, 07 Mar 2008 18:18:38 -0400
From: manu <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
References: <227C7E65-BCB7-4990-B0F2-02FFF56DC976@krastelcom.ru>
	<1204845652l.7051l.0l@manu-laptop> <47D08B08.9010703@gmail.com>
In-Reply-To: <47D08B08.9010703@gmail.com> (from abraham.manu@gmail.com on
	Thu Mar  6 20:23:36 2008)
Message-Id: <1204928318l.5666l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : Re : TT S2-3200. No lock on high symbol rate (45M)
 transponders
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

On 03/06/2008 08:23:36 PM, Manu Abraham wrote:
> manu wrote:
> > On 03/06/2008 06:34:28 AM, Vladimir Prudnikov wrote:
> >> Can't get TT S2-3200 locked on high SR transponders. I have seen a 
> >> lot
> >>  
> >> of suggestions regarding changing Frequency/Symbol rate on various 
> 
> >> forums but no luck. Low SR are fine.
> >> Does anyone have a "revision" of multiproto that was tested with
> high 
> >>
> >> SR?
> >>
> >> I hope Manu can comment on that as well...
> >>
> > Just a "me too", well kind of: for me certain transponders do not
> lock 
> > or lock but with corrupted streams whereas others are perfect (on
> the 
> > same sat with the same characteristics, SR is 30M).
> 
> 
> Please try whether these register setup changes does help as
> applicable.
> 
> http://jusst.de/hg/mantis/rev/72e81184fb9f
> 
> Regards,
> Manu
> 

Is there equivalent fixes/imrpovments for TT 3200?
Thx,
Bye
Manu



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
