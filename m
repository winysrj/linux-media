Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <redtux1@googlemail.com>) id 1LInJg-0001zv-4s
	for linux-dvb@linuxtv.org; Fri, 02 Jan 2009 17:56:09 +0100
Received: by bwz11 with SMTP id 11so13901222bwz.17
	for <linux-dvb@linuxtv.org>; Fri, 02 Jan 2009 08:55:34 -0800 (PST)
Message-ID: <ecc841d80901020855u730d55a1p4255deacab7db7d4@mail.gmail.com>
Date: Fri, 2 Jan 2009 16:55:33 +0000
From: "Mike Martin" <redtux1@googlemail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <1230887100.3791.2.camel@linux-wcrt.site>
MIME-Version: 1.0
Content-Disposition: inline
References: <ecc841d80901011033s58b2fecawd3dd2d42c1b09cd7@mail.gmail.com>
	<1230846027.3818.1.camel@linux-wcrt.site>
	<ecc841d80901011726m95a05f1l8b85b43630562d31@mail.gmail.com>
	<1230887100.3791.2.camel@linux-wcrt.site>
Subject: Re: [linux-dvb] dvbsream v0-5 and -n switch
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

On 02/01/2009, Nico Sabbi <nicola.sabbi@poste.it> wrote:
> Il giorno ven, 02/01/2009 alle 01.26 +0000, Mike Martin ha scritto:
>
>> Done a fresh checkout and now I cant stream anything other than the
>> whole stream (ie pid 8192)
>>
>> If I try
>> -ps
>>
>> I get
>> ../dvbstream/dvbstream -ps 5377 7078   -o > /media/video2/tvb.mpeg
>> dvbstream v0.7 - (C) Dave Chapman 2001-2004
>> Released under the GPL.
>> Latest version available from http://www.linuxstb.org/
>> ERROR: PS requires exactly two PIDS - video and audio.
>>
>> as opposed to
>>
>
>
>
>
>> ./dvbstream -ps 5377 7078   -o > /media/video2/tvb.mpeg
>> dvbstream v0.5 - (C) Dave Chapman 2001-2004
>> Released under the GPL.
>> Latest version available from http://www.linuxstb.org/
>> Setting filter for PID 5377
>> Setting filter for PID 7078
>> Output to stdout
>> Streaming 2 streams
>> Audiostream: Layer: 2  BRate: 128 kb/s  Freq: 48.0 kHz
>> Videostream: ASPECT: 4:3  Size = 544x576  FRate: 25 fps  BRate: 15.00
>> Mbit/s
>>
>
> fixed in cvs
>

I thought that I had got latest cvs. Could you confirm where cvs is
hosted, I assumed from sourceforge and did a checkout last night

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
