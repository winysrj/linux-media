Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:63625 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbZCaTTl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 15:19:41 -0400
Received: by ewy9 with SMTP id 9so2734588ewy.37
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2009 12:19:37 -0700 (PDT)
Message-ID: <49D26CC5.10801@laposte.net>
Date: Tue, 31 Mar 2009 21:19:33 +0200
From: Thomas RENARD <threnard@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Olivier MENUEL <omenuel@laposte.net>, linux-media@vger.kernel.org
Subject: Re: AverMedia Volar Black HD (A850)
References: <200903291334.00879.olivier.menuel@free.fr>	 <49D1287C.5010803@iki.fi> <49D13272.7050906@laposte.net>	 <200903310048.19629.omenuel@laposte.net> <49D150C6.5060207@iki.fi> <7a3c9e3d0903310004y31635654l6ab3884560118efc@mail.gmail.com> <49D1D0C6.9040400@iki.fi>
In-Reply-To: <49D1D0C6.9040400@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have tested http://linuxtv.org/hg/~anttip/af9015_aver_a850_2.
*It works for me !*

Here is info for Kernel changelog :
*Tested-by: Thomas Renard <threnard@gmail.com> *

I just have this error message during scan but I don't know the severity :
scan -n -o zap -p /usr/share/doc/dvb-utils/examples/scan/dvb-t/fr-Paris 
 > channels.conf
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/fr-Paris
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 474000000 0 2 9 3 1 0 0
initial transponder 498000000 0 2 9 3 1 0 0
initial transponder 522000000 0 2 9 3 1 0 0
initial transponder 562000000 0 2 9 3 1 0 0
initial transponder 586000000 0 3 9 3 1 2 0
 >>> tune to: 
474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
0x0000 0x0201: pmt_pid 0x0500 NTN -- Direct 8 (running)
0x0000 0x0203: pmt_pid 0x0502 NTN -- BFM TV (running)
...
0x0000 0x0176: pmt_pid 0x02c6 GR1 -- France � (running)
WARNING: filter timeout pid 0x0010
 >>> tune to: 
-10:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
*__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 
22 Invalid argument*
 >>> tune to: 
-10:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
*__tune_to_transponder:1483: ERROR: Setting frontend parameters failed: 
22 Invalid argument*
dumping lists (36 services)
Done.


Thanks for your help !
Regards,

Thomas




Antti Palosaari a écrit :
>
> hello
> waiting :) If it works add tested-by to your mail reply
> Tested-by: Firsname Lastname <email@address.com>
>
> Then I can add that to the Kernel changelog. It is not absolutely 
> needed but it is nice to have some mention who has done job for patch. 
> Also Olivier! If you don't have nothing to send ml where attach this 
> tag then you can send Tested-by directly to me.
>
> regards
> Antti
>
>
> Thomas RENARD wrote:
>> Hi Antti,
>>
>> I'm working today... I'll test
>> http://linuxtv.org/hg/~anttip/af9015_aver_a850_2/<http://linuxtv.org/hg/%7Eanttip/af9015_aver_a850_2/>this 
>>
>> evening (time in Paris).
>>
>> Regards,
>>
>> Thomas
>>
>> 2009/3/31 Antti Palosaari <crope@iki.fi>
>>
>>> Olivier MENUEL wrote:
>>>
>>>> Here are my tests :
>>>>
>>>> http://linuxtv.org/hg/~anttip/af9015_aver_a850_2/<http://linuxtv.org/hg/%7Eanttip/af9015_aver_a850_2/>: 
>>>>
>>>>
>>>> I found why kaffeine was not working : I needed to check all offset
>>>> checkboxes when scanning.
>>>> Like Thomas, I get these messages in /var/log/messages when 
>>>> scanning or
>>>> changing channel : af9015_pid_filter_ctrl: onoff:0 (with kaffeine, 
>>>> scan or
>>>> vlc)
>>>>
>>> That's normal behaviour. dvb-usb-framework calls .pid_filter_ctrl(0)
>>> callback to ensure pid-filter is disabled. Those logs will not seen 
>>> normally
>>> when debug-logs are disabled.
>>>
>>> I found a weird thing though with kaffeine (that may be a wrong setting
>>>> somewhere in kaffeine though, it's the first time I use a DVB 
>>>> device on
>>>> linux). If I stop kaffeine and restart it I can't access the 
>>>> channels I just
>>>> scanned anymore : I get an error message :
>>>> Tuning to: NRJ12 / autocount: 0
>>>> Using DVB device 0:0 "Afatech AF9013 DVB-T"
>>>> tuning DVB-T to 498167000 Hz
>>>> inv:2 bw:0 fecH:9 fecL:9 mod:6 tm:2 gi:4 hier:4
>>>> .....
>>>> Not able to lock to the signal on the given frequency
>>>> Frontend closed
>>>> Tuning delay: 1062 ms
>>>>
>>>> I need to switch channels several times and eventually it works : I 
>>>> can
>>>> now change channels without any problems !
>>>> But if I quit and restart kaffeine, I get the same problem again
>>>> No problem with VLC.
>>>>
>>> hmm, no idea. Sometimes I have also seen rather similar problems when
>>> switching channels but restarting Totem solves problem.
>>>
>>> I did full band w_scan and it founds all muxes I can receive (4xDVB-T +
>>> 1xDVB-H). I haven't tested Kaffeine.
>>>
>>> Except that everything seems to work perfectly fine !
>>>> I'm not sure exactly what you want me to test though.
>>>>
>>>>
>>>> GPI01 :
>>>>
>>>> Seems quite similar to previous one. Everything seems fine too 
>>>> (except the
>>>> weird kaffeine issue).
>>>> In the logs I get the same message : af9015_pid_filter_ctrl: onoff:0
>>>>
>>>>
>>>>
>>>> Finally, I tested GPI00 :
>>>>
>>>> Working fine too, seems exactly like previous ones.
>>>>
>>>> I hope I installed these correctly and did not mess up between the
>>>> different drivers.
>>>> Let me know if something seems weird or if you want me to test 
>>>> something
>>>> else.
>>>>
>>>> I'm really glad it finally works ;) Thanks a lot.
>>>>
>>> For me it seems like tuner is not connected to GPIO pin at all. I 
>>> will wait
>>> someone else, Thomas?, will test. Testing this (af9015_aver_a850_2) 
>>> tree is
>>> enough if it works:
>>> http://linuxtv.org/hg/~anttip/af9015_aver_a850_2/<http://linuxtv.org/hg/%7Eanttip/af9015_aver_a850_2/> 
>>>
>>>
>>>
>>> regards
>>> Antti
>>> -- 
>>> http://palosaari.fi/
>>>
>>
>
>
