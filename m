Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62880 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab1HRQNv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 12:13:51 -0400
Received: by vxi9 with SMTP id 9so1846928vxi.19
        for <linux-media@vger.kernel.org>; Thu, 18 Aug 2011 09:13:51 -0700 (PDT)
Message-ID: <4E4D3A3B.3040305@gmail.com>
Date: Thu, 18 Aug 2011 09:13:47 -0700
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: shacky <shacky83@gmail.com>
CC: Josu Lazkano <josu.lazkano@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Record DVB-T from command line
References: <CAPz3gmkRoh_gXU4PtzVhXb=0BOBjcgmhK7CCCq5ioajfjHZg3A@mail.gmail.com> <CAL9G6WUFyWuKJQnTBCW6StEfoWeKhXix3rFkU9eC8AxEbuD5Uw@mail.gmail.com> <CAPz3gm=ABUESbFNjL+RJ6RHMCGW_a4T70h6A3GP4b_B2ves92w@mail.gmail.com> <4E4D3946.5060900@gmail.com>
In-Reply-To: <4E4D3946.5060900@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 18-08-2011 09:09, Mauro Carvalho Chehab escreveu:
> Em 18-08-2011 08:47, shacky escreveu:
>>> szap -a 0 -c channels_astra.conf -r "TV3 CAT"
>>> cat /dev/dvb/adapter0/dvr0 > testvideo.mpg
>>> mplayer testvideo.mpg
>>
>> I tried that, but cat tells me that the device is busy:
>>
>> root@werecit1:/opt/utils/tv# tzap -c /etc/channels.conf -r "Rai 1"
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> reading channels from file '/etc/channels.conf'
>> tuning to 177500000 Hz
>> video pid 0x0200, audio pid 0x028a
>> status 00 | signal 1b1b | snr 000c | ber 0000ffff | unc 00000000 |
>> status 1f | signal fefe | snr 00f6 | ber 000000bd | unc 00000282 | FE_HAS_LOCK
>> [last line repeated several times]
>>
>> In another console:
>>
>> root@werecit1:~# cat /dev/dvb/adapter0/dvr0 > prova.mpg
>> cat: /dev/dvb/adapter0/dvr0: Dispositivo o risorsa occupata
>>
>> Could you help me please?
> 
> You can use gnometv for that. It is also part of dvb-utils package.
Sorry... the name of the application is: gnutv

You'll use it with something like:
	$ gnutv -out file test.mpeg -channels channel.conf mychannel

PS.: I'm fighting with a gnome application here that is doing something bad
when called fom xfce... so, "gnome" come to my mind, instead of "gnu" ;)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

