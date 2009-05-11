Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from thebe.shinternet.ch ([87.245.64.12] helo=mail.shinternet.ch)
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <wolfgang.friedl@shlink.ch>) id 1M3RsW-0004pJ-4o
	for linux-dvb@linuxtv.org; Mon, 11 May 2009 11:32:57 +0200
Received: from [192.168.0.35] (sasag.sh.pcp.ch [87.245.102.34])
	(authenticated bits=0)by mail.shinternet.ch
	(8.13.8/8.13.8/Submit_shinternet) with ESMTP id n4B9WqEF099127
	for <linux-dvb@linuxtv.org>; Mon, 11 May 2009 11:32:52 +0200 (CEST)
	(envelope-from wolfgang.friedl@shlink.ch)
Message-ID: <4A07F0EC.3080409@shlink.ch>
Date: Mon, 11 May 2009 11:33:32 +0200
From: Wolfgang Friedl <wolfgang.friedl@shlink.ch>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <49F57989.2010302@shlink.ch>
	<4A06F4AF.7050900@free.fr>	<4A072DC7.9010002@shlink.ch>
	<4A07E799.4070501@free.fr>
In-Reply-To: <4A07E799.4070501@free.fr>
Subject: Re: [linux-dvb] Infos regarding TERRATEC Cinergy HT PCMCIA
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

Mathieu Taillefumier schrieb:
> Hello,
> 
>> absolutely right, works fine, thank you.
>> I am sorry I haven't found the time till now to give short message of
>> the status till now (as I use to give when having asked on a list)
>>    
> it is alright
>> DVB-T everything OK (Ubuntu 8.x and Debian testing), analogue works by
>> using this PCI-DMA "trick" you mentionend (sox with alsa and a 22050
>> audio-rate gave best results) One thing to mention: a few channels come
>> only mute.
>> <http://www.sasag.ch/angebot/kabelTV.php>  (BR and superRTL, are the ones
>> as far as I remember).
>> It could be, that using a oss=0 option with saa7134 allows, when
>> switching to another, "working" channel, then "v4lctl volume mute off"
>> and switching back, can get you around - I had to few time to test
>> it/was not important enough; this problem seems to be a known issue, I
>> had later found some hits on this.
>>    
> I am not sure to understand. Do you mean that you have two channels with 
> the video but without the sound despite the fact that the sound is not 
> mute or is it something else. Personally, I never had this problem but I 
> am not using my tvcard very often so...
> 

Hello Mathieu,

it is: some channels only have the picture (good quality), but no sound.*

Trying "v4lctl volume mute off" "v4lctl volume mute on" "v4lctl volume 
mute off" (= toggling around) doesn't change, but

change channel to working channel and "toggling" around with the v4lctl 
volume mute off[/on] does sometimes help.
I am sorry I have so much info for "reproduction".
This phenomenon is true for kdetv as well as for tvtime.

kind regards,


-- 

     ###
    #   #
     # #
   Wolfgang
     # #
    #   #Freitag

* (I guessed it was like:
"In order to solve sound problems (some channels had no sound, or hashed 
sound...)"
<http://www.gentoo-wiki.info/SAA7134#Card_.26_tuner_type>

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
