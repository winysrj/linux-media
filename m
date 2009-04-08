Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:63595 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbZDHN2J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2009 09:28:09 -0400
Received: by ewy9 with SMTP id 9so138802ewy.37
        for <linux-media@vger.kernel.org>; Wed, 08 Apr 2009 06:28:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49D150C6.5060207@iki.fi>
References: <200903291334.00879.olivier.menuel@free.fr>
	 <49D1287C.5010803@iki.fi> <49D13272.7050906@laposte.net>
	 <200903310048.19629.omenuel@laposte.net> <49D150C6.5060207@iki.fi>
Date: Wed, 8 Apr 2009 15:28:06 +0200
Message-ID: <74d0deb30904080628l27c88328m3a13deedf73e0c87@mail.gmail.com>
Subject: Re: AverMedia Volar Black HD (A850)
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Olivier MENUEL <omenuel@laposte.net>,
	Thomas RENARD <threnard@gmail.com>,
	Laurent Haond <lhaond@bearstech.com>,
	linux-media@vger.kernel.org,
	Karsten Blumenau <info@blume-online.de>,
	=?ISO-8859-1?Q?Martin_M=FCller?= <mueller1977@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 31, 2009 at 1:07 AM, Antti Palosaari <crope@iki.fi> wrote:
> Olivier MENUEL wrote:
>>
>> Here are my tests :
>>
>> http://linuxtv.org/hg/~anttip/af9015_aver_a850_2/ :
>>
>> I found why kaffeine was not working : I needed to check all offset
>> checkboxes when scanning.
>> Like Thomas, I get these messages in /var/log/messages when scanning or
>> changing channel : af9015_pid_filter_ctrl: onoff:0 (with kaffeine, scan or
>> vlc)
>
> That's normal behaviour. dvb-usb-framework calls .pid_filter_ctrl(0)
> callback to ensure pid-filter is disabled. Those logs will not seen normally
> when debug-logs are disabled.
>
>> I found a weird thing though with kaffeine (that may be a wrong setting
>> somewhere in kaffeine though, it's the first time I use a DVB device on
>> linux). If I stop kaffeine and restart it I can't access the channels I just
>> scanned anymore : I get an error message :
>> Tuning to: NRJ12 / autocount: 0
>> Using DVB device 0:0 "Afatech AF9013 DVB-T"
>> tuning DVB-T to 498167000 Hz
>> inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
>> .....
>> Not able to lock to the signal on the given frequency
>> Frontend closed
>> Tuning delay: 1062 ms
>>
>> I need to switch channels several times and eventually it works : I can
>> now change channels without any problems !
>> But if I quit and restart kaffeine, I get the same problem again
>> No problem with VLC.
>
> hmm, no idea. Sometimes I have also seen rather similar problems when
> switching channels but restarting Totem solves problem.
>
> I did full band w_scan and it founds all muxes I can receive (4xDVB-T +
> 1xDVB-H). I haven't tested Kaffeine.
>
>> Except that everything seems to work perfectly fine !
>> I'm not sure exactly what you want me to test though.
>>
>>
>> GPI01 :
>>
>> Seems quite similar to previous one. Everything seems fine too (except the
>> weird kaffeine issue).
>> In the logs I get the same message : af9015_pid_filter_ctrl: onoff:0
>>
>>
>>
>> Finally, I tested GPI00 :
>>
>> Working fine too, seems exactly like previous ones.
>>
>> I hope I installed these correctly and did not mess up between the
>> different drivers.
>> Let me know if something seems weird or if you want me to test something
>> else.
>>
>> I'm really glad it finally works ;) Thanks a lot.
>
> For me it seems like tuner is not connected to GPIO pin at all. I will wait
> someone else, Thomas?, will test. Testing this (af9015_aver_a850_2) tree is
> enough if it works:
> http://linuxtv.org/hg/~anttip/af9015_aver_a850_2/

I guess I'm a bit late, is there still anything to test?

I tried http://linuxtv.org/hg/~anttip/af9015 (2f6cf8db5325), using
scan, tzap and mplayer. Except for low signal quality (bad location +
lack of proper antenna), everything seemed to work fine.

best regards
Philipp
