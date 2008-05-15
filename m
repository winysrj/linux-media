Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n5.bullet.ukl.yahoo.com ([217.146.182.182])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1JwknO-0006if-SG
	for linux-dvb@linuxtv.org; Thu, 15 May 2008 23:15:29 +0200
Date: Thu, 15 May 2008 17:01:54 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <1210882270l.5853l.0l@manu-laptop> <482C9A9E.1000204@kipdola.com>
In-Reply-To: <482C9A9E.1000204@kipdola.com> (from skerit@kipdola.com on Thu
	May 15 16:18:38 2008)
Message-Id: <1210885314l.5853l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : Re : Technotrend S2-3200 (Or Technisat Skystar HD)
 on LinuxMCE 0710 (Kubuntu Feisty)
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

On 05/15/2008 04:18:38 PM, Jelle De Loecker wrote:
> manu schreef:
> > On 05/15/2008 09:04:23 AM, Jelle De Loecker wrote:
> >   
> >>>> I have rebooted the computer multiple times.
> >>>> I also unloaded the modules and reloaded them without rebooting.
> >>>> I even added the modules to the blacklist, rebooted, loaded the
> >>>> modules manually - they still won't go.
> >>>>     
> >>>>         
> >
> > So to make it clear: you compiled and installed the drivers from 
> the
> 
> > multiproto tree of Manu Abraham (not me, another Manu ;-)
> > Then how do you test it? I use mythtv but for that you need to 
> patch
> it 
> > (I use mythtv-0.21 branch).
> > Bye
> > Manu
> >   
> Hi Manu,
> 
> I never got to test it! I would never get a /dev/dvb map with the
> needed 
> devices in it.
> Apparently it's a problem with that kernel, because I tried the 
> latest
> 
> Mythbuntu 8.04 and the drivers do work there!
> 
> I wish it could be fixed, though, as I strongly prefer LinuxMCE to 
> Mythbuntu.
> 
> Now that I'm temporarily running Mythbuntu I'm trying to get *any* 
> signal from my LNB (through a disecq switch)
> Fingers crossed!
> 

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

If you have some problem getting locks, try to add 4 MHz to the 
frequencies (I hacked the mythtv sources directly). For my setup this 
gives me perfect tuning anyatime for all transponders (DVB-S only 
though, no DVB-S2 around here).
Bye
Manu



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
