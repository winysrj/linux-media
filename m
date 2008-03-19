Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <torbjorn.jansson@mbox200.swipnet.se>)
	id 1Jbwve-0003yX-E4
	for linux-dvb@linuxtv.org; Wed, 19 Mar 2008 12:57:59 +0100
Received: from tobbe (90.231.107.108) by pne-smtpout2-sn2.hy.skanova.net
	(7.3.129) id 47A02DB90106B1CD for linux-dvb@linuxtv.org;
	Wed, 19 Mar 2008 12:57:24 +0100
From: =?iso-8859-1?Q?Torbj=F6rn_Jansson?= <torbjorn.jansson@mbox200.swipnet.se>
To: <linux-dvb@linuxtv.org>
References: <47989C17.5030607@osp.fi> <200803172355.16207.pfrank@gmx.de>
In-Reply-To: <200803172355.16207.pfrank@gmx.de>
Date: Wed, 19 Mar 2008 12:57:36 +0100
Message-ID: <BD4F705B69814E1181744B8C07CC4D49@tobbe>
MIME-Version: 1.0
Subject: Re: [linux-dvb] TT-C1501, anyone seen or heard anything?
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

linux-dvb-bounces@linuxtv.org <> wrote:
> Hello Markus
> 
> On Donnerstag, 24. Januar 2008, Markus Ingalsuo wrote:
>> dvbshop.net has the tt-c1501 in their webshop and I couldn't find any
>> usable information anywhere. Technotrend has nothing on their website
>> either so I turn to the community and ask: Have you seen or heard
>> anything? Looks like a chip-tuner-board to me and that got me
>> interested. 
> 
> Any results up to now ?
> 
> regards
>   Petric

I'm also a little intrested in this card and i was going to ask about it.
Doest it work? If so how well? How is the reception quality?
Is it sensitive to powersupplies?
Or can someone recomend a good dvb-c card that works well with linux and
mythtv, doesnt "lockup" (stops producing any data) and is not sensitive to
nearby powersupplies like my current card is.


the card i have now is an old technotrend full featured card pci rev
2.1 (linux mods dvb-ttpci and ves1820) and i've had many problems with
it since i bought it some years ago.

currently i get bad signal on some channels, some channels are worse
than others and it results in blocky recordings and sometimes its so
bad that the mythfrontend freezes several times during playback.
i've had bad power supplies causing bad signal, bad antenna cables
(was a premade cable i bought in a store, the shield in the connector
was barely connected to the shielding in the cable causing the cable
to pickup noise)

another problem i have is that the card stops giving any data from
time to time causing zero length recordings, and this i've had to
"fix" this by killing the backend once a day and reloading the drivers
(done from crontab)

i've had enough of all the problems and i'm looking into getting a new
card that hopefully is more stable, better and hopefully gets rid of
the last bad signal problems.

(i have a dvb-c box that gets perfect signal so it must be a problem
related to the card, and not bad antenna cable(s))


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
