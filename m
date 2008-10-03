Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out2.tiscali.nl ([195.241.79.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <simon@siemonsma.name>) id 1KljJK-00063V-5a
	for linux-dvb@linuxtv.org; Fri, 03 Oct 2008 13:59:08 +0200
Received: from [212.123.191.230] (helo=amd64.siemonsma.name)
	by smtp-out2.tiscali.nl with esmtp id 1KljJG-0001xA-54
	for <linux-dvb@linuxtv.org>; Fri, 03 Oct 2008 13:59:02 +0200
From: Simon Siemonsma <simon@siemonsma.name>
To: linux-dvb@linuxtv.org
Date: Fri, 3 Oct 2008 13:59:02 +0200
References: <200809282207.20443.simon@siemonsma.name>
In-Reply-To: <200809282207.20443.simon@siemonsma.name>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810031359.02734.simon@siemonsma.name>
Subject: Re: [linux-dvb] Can't record an encrypted channel and watch another
	in the same bouquet. (also teletext doesn't work for
	encrypted channels)
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

On Sunday 28 September 2008 22:07:20 Simon Siemonsma wrote:
> I have a problem with encrypted channels.
> I have a Conax CAM Module (by Smit)
> Further I use a Technotrend T1500 Budget card with CI cart.
>
> With FTA channels everything works just fine.
> With encoded channels some things don't work.
>
> I can't record one channel and at the same time look at another channel
> from the same bouquet. (Kaffeine says: "no CAM free", vdr says: "Channel
> not available"
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
> http://www.dvbshop.net/product_info.php/info/p2194_Conax-CAM--Rev--1-2----4
>-00e-by-Smit.html "MPEG DEMUX: Multi-channel SECTION and PID filter
> configurable through software"
> in vdr's CAM menu is stated: "Number of sessions: 5"
>
> This looks like the CAM can handle multiple channels at a time isn't it?
>
> Someone at
> http://www.dvbnetwork.de/index.php?option=com_fireboard&Itemid=27&func=view
>&catid=2&id=6191#6192 (German) pointed me in the direction of the linux
> drivers.
>
> Is he right?
>
> I understood from
> http://www.linuxtv.org/docs/dvbapi/Introduction.html#SECTION002300000000000
>00000 that the CAM comes before the Demuxer and: "The complete TS is passed
> through the CA hardware".
> If I understood this right this means that onces I watch one channel in a
> bouquet the complets TS is decrypted. So all other channels and teletext
> are decrypted too. This makes it extra confusing why I can't record one
> channel and watch another in the same bouquet.
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

Everyone thanks for their answers.
I understood:
-my cam can just decode one channel at a time. Only some expensive cams can do 
multiple channels.
-teletext is encrypted in the Netherlands while it normaly shouldn't.

I decided to give vdr-sc (softcam) a try combined with a cardreader.
This seems to be the only reasonable solution to me.

It should at least make it possible to use multipe encrypted channels.

Thanks,

Simon Siemonsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
