Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1Knwcw-0000gB-Lh
	for linux-dvb@linuxtv.org; Thu, 09 Oct 2008 16:36:34 +0200
Message-ID: <48EE16E4.4000107@linuxtv.org>
Date: Thu, 09 Oct 2008 10:36:20 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Andrea Venturi <a.venturi@avalpa.com>
References: <48EDD354.3090506@avalpa.com>
In-Reply-To: <48EDD354.3090506@avalpa.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] siano sms1xxx driver not T-DMB ready?
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

Andrea Venturi wrote:
> here in Italy (bologna) we have a T-DMB trial from Rai and other 
> broadcasters.
> 
> i got one Terratec Cinergy Piranha based on a Siano SMS1xxx chip and 
> indeed the  T-DMB stream works on the "other OS".. (and the DVB-T works 
> too)
> 
> this T-DMB stuff is still based on Transport Stream:
> 
>  http://en.wikipedia.org/wiki/Digital_Multimedia_Broadcast
> 
> as i'd like to dump a full TS of the stream, i was thinking that it was 
> just setting the proper mode (2) in the sms1xxx module, i would have 
> been able to use the same "dvb-tools" like dvbstream to tune the right 
> frequency and dump the whole TS.
> 
> too easy, it seems! there were my steps:
> 
> 1. i put the firmware file for T-DMB demodulation with the right name  
> "tdmb_stellar_usb.inp" in /lib/firmware
> 
> 2. i loaded the module with the supposed right default mode: modprobe 
> sms1xxx default_mode=2
> 
> 3. i put my stick on the linux,  but the module didn't got up with this 
> error:
> 
>  "SMS Device mode is not set for DVB operation."
> 
> I'm halted.
> 
> The showstopper come from this smsdvb.c where there's this control:
> 
> ====================
>        if (smscore_get_devicke_mode(coredev) != 4) {
> #if 1 /* new siano drop (1.2.17) does this -- yuck */
>                sms_err("SMS Device mode is not set for "
>                        "DVB operation.");
>                return 0;
> #else
> ====================
> 
> of course, this seems only a safety check.
> 
> let's hope it's not just a "marketing" showstopper (i'm going anyway to 
> try to relax this control, i bet i'm not going to burn anything inside 
> the device!)
> 
> probably there's more to be implemented to driver correctly the Siano 
> chip when not in DVB mode. but how much? ask here could be useful..
> 
> it should be easy to "implement" the T-DMB stuff inside the same DVB 
> scenario!
> it's already a system based on transport stream. right?
> 
> sadly there are no open specs about it on the siano web site, just this 
> brief:
> 
>  http://www.*siano-ms*.com/*pdf*s/00_Siano_SMS*1010*.*pd*f
> 
> does anyone know a solution about this issue?
> 
> is it so though to implement T-DMB decoding inside the DVB architecture?
> 
> are the specs available somewhere?


I am working with Siano to expose all functionality of the silicon through the linux-dvb api.

We didn't get up to T-DMB yet.  Give a few months and there should be better info to report.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
