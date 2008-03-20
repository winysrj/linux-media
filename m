Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <claesl@gmail.com>) id 1JcFYM-0006gO-Ty
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 08:51:13 +0100
Received: by fk-out-0910.google.com with SMTP id z22so1115324fkz.1
	for <linux-dvb@linuxtv.org>; Thu, 20 Mar 2008 00:51:07 -0700 (PDT)
Message-ID: <47E21767.5010807@gmail.com>
Date: Thu, 20 Mar 2008 08:51:03 +0100
From: Claes Lindblom <claesl@gmail.com>
MIME-Version: 1.0
To: Igor <goga777@bk.ru>
References: <47E212A4.5060400@gmail.com>
	<E1JcFLn-000Ef8-00.goga777-bk-ru@f12.mail.ru>
In-Reply-To: <E1JcFLn-000Ef8-00.goga777-bk-ru@f12.mail.ru>
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
>>> How long (seconds, minutes...) this file ? 
>>> please, update your MPlayer - take the svn version.
>>> and finally please try to use dvbstream
>>>
>>> ./dvbstream -o 8192 > your.file
>>>
>>> Igor
>>>
>>>   
>>>       
>> Maybe around 10 seconds long.
>>     
>
> ok
>
>   
>> I have updated MPlayer with the latest svn 
>>     
>
> ok, it's right
>
>   
>> and also the latest x264 
>> codec and the result is still the same with.
>>     
>
> it's not need, because inside MPlayer already included the fresh ffmpeg - decoder for h264
>
>  
>   
>> I don't understand how this dvbstream example works because of what I 
>> understand, dvbstream uses rtp streaming?
>>     
>
> not only for rtp streaming, dvbstrem can record the files, too
>
>   
>> I'm running on a 2.6.24 kernel and Slamd 64 distribution. All standard 
>> channels works fine, but DVB-S2 is the main
>> issue to solve.
>>     
>
> so, it's better to write to Mplayer-dvb mailing list about your issue, and to upload your sample to Mplayer's ftp-server  ftp://upload.mplayerhq.hu/MPlayer/incoming
>
> Igor
>
>   
The strange part of this is that when using a DVB-C card there where no 
problem (except for performance) watching the same h.264
coded channel (SVT HD) so it feels like it should not be a mplayer issue.

I will try to mail mplayer-dvb and see what happens.

Can someone that got this card to work with DVB-S2  write down exactly 
how so I can compare with how I did it?

Regards
Claes

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
