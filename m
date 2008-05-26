Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n34.bullet.mail.ukl.yahoo.com ([87.248.110.167])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1K0hNx-0007m9-0C
	for linux-dvb@linuxtv.org; Mon, 26 May 2008 20:25:31 +0200
Date: Mon, 26 May 2008 13:50:47 -0400
From: manu <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
In-Reply-To: <483AAB06.5030103@kipdola.com> (from skerit@kipdola.com on Mon
	May 26 08:20:23 2008)
Message-Id: <1211824247l.7072l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re :  Re : TechnoTrend S2-3200 CAM / CI
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

On 05/26/2008 08:20:23 AM, Jelle De Loecker wrote:
> manu schreef:
> > On 05/26/2008 05:24:08 AM, Jelle De Loecker wrote:
> >   
> >> All I want to know is: is it as simple as inserting the CAM in my 
> >> Technotrend's CI? Will the hardware do everything, or does
> Multiproto 
> >> and VDR have some work, too?
> >>     
> > I have a Canalsat (in the caribbean) subscription and, with MythTV
> at 
> > least I just had to plug in the cam, put the subscription card in 
> it
> 
> > and voila!
> > The TV application must "talk" to the cam; also there are some cams 
> > which are known not to work well/reliably with the TT CI.
> > For my part I am more than happy with my aston crypt CAM which can 
> > decrypt two streams simultanueously, which means you can watch 2 
> > channels (on different PC or using PIP) or record two, or watch one 
> > record one, just one restriction though: they have to be on the 
> same
> >  transponder.
> I believe TV Vlaanderen uses SECA - Any problems with that one?
> 
> Oh, talking about multiple streams, what exactly describes a 
> transponder? For example, when I use dvbstream to tunnel a DVB signal 
> into VLC I can select a few other channels (6-7, on some BBC streams 
> even 7-8 or more) from the "navigation" menu, is this the content of 
> a
> 
> transponder? (Because that would mean there are on average about 6-7 
> channels on one transponder)
> Or is it actually more?

Well I am no expert but the channels are dispatched on several 
transponders, how many depend on the bandwidth needed by each channel 
(I mean you can put more SD channels than HD channels). A dvb card 
receives the whole stream of one transponder and can, depending on 
hardware including the CAM if there is encryption, decode all channels.
This is when you have only one tuner; indeed one tuner can tune on only 
one frequency, that is only one transponder. So if you want to be able 
to watch/record several channels without restriction, you need several 
cards. 

> Btw, what MythTV revision were you using again? (I badly want to get 
> MythTV to work!)

I have been using the 0.21-fixes branch since a while. I know that it 
is not easy to compile it with the latest multiproto, hence mine is 2 
months old I think. One more trick: I hacked the code to add 4MHz to 
the tuning frequency to be able to get good locks (this is not because 
of mythtv, scan/szap need that also). 

HTH
Bye
Manu 






_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
