Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab3CATzE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Mar 2013 14:55:04 -0500
Date: Fri, 1 Mar 2013 16:54:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: "H. Cristiano Alves Machado" <heberto.machado@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: Report of anomally in AVerMedia AVerTV Volar HD/PRO (A835)
 firmware
Message-ID: <20130301165457.2103fc4a@redhat.com>
In-Reply-To: <CA+pZ=S32rP-OObve-tpt4CXX6YdXGm3_XK1bOf3-s2RHZSPS4g@mail.gmail.com>
References: <CA+pZ=S32rP-OObve-tpt4CXX6YdXGm3_XK1bOf3-s2RHZSPS4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Cristiano,

Em Fri, 1 Mar 2013 19:47:19 +0000
"H. Cristiano Alves Machado" <heberto.machado@gmail.com> escreveu:

> Hello.
> 
> I believe that this might already have been reported...
> 
> 
> The problem can only be solved by physically removing the usb-dvb
> plug, and plugging it back again... :(

Well, this driver doesn't use dvb-usb stack anymore, it got ported to
dvb-usb-v2. I suggest you to test it again on kernel 3.8.

Btw, you're also reporting the issue to the wrong ML... linux-dvb ML
was deprecated a long time ago ;)

Regards,
Mauro
> 
> Below are the dmesg logs (both before dvb software reported error, and
> after, when the same software did not complain).
> 
> I am currently using vlc software to access dvb-t card (Avermedia
> mentioned in the subject).
> 
> Several times in the last few days/weeks, when I start the pc from off
> state (normal boot), the dvb card will fail to be accessed.
> 
> Iam currently running a 'Linux 3.5.0-18-generic #29~precise1-Ubuntu
> SMP  x86_64 GNU/Linux' setup, and "VLC media player 2.0.6 Twoflower
> (revision 2.0.5+git20130228+r534)" from the daily stable 'repo'.
> 
> Maybe the "critical" points could lie in the fact that after plugging
> the device  again it successfully loads the firmware. While during
> 'boot' time it can only "register it"
> 
> So, here are the 'dvb' dmesg "greps", and at the end the "cut" down
> differences between the two "moments".
> 
> [   13.154237] dvb-usb: found a 'AVerMedia AVerTV Volar HD/PRO (A835)'
> in warm state.
> [   13.154325] dvb-usb: will pass the complete MPEG2 transport stream
> to the software demuxer.
> [   13.154774] DVB: registering new adapter (AVerMedia AVerTV Volar
> HD/PRO (A835))
> [   13.165623] dvb-usb: MAC address: 00:00:00:00:00:00
> [   13.175623] dvb-usb: no frontend was attached by 'AVerMedia AVerTV
> Volar HD/PRO (A835)'
> [   13.175761] input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:1d.7/usb1/1-3/rc/rc0/input2
> [   13.175822] rc0: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:1d.7/usb1/1-3/rc/rc0
> [   13.175824] dvb-usb: schedule remote query interval to 250 msecs.
> [   13.175826] dvb-usb: AVerMedia AVerTV Volar HD/PRO (A835)
> successfully initialized and connected.
> [   13.194629] usbcore: registered new interface driver dvb_usb_af9035
> [17246.232556] dvb-usb: AVerMedia AVerTV Volar HD/PRO (A835)
> successfully deinitialized and disconnected.
> [17255.906733] dvb-usb: found a 'AVerMedia AVerTV Volar HD/PRO (A835)'
> in cold state, will try to load a firmware
> [17255.917426] dvb-usb: downloading firmware from file 'dvb-usb-af9035-02.fw'
> [17256.222632] dvb-usb: found a 'AVerMedia AVerTV Volar HD/PRO (A835)'
> in warm state.
> [17256.222739] dvb-usb: will pass the complete MPEG2 transport stream
> to the software demuxer.
> [17256.223030] DVB: registering new adapter (AVerMedia AVerTV Volar
> HD/PRO (A835))
> [17256.225735] dvb-usb: MAC address: 00:00:00:00:00:00
> [17256.227866] DVB: registering adapter 0 frontend 0 (Afatech AF9033 (DVB-T))...
> [17256.272866] input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:1d.7/usb1/1-3/rc/rc1/input12
> [17256.272938] rc1: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:1d.7/usb1/1-3/rc/rc1
> [17256.272941] dvb-usb: schedule remote query interval to 250 msecs.
> [17256.272944] dvb-usb: AVerMedia AVerTV Volar HD/PRO (A835)
> successfully initialized and connected.
> 
> Differences between the first section and the second:
> 
> 0a1,3
> >  dvb-usb: AVerMedia AVerTV Volar HD/PRO (A835) successfully deinitialized and disconnected.
> >  dvb-usb: found a 'AVerMedia AVerTV Volar HD/PRO (A835)' in cold state, will try to load a firmware
> >  dvb-usb: downloading firmware from file 'dvb-usb-af9035-02.fw'
> 5,7c8,10
> <  dvb-usb: no frontend was attached by 'AVerMedia AVerTV Volar HD/PRO (A835)'
> <  input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:1d.7/usb1/1-3/rc/rc0/input2
> <  rc0: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:1d.7/usb1/1-3/rc/rc0
> ---
> >  DVB: registering adapter 0 frontend 0 (Afatech AF9033 (DVB-T))...
> >  input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb1/1-3/rc/rc1/input12
> >  rc1: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb1/1-3/rc/rc1
> 10d12
> <  usbcore: registered new interface driver dvb_usb_af9035
> 
> 
> Hope there may be some solution to this... and at least that this
> report may have been useful.
> 
> Best regards
> 


-- 

Cheers,
Mauro
