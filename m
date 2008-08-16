Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nschwmtas05p.mx.bigpond.com ([61.9.189.149])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jhhummel@bigpond.com>) id 1KUJJP-0000j9-Vr
	for linux-dvb@linuxtv.org; Sat, 16 Aug 2008 12:47:13 +0200
From: Jonathan Hummel <jhhummel@bigpond.com>
To: Robert Golding <robert.golding@gmail.com>
In-Reply-To: <ae5231870808152114j273efbd4g2ce0b25ffce251e6@mail.gmail.com>
References: <20080816013510.AF253104F0@ws1-3.us4.outblaze.com>
	<ae5231870808152114j273efbd4g2ce0b25ffce251e6@mail.gmail.com>
Date: Sat, 16 Aug 2008 20:46:30 +1000
Message-Id: <1218883590.16051.6.camel@mistress>
Mime-Version: 1.0
Cc: LinuxTV DVB list <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR	3200
	H - DVB Only support
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

On Sat, 2008-08-16 at 13:44 +0930, Robert Golding wrote:
> Whoops, sent to wrong place this sent to mail list, sorry
> 
> I have finally got the modules to load the PxDVR 3200 H I bought,
> however, now I am getting "Failed to lock channel" error messages from
> MeTV.
> The 'channels.conf' file is correct as I used for my Dvico DVB-T.
> 
>  I have replaced the Dvico with the Leadtek because I wanted to be
> able to get local radio and also use the PCI-e channel since I have
> many of them and only one PCI slot.
> 
> The card is auto-recognised and loads all dvb modules, including fw
> and frontends.
> 
> One other thing, I attached an MS drive and tried it in windows [that
> is another wholly different story :-) ] and it worked very well.  I
> had occation to compare the channels info to each other and the Linux
> version is OK.
> 
> Any information, no matter how small, to show how I might fix this
> would be greatly apprecited
> 

Rob

I've been using Me-TV for a while now on a DTV2000H Card, and recently
set up the 3200H card as well, with a lot (and I mean a lot) of help
from Stephen. In my experience, you only really get this message when
the card is getting no reception. Other similar errors which relate to
accessing the card itself happen when another TV programme, such as Myth
is already loaded and locked onto the card.

I'm not sure radio works on these cards without a lot of effort and
stuffing around each and every time you want to use it. I've never
gotten the 2000H to work on radio, so didn't even bother with the 3200H
though.

As Stephen said, this card is a bit sensitive to firmware and drivers,
as the patch to allow this card is relatively new (days old).

cheers

Jon


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
