Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1KLyld-0000wl-Uq
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 13:14:01 +0200
Message-ID: <488863EF.8000402@iinet.net.au>
Date: Thu, 24 Jul 2008 19:13:51 +0800
From: Tim Farrington <timf@iinet.net.au>
MIME-Version: 1.0
To: tobi@to-st.de
References: <488860FE.5020500@iinet.net.au> <4888623F.5000108@to-st.de>
In-Reply-To: <4888623F.5000108@to-st.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvb mpeg2?
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

Tobias Stoeber wrote:
> Tim Farrington schrieb:
>> Can you please give me some guidance as to how to discover
>> what format is output from the v4l-dvb driver.
>>
>> The DVB-T standard is, as I understand it, MPEG2,
>> however with kaffeine, me-tv, mplayer if I record to a file,
>> (dump from the raw data stream),
>> it appears to be stored as a MPEG1 file.
>> If I use GOPchop, it will not open any of these files,
>> as it will only open MPEG2 files.
>
> Well if I remember it right, a DVB stream (in MPEG2) is MPEG2-TS and 
> GOPchop will handle MPEG2-PS!
>
> Cheers, Tobias
>
Hi Tobias,
Do you mean GOPchop won't open MPEG2-TS?

What I'm after is some tool/means which will accurately display a format 
descriptor for
a MPEG(x) file/stream.

MPEG2-TS is what is supposed to be the format, but how can I discover if 
it really is?

Regards,
Tim Farrington

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
