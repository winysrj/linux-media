Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <claesl@gmail.com>) id 1JcFEm-0001cy-Fp
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 08:30:56 +0100
Received: by fg-out-1718.google.com with SMTP id 22so586977fge.25
	for <linux-dvb@linuxtv.org>; Thu, 20 Mar 2008 00:30:52 -0700 (PDT)
Message-ID: <47E212A4.5060400@gmail.com>
Date: Thu, 20 Mar 2008 08:30:44 +0100
From: Claes Lindblom <claesl@gmail.com>
MIME-Version: 1.0
To: Igor <goga777@bk.ru>
References: <47DEDA99.8060703@gmail.com>
	<E1JbUgV-000A7p-00.goga777-bk-ru@f9.mail.ru>
In-Reply-To: <E1JbUgV-000A7p-00.goga777-bk-ru@f9.mail.ru>
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
>>> try please 
>>> dvbsnoop -s ts -b -tsraw > YOUR.file.name
>>>
>>>   
>>>       
>> Ok, now I have tested dvbsnoop -s -ts -tsraw > svt_hd.ts
>> and got the following output from mplayer.
>>
>> TS file format detected.
>> VIDEO MPEG2(pid=512) AUDIO A52(pid=641) NO SUBS (yet)!  PROGRAM N. 0
>> TS_PARSE: COULDN'T SYNC
>> MPEG: FATAL: EOF while searching for sequence header.
>> Video: Cannot read properties.
>> ==========================================================================
>> Opening audio decoder: [liba52] AC3 decoding with liba52
>> Using SSE optimized IMDCT transform
>> Using MMX optimized resampler
>> AUDIO: 48000 Hz, 2 ch, s16le, 640.0 kbit/41.67% (ratio: 80000->192000)
>> Selected audio codec: [a52] afm: liba52 (AC3-liba52)
>> ==========================================================================
>> AO: [oss] 48000Hz 2ch s16le (2 bytes per sample)
>> Video: no video
>> Starting playback...
>> A:69923.4 (19:25:23.4) of 198.0 (03:18.0)  0.7%
>>
>> Exiting... (End of file)
>>
>> The file is about 16MB and audio seems to be working but it detects 
>> video as MPEG2 for some reason.
>>     
>
>
> How long (seconds, minutes...) this file ? 
> please, update your MPlayer - take the svn version.
> and finally please try to use dvbstream
>
> ./dvbstream -o 8192 > your.file
>
> Igor
>
>   
Maybe around 10 seconds long.
I have updated MPlayer with the latest svn and also the latest x264 
codec and the result is still the same with.

I don't understand how this dvbstream example works because of what I 
understand, dvbstream uses rtp streaming?

I'm running on a 2.6.24 kernel and Slamd 64 distribution. All standard 
channels works fine, but DVB-S2 is the main
issue to solve.

Has anyone really got VP 1041 and DVB-S2 to work properly with the 
mantis driver?

Regards
Claes




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
