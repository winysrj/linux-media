Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpd4.aruba.it ([62.149.128.209] helo=smtp4.aruba.it)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <a.venturi@avalpa.com>) id 1Kns8m-0001iB-HZ
	for linux-dvb@linuxtv.org; Thu, 09 Oct 2008 11:49:06 +0200
Message-ID: <48EDD354.3090506@avalpa.com>
Date: Thu, 09 Oct 2008 11:48:04 +0200
From: Andrea Venturi <a.venturi@avalpa.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------050708050702050905050503"
Subject: [linux-dvb] siano sms1xxx driver not T-DMB ready?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------050708050702050905050503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

here in Italy (bologna) we have a T-DMB trial from Rai and other 
broadcasters.

i got one Terratec Cinergy Piranha based on a Siano SMS1xxx chip and 
indeed the  T-DMB stream works on the "other OS".. (and the DVB-T works too)

this T-DMB stuff is still based on Transport Stream:

  http://en.wikipedia.org/wiki/Digital_Multimedia_Broadcast

as i'd like to dump a full TS of the stream, i was thinking that it was 
just setting the proper mode (2) in the sms1xxx module, i would have 
been able to use the same "dvb-tools" like dvbstream to tune the right 
frequency and dump the whole TS.

too easy, it seems! there were my steps:

1. i put the firmware file for T-DMB demodulation with the right name  
"tdmb_stellar_usb.inp" in /lib/firmware

2. i loaded the module with the supposed right default mode: modprobe 
sms1xxx default_mode=2

3. i put my stick on the linux,  but the module didn't got up with this 
error:

  "SMS Device mode is not set for DVB operation."

I'm halted.

The showstopper come from this smsdvb.c where there's this control:

====================
        if (smscore_get_devicke_mode(coredev) != 4) {
#if 1 /* new siano drop (1.2.17) does this -- yuck */
                sms_err("SMS Device mode is not set for "
                        "DVB operation.");
                return 0;
#else
====================

of course, this seems only a safety check.

let's hope it's not just a "marketing" showstopper (i'm going anyway to 
try to relax this control, i bet i'm not going to burn anything inside 
the device!)

probably there's more to be implemented to driver correctly the Siano 
chip when not in DVB mode. but how much? ask here could be useful..

it should be easy to "implement" the T-DMB stuff inside the same DVB 
scenario!
it's already a system based on transport stream. right?

sadly there are no open specs about it on the siano web site, just this 
brief:

  http://www.*siano-ms*.com/*pdf*s/00_Siano_SMS*1010*.*pd*f

does anyone know a solution about this issue?

is it so though to implement T-DMB decoding inside the DVB architecture?

are the specs available somewhere?

bye

andrea venturi


--------------050708050702050905050503
Content-Type: text/x-vcard; charset=utf-8;
 name="a_venturi.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="a_venturi.vcf"

begin:vcard
fn:Andrea Venturi
n:;Andrea Venturi
org:Avalpa Digital Engineering SRL
adr;dom:;;Via dell'Arcoveggio 49/5;Bologna;BO;40129
email;internet:a.venturi@avalpa.com
title:CEO
tel;work:+39 0514187531
tel;cell:+39 3477142994
url:www.avalpa.com
version:2.1
end:vcard


--------------050708050702050905050503
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------050708050702050905050503--
