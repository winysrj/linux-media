Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <oliver.maurhart@gmx.net>) id 1LA74Y-0002AA-15
	for linux-dvb@linuxtv.org; Tue, 09 Dec 2008 19:12:39 +0100
From: Oliver Maurhart <oliver.maurhart@gmx.net>
To: "Devin Heitmueller" <devin.heitmueller@gmail.com>
Date: Tue, 9 Dec 2008 19:11:55 +0100
References: <200812091251.57007.oliver.maurhart@gmx.net>
	<412bdbff0812090739n831d446tf19faab40c85763@mail.gmail.com>
In-Reply-To: <412bdbff0812090739n831d446tf19faab40c85763@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812091911.55699.oliver.maurhart@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help: /dev/dvb missing with Terratec Cinergy XS
	Hybrid
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

On Tuesday 09 December 2008 16:39:54 Devin Heitmueller wrote:
> On Tue, Dec 9, 2008 at 6:51 AM, Oliver Maurhart <oliver.maurhart@gmx.net> 
wrote:
> > Hi *,
> >
> > After months of googling I'm out of  knowledge. I'm the (lucky?) owner of
> > a Terratec Hybrid XS USB Card:
> >
> > # lsusb | grep TerraTec
> > Bus 001 Device 007: ID 0ccd:005e TerraTec Electronic GmbH
...
> I figured ones of these days a user of this device would come along.  :-)
>
> This is an em28xx based device we don't have a profile for yet -
> although all the core components are supported -
> em28xx/zarlink/xc3028.
>
> If you want to get this device supported under Linux, I'll put in in
> my queue of em28xx devices to look at.  I think we are just missing
> the GPIOs and the dvb profile.

Never mind! Markus Rechberger pointed me to the drivers at mcentral.de. I 
checked out the em28xx-new and ... it worked!!!

Geee! I was running around this issue for months.

Still: kdetv scans all the possible channels on my webcam (!), missing the 
fact that my TerraTec Card does now provide a /dev/dvb but as the 2nd V4L-
Device it's on /dev/video1 ... hehehe ... but kaffeine seems quite smarter and 
gets around that, showing DVB-TV! Yeah! =)

What a relief!

THX!

kR,
Oliver

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
