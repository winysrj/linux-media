Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rouge.crans.org ([138.231.136.3])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <braice@braice.net>) id 1KkNDz-0004bs-8H
	for linux-dvb@linuxtv.org; Mon, 29 Sep 2008 20:12:01 +0200
Message-ID: <48E11A6A.5020806@braice.net>
Date: Mon, 29 Sep 2008 20:11:54 +0200
From: Brice DUBOST <braice@braice.net>
MIME-Version: 1.0
To: Simon Siemonsma <simon@siemonsma.name>
References: <200809282207.20443.simon@siemonsma.name>
In-Reply-To: <200809282207.20443.simon@siemonsma.name>
Cc: linux-dvb@linuxtv.org
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

Simon Siemonsma wrote:
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

Hello,
I think this is your issue

I have a PowerCam Pro and I succed to send at least 5 channels at the
same time to it (as far as I remember, it supports 16 channels)

Hope this will help

-- 
Brice

http://mumudvb.braice.net


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
