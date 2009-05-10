Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from thebe.shinternet.ch ([87.245.64.12] helo=mail.shinternet.ch)
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <wolfgang.friedl@shlink.ch>) id 1M3EtR-00035P-TV
	for linux-dvb@linuxtv.org; Sun, 10 May 2009 21:41:02 +0200
Received: from [10.10.0.44] (cable-dynamic-87-245-89-110.shinternet.ch
	[87.245.89.110]) (authenticated bits=0)by mail.shinternet.ch
	(8.13.8/8.13.8/Submit_shinternet) with ESMTP id n4AJet7Q075639
	for <linux-dvb@linuxtv.org>; Sun, 10 May 2009 21:40:56 +0200 (CEST)
	(envelope-from wolfgang.friedl@shlink.ch)
Message-ID: <4A072DC7.9010002@shlink.ch>
Date: Sun, 10 May 2009 21:40:55 +0200
From: Wolfgang Freitag-Friedl <wolfgang.friedl@shlink.ch>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <49F57989.2010302@shlink.ch> <4A06F4AF.7050900@free.fr>
In-Reply-To: <4A06F4AF.7050900@free.fr>
Subject: Re: [linux-dvb] Infos regarding TERRATEC Cinergy HT PCMCIA
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Mathieu Taillefumier schrieb am 10.05.2009 17:37   ---=A6
> Hello,
>> Hello,
>>
>> has anyone tested this card (TERRATEC Cinergy HT PCMCIA) or found useful
>> links I could follow?
>> <http://www.terratec.net/de/produkte/Cinergy_HT_PCMCIA_1599.html>
>>
>> <http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_HT_PCMCIA>
>> <http://www.linuxtv.org/pipermail/linux-dvb/2006-October/013898.html>
>>    =

> This card works since I was able to make it work on Fedora and CLFS =

> without any problems. The analogue part works with kdetv and mplayer. =

> The dvb-t part works too without problems with kaffeine for instance so =

> it should work with the dvb-tools. The only thing that needs a little =

> effort is the sound that is not directly send to the sound card. You =

> need to use the sox trick explained in the linuxtv wiki.
> =

>> kind regards,
>>    =

> Best
> =

> Mathieu

Hello,

absolutely right, works fine, thank you.
I am sorry I haven't found the time till now to give short message of
the status till now (as I use to give when having asked on a list)

DVB-T everything OK (Ubuntu 8.x and Debian testing), analogue works by
using this PCI-DMA "trick" you mentionend (sox with alsa and a 22050
audio-rate gave best results) One thing to mention: a few channels come
only mute.
<http://www.sasag.ch/angebot/kabelTV.php> (BR and superRTL, are the ones
as far as I remember).
It could be, that using a oss=3D0 option with saa7134 allows, when
switching to another, "working" channel, then "v4lctl volume mute off"
and switching back, can get you around - I had to few time to test
it/was not important enough; this problem seems to be a known issue, I
had later found some hits on this.

regards

-- =


     ###
    #   #
     # #
   wolfgang
     # #
    #   #freitag-friedl


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
