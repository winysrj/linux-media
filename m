Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.viadmin.org ([195.145.128.101])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <henrik-dvb@prak.org>) id 1Lt3tM-0007tn-2I
	for linux-dvb@linuxtv.org; Sun, 12 Apr 2009 19:54:53 +0200
Received: from localhost (localhost.localdomain [127.0.0.1])
	by www.viadmin.org (Postfix) with ESMTP id 120C71860B
	for <linux-dvb@linuxtv.org>; Sun, 12 Apr 2009 19:54:18 +0200 (CEST)
Received: from www.viadmin.org ([127.0.0.1])
	by localhost (www.viadmin.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EzDUKbbKKtuf for <linux-dvb@linuxtv.org>;
	Sun, 12 Apr 2009 19:53:53 +0200 (CEST)
Date: Sun, 12 Apr 2009 19:53:53 +0200
From: "H. Langos" <henrik-dvb@prak.org>
To: linux-dvb@linuxtv.org
Message-ID: <20090412175352.GC12581@www.viadmin.org>
References: <20090411221740.GB12581@www.viadmin.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090411221740.GB12581@www.viadmin.org>
Subject: Re: [linux-dvb] DVB-T USB dib0700 device recomendations?
Reply-To: linux-media@vger.kernel.org
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

On Sun, Apr 12, 2009 at 12:17:40AM +0200, H. Langos wrote:
> I've been trying to minimize energy consumption and noise on my vdr system.
> One of the most important factors apart from a hardware pid filter seems to
> be the usb buffer size. I've collected some data about that on my wiki user 
> page: http://www.linuxtv.org/wiki/index.php/User:Hlangos
> 
> Greping through the sources I've seen that the dib0700 driver uses a HUGE
> usb buffer of 39480 bytes. This looks very promising. But before running 
> out in the street and buying the first dib0700 device I'd like to know if 
> there are any devices that are 
> 
> - especially good (sensitive reception, fast switch time, sensible tuner 
>   data (usable for comparing different antennas) and so on)
> 
> or 
> 
> - especially bad (invers of the above plus hardware bugs, annoyances and so
>   on..)
> 
> any feedback is appreciated. 
> 
> cheers
> -henrik
> 
> PS: A "full" remote (not one of those pesky credit card sized things that get 
> eaten by the hoover) would be a plus. 

Just to remind ppl what the dib0700 driver supports:

# grep "{   \"" dib0700_devices.c | sort
                        {   "Artec T14BR DVB-T",
                        {   "Asus My Cinema-U3000Hybrid",
                        {   "ASUS My Cinema U3000 Mini DVBT Tuner",
                        {   "ASUS My Cinema U3100 Mini DVBT Tuner",
                        {   "AVerMedia AVerTV DVB-T Express",
                        {   "AVerMedia AVerTV DVB-T Volar",
                        {   "Compro Videomate U500",
                        {   "DiBcom STK7070PD reference design",
                        {   "DiBcom STK7070P reference design",
                        {   "DiBcom STK7700D reference design",
                        {   "DiBcom STK7700P reference design",
                        {   "Gigabyte U7000",
                        {   "Gigabyte U8000-RH",
                        {   "Hauppauge Nova-T 500 Dual DVB-T",
                        {   "Hauppauge Nova-TD-500 (84xxx)",
                        {   "Hauppauge Nova-TD Stick (52009)",
                        {   "Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity",
                        {   "Hauppauge Nova-T MyTV.t",
                        {   "Hauppauge Nova-T Stick",
                        {   "Hauppauge Nova-T Stick",
                        {   "Leadtek Winfast DTV Dongle (STK7700P based)",
                        {   "Pinnacle Expresscard 320cx",
                        {   "Pinnacle PCTV 2000e",
                        {   "Pinnacle PCTV 72e",
                        {   "Pinnacle PCTV 73e",
                        {   "Pinnacle PCTV Dual DVB-T Diversity Stick",
                        {   "Pinnacle PCTV DVB-T Flash Stick",
                        {   "Pinnacle PCTV HD Pro USB Stick",
                        {   "Pinnacle PCTV HD USB Stick",
                        {   "Terratec Cinergy DT XS Diversity",
                        {   "Terratec Cinergy HT Express",
                        {   "Terratec Cinergy HT USB XE",
                        {   "Terratec Cinergy T Express",
                        {   "Terratec Cinergy T USB XXS",
                        {   "Uniwill STK7700P based (Hama and others)",
                        {   "Yuan EC372S",
                        {   "YUAN High-Tech STK7700PH",

cheers
-henrik
 

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
