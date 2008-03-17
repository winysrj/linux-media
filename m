Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <claesl@gmail.com>) id 1JbMMO-0003mk-HT
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 21:55:09 +0100
Received: by fk-out-0910.google.com with SMTP id z22so7485811fkz.1
	for <linux-dvb@linuxtv.org>; Mon, 17 Mar 2008 13:55:03 -0700 (PDT)
Message-ID: <47DEDA99.8060703@gmail.com>
Date: Mon, 17 Mar 2008 21:54:49 +0100
From: Claes Lindblom <claesl@gmail.com>
MIME-Version: 1.0
To: Igor <goga777@bk.ru>
References: <47DE1C7A.2060909@gmail.com>
	<E1JbAlD-000JyG-00.goga777-bk-ru@f116.mail.ru>
In-Reply-To: <E1JbAlD-000JyG-00.goga777-bk-ru@f116.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] AzureWave VP 1041 DVB-S2 problem
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

Igor wrote:
>>>> mplayer /dev/dvb/adapter1/dvr0
>>>>
>>>> mplayer says...
>>>>
>>>> TS file format detected.
>>>> VIDEO MPEG2(pid=515) AUDIO MPA(pid=652) NO SUBS (yet)!  PROGRAM N. 0
>>>> VIDEO:  MPEG2  544x576  (aspect 3)  25.000 fps  15000.0 kbps (1875.0 kbyte/s)
>>>>
>>>>
>>>> and the picture is shown.
>>>>     
>>>>         
>>> you can try with dvbsnoop or dvbstream
>>>
>>> http://allrussian.info/thread.php?postid=182975#post182975
>>>
>>> dvbstream -o 8192 | mplayer -
>>> or
>>> dvbsnoop -s ts -b -tsraw | mplayer -
>>>
>>> Igor
>>>   
>>>       
>> Hi,
>> I tried dvbsnoop on a recorded TS but I dont't understand how to read 
>> the output so I attached some of the output in
>> this mail. Is there something wrong with the output? This should be a 
>> decoded output of "SVT HD".
>> If it helps, I could get a similar log of an uncoded channel as a reference.
>>
>> Does anyone else have this problem or should it work "out of the box" 
>> with the mantis-driver, and the new szap?
>>
>> dvbsnoop V1.4.50 -- http://dvbsnoop.sourceforge.net/
>>
>>     
>
>
> try please 
> dvbsnoop -s ts -b -tsraw > YOUR.file.name
>
> Igor
>
>   
Ok, now I have tested dvbsnoop -s -ts -tsraw > svt_hd.ts
and got the following output from mplayer.

TS file format detected.
VIDEO MPEG2(pid=512) AUDIO A52(pid=641) NO SUBS (yet)!  PROGRAM N. 0
TS_PARSE: COULDN'T SYNC
MPEG: FATAL: EOF while searching for sequence header.
Video: Cannot read properties.
==========================================================================
Opening audio decoder: [liba52] AC3 decoding with liba52
Using SSE optimized IMDCT transform
Using MMX optimized resampler
AUDIO: 48000 Hz, 2 ch, s16le, 640.0 kbit/41.67% (ratio: 80000->192000)
Selected audio codec: [a52] afm: liba52 (AC3-liba52)
==========================================================================
AO: [oss] 48000Hz 2ch s16le (2 bytes per sample)
Video: no video
Starting playback...
A:69923.4 (19:25:23.4) of 198.0 (03:18.0)  0.7%

Exiting... (End of file)

The file is about 16MB and audio seems to be working but it detects 
video as MPEG2 for some reason.
How should I continue with this issue, should I publish the datastream 
somewhere?

Regards
Claes

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
