Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KE21c-0003eP-7z
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 15:05:33 +0200
Message-ID: <486B7D17.4020807@iki.fi>
Date: Wed, 02 Jul 2008 16:05:27 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Andrew Websdale <websdaleandrew@googlemail.com>
References: <e37d7f810807020442q13107177n5a90b11faf51194d@mail.gmail.com>	<486B6BB2.7060708@iki.fi>
	<e37d7f810807020528h6542dcf9ge439b972efff57e2@mail.gmail.com>
In-Reply-To: <e37d7f810807020528h6542dcf9ge439b972efff57e2@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dposh DVB-T USB2.0(ULi M9207) initialising OK but
 no response from scan
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

Andrew Websdale wrote:
> 2008/7/2 Antti Palosaari <crope@iki.fi <mailto:crope@iki.fi>>:
> 
>     terve Andrew,
>     Andrew Websdale wrote:
> 
>         Hi All,
> 
>         I've been trying to amend the M920x driver to cope with the
>         MT2060 tuner. My dmesg output looks encouraging :
>         usb 5-1: new high speed USB device using ehci_hcd and address 5
>         usb 5-1: configuration #1 chosen from 1 choice
>         Probing for m920x device at interface 0
>         dvb-usb: found a 'Dposh(mt2060 tuner) DVB-T USB2.0' in warm state.
>         dvb-usb: will pass the complete MPEG2 transport stream to the
>         software demuxer.
>         DVB: registering new adapter (Dposh(mt2060 tuner) DVB-T USB2.0)
>         m920x_mt352_frontend_attach
>         DVB: registering frontend 0 (Zarlink MT352 DVB-T)...
>         m920x_mt2060_tuner_attach
>         MT2060: successfully identified (IF1 = 1220)
>         dvb-usb: Dposh(mt2060 tuner) DVB-T USB2.0 successfully
>         initialized and connected.
>          but scanning produces no result. I thought it might be the
>         firmware so I used USBSnoop ( ver 2.0 from here
>         <http://www.pcausa.com/Utilities/UsbSnoop/SniffUSB-x86-2.0.0006.zip>
>          , I think its slightly easier to use than the original) and
>         extracted a new firmware file (attached) . The firmware loaded
>         without complaint, but still no scan result. I'm a bit stuck
>         now, anyone got any suggestions as to how I should proceed?
> 
> 
>     I have following list to check:
>     1) firmware (you tested this one already)
>     2) demodulator (it is MT352 I think, but configuration / settings
>     could be wrong)
>     3) wrong endpoint used for mpeg ts
> 
>     I can help if you take sniffs with usbsnoop, but hopefully you will
>     find error yourself.
>     http://benoit.papillault.free.fr/usbsnoop/
> 
>     regards
>     Antti
>     -- 
>     http://palosaari.fi/
> 
> 
> 
> 
> 
> 1)Sorry, forgot to attach firmware I made from usbsnoop(here it is)

> 2)The front end is MT352 - which configs/settings may need tweaking?

static int m920x_mt352_demod_init(struct dvb_frontend *fe)

Probably you need examine windows sniffs to see correct values.

> 3)Whereabouts is the mpeg ts endpoint defined/set?

struct dvb_usb_device_properties. You can see endpoints using lsusb 
command. And from usbsniffs from Windows you can see also endpoints.

> 
> I'll have another go with usbsnoop later & post the log if I don't get 
> anywhere
> 
> regards Andrew
regards
Antti

-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
