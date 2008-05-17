Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JxCo9-0006ac-Qh
	for linux-dvb@linuxtv.org; Sat, 17 May 2008 05:10:07 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Tim Hewett <tghewett2@onetel.com>
In-Reply-To: <EB92D838-BD10-459D-89FA-AB538B791D45@onetel.com>
References: <EB92D838-BD10-459D-89FA-AB538B791D45@onetel.com>
Date: Sat, 17 May 2008 05:09:00 +0200
Message-Id: <1210993740.2517.11.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] BBC HD on Freesat?
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

Hi,

Am Samstag, den 17.05.2008, 00:40 +0100 schrieb Tim Hewett:
> Try this using VLC:
> 
> vlc dvb:// :dvb-adapter=<YOUR_CARD_NO> :dvb-frequency=10847000 :dvb- 
> srate=22000000 :programs=6940
> 
> You might have to select the program manually but this should setup  
> the tuner ok for you. It is on a DVB-S transponder, not DVB-S2, so any  
> budget hardware should be fine.
> 
> I overclock my 2GHz AMD64 X2 to 2.4GHz to watch it smoothly, also try  
> selecting "Bob" as the de-interlacing option to avoid the jagged edges  
> when the camera pans.
> 
> I've not managed to get VLC to play ITV HD yet as it is a non-standard  
> broadcast, but it is displayed using DVBViewer under Windows if you  
> adjust some of the settings for the channel (force it to H.264, mainly).
> 
> The only "special" thing about Freesat is the EPG and interactive  
> services. All the channels (except ITV HD) can be viewed using any FTA  
> receiver. Some have found ways to get some FTA HD receivers to display  
> ITV HD, see some of the threads at Digital Spy.
> 
> HTH,
> 
> Tim.

hmm, what is interesting on BBC HD currently, that you can't get
anywhere else as well? EPG sucks on all DVB-S stuff.

But which content is new there?

I assume nothing for now. I doubt anything is worth to move the dish for
it.

Cheers,
Hermann

> 
> > Hi all, I'm interested in watching BBC HD broadcasts from the new  
> > freesat service. However there seems to be conflicting reports about  
> > what hardware this is possible with.  In particular there is comment  
> > here from the freesat people that seems to imply that they will use  
> > some sort access restrictions: http://uk.news.yahoo.com/techdigest/20080423/ttc-opinion-freesat-confusion-and-secrec-e870a33.html 
> >  "would like to clarify that the Hauppauge free-to-air USB2  
> > satellite tuner is not a freesat licensed product and as such will  
> > not receive freesat services. freesat licensed products can be  
> > identified by the freesat logo and are subject to a stringent test  
> > and conformance regime." So... 1) does anyone know if the freesat  
> > broadcasts are encrypted or real free to air? 2) Is anyone  
> > successfully watching freesat including the BBC HD broadcasts under  
> > linux? 3) And if so what hardware are you using? (I'm particularly  
> > interested in USB attached hardware as I have no room in my media  
> > centre case for a tuner card :D, but maybe I will have to buy a new  
> > case!) Cheers, Steve.
> 



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
