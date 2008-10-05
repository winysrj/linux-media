Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <w3ird_n3rd@gmx.net>) id 1KmV41-00049Q-6a
	for linux-dvb@linuxtv.org; Sun, 05 Oct 2008 16:58:31 +0200
Message-ID: <48E8D5F3.3030507@gmx.net>
Date: Sun, 05 Oct 2008 16:57:55 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
References: <200809282207.20443.simon@siemonsma.name>
In-Reply-To: <200809282207.20443.simon@siemonsma.name>
Subject: Re: [linux-dvb] Can't record an encrypted channel and watch another
 in	the same bouquet. (also teletext doesn't work for encrypted	channels)
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

On 09/28/2008 10:07 PM, Simon Siemonsma wrote:
> I have a problem with encrypted channels.
> I have a Conax CAM Module (by Smit)
> Further I use a Technotrend T1500 Budget card with CI cart.
> 
> With FTA channels everything works just fine.
> With encoded channels some things don't work.
> 
> I can't record one channel and at the same time look at another channel from 
> the same bouquet. (Kaffeine says: "no CAM free", vdr says: "Channel not 
> available"
> Teletext doesn't work (vdr says: "Page 100-00 not found")
> When I start vdr I get the following in the log file:
> "CAM 1: module present
> CAM 1: module ready
> Conax Conditional Access, 01, CAFE, BABE
> CAM 1: doesn't reply to QUERY - only a single channel can be decrypted"
> 
> This looks like the CAM can't just encode one channel at a time.
> 
> But on the dvbshop Website they say:
> http://www.dvbshop.net/product_info.php/info/p2194_Conax-CAM--Rev--1-2----4-00e-by-Smit.html
> "MPEG DEMUX: Multi-channel SECTION and PID filter configurable through 
> software"
> in vdr's CAM menu is stated: "Number of sessions: 5"
> 
> This looks like the CAM can handle multiple channels at a time isn't it?
> 
> Someone at 
> http://www.dvbnetwork.de/index.php?option=com_fireboard&Itemid=27&func=view&catid=2&id=6191#6192 
> (German) pointed me in the direction of the linux drivers.
> 
> Is he right?
> 
> I understood from 
> http://www.linuxtv.org/docs/dvbapi/Introduction.html#SECTION00230000000000000000 
> that the CAM comes before the Demuxer and: "The complete TS is passed through 
> the CA hardware".
> If I understood this right this means that onces I watch one channel in a 
> bouquet the complets TS is decrypted. So all other channels and teletext are 
> decrypted too. This makes it extra confusing why I can't record one channel 
> and watch another in the same bouquet.
> Do I understand it wrong or are the drivers or the dvb software not mature 
> enough yet.
> I use kernel 2.6.25.
> 
> Simon Siemonsma
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

You likely live in The Netherlands. Teletext on Digitenne is encrypted, 
and you are not the only one with problems. The teletext simply 
shouldn't be encrypted, but we can't control KPN. In some cases this can 
be solved by changing settings in the CAM menu.

When saying the whole transport stream goes to the CAM, this means 
everything connected to the requested service ID gets decrypted (if the 
CAM is capable). So not just audio and video, but also extra audio 
tracks, teletext etc.

To descramble multiple channels you usually need a more expensive CAM. 
For example 
http://www.made-in-china.com/china-products/productviewJqSxvLmUREWp/Professional-Irdeto-CI-Module.html 
shows a "professional Irdeto CAM" that will descramble 4 TV channels at 
the same time. Not usefull for you because you need Conax, but I don't 
know which Conax module could descamble multiple channels.

This is no linux-DVB problem.

P. van Gaans

-- note: this is an old message, but I just found out I *AGAIN* forgot 
to send it to the list. Linux-dvb missing in the reply-to field is very, 
very, very annoying. --

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
