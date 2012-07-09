Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53486 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab2GISVe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2012 14:21:34 -0400
Received: by bkwj10 with SMTP id j10so6316895bkw.19
        for <linux-media@vger.kernel.org>; Mon, 09 Jul 2012 11:21:33 -0700 (PDT)
Message-ID: <4FFB2129.2070301@gmail.com>
Date: Mon, 09 Jul 2012 20:21:29 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Marx <acc.for.news@gmail.com>, linux-media@vger.kernel.org
Subject: Re: pctv452e
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi> <4FF4911B.9090600@web.de> <4FF4931B.7000708@iki.fi> <gjggc9-dl4.ln1@wuwek.kopernik.gliwice.pl> <4FF5A350.9070509@iki.fi> <r8cic9-ht4.ln1@wuwek.kopernik.gliwice.pl> <4FF6B121.6010105@iki.fi> <9btic9-vd5.ln1@wuwek.kopernik.gliwice.pl> <835kc9-7p4.ln1@wuwek.kopernik.gliwice.pl> <4FF77C1B.50406@iki.fi> <l2smc9-pj4.ln1@wuwek.kopernik.gliwice.pl> <4FF97DF8.4080208@iki.fi> <n1aqc9-sp4.ln1@wuwek.kopernik.gliwice.pl> <4FFA996D.9010206@iki.fi> <scerc9-bm6.ln1@wuwek.kopernik.gliwice.pl>
In-Reply-To: <scerc9-bm6.ln1@wuwek.kopernik.gliwice.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/09/2012 06:44 PM, Marx wrote:
> W dniu 2012-07-09 10:42, Antti Palosaari pisze:
>> On 07/09/2012 09:24 AM, Marx wrote:
>>> On 08.07.2012 14:32, Antti Palosaari wrote:
>>>> I suspect you stopped szap ?
>>>>
>>>> You cannot use dvbdate or dvbtraffic, nor read data from dvr0 unless
>>>> frontend is tuned. Leave szap running backround and try again.
>>>
>>> That way it works, and I can save stream. Hovewer it's strange because I
>>> shouldn't have to constatly tune channel to watch it, and on previous
>>> cards it was enough to tune once and then use other commands.
>>> I base my knowledge on
>>> http://www.linuxtv.org/wiki/index.php/Testing_your_DVB_device
>>> There is nothing about constant tuning channel to use it. Am I missing
>>> something?
>>
>> given wiki-page says:
>> "
>> 4. After you've tuned a frequency and program
>>
>> a) You could now start up your simple TV watching application and decode
>> the stream you have tuned.
>>
>> For example, while keeping {a,c,s,t}zap running in the first console
>> shell, open up another console and run
>> "
>>
>> Behavior have been always same, at least for the DVB USB.
>>
>> So you don't have problems at all?
> 
> ok, my fault
> problem still exists
> VDR doesn't play any channel, and while you asked me to abandon it, I
> saved some data using
>  cat /dev/dvb/adapter0/dvr0 > /mnt/video/test3.ts
> while tuning in the background.
> 
> Stream saved that way is unplayable (I play it using VLC for windows -
> it played almost all proper TS strems in the past I had). I've tried all
> software I have - to play this streams - no way.
> 
> So
> - I can tune only 2/3 of channels
> - TS stream saves with errors
> - traditional tuner on the same (brand new) dish works ok
> - i've exchanged cables between the two
> 
> is it possible that pctv device is less sensitive and the problem is
> with too weak signal?

Good reception on one device, completely different story on another
device - same cable; different tuner sensitivity.
It is *very* important to achieve *very* good signal reception with
larger dish(DVB-S) and/or Yagi-Uda(DVB-T) - focal angle/directional gain.
Try this one:
dvbstream -f freq -o 8192 > full-mux.ts
enough free disk space ;)
mplayer -cache 8912 full-mux.ts (TAB-TAB-TAB…)
or
dvbstream -f freq -o vid aid tid pid > single-stream.ts

cheers,
poma
