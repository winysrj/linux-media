Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <miloody@gmail.com>) id 1KMHcB-0006w5-VD
	for linux-dvb@linuxtv.org; Fri, 25 Jul 2008 09:21:25 +0200
Received: by wx-out-0506.google.com with SMTP id h27so1145178wxd.17
	for <linux-dvb@linuxtv.org>; Fri, 25 Jul 2008 00:21:19 -0700 (PDT)
Message-ID: <3a665c760807250021h3eebae81mb04fe8b9826b5259@mail.gmail.com>
Date: Fri, 25 Jul 2008 15:21:19 +0800
From: loody <miloody@gmail.com>
To: "Christophe Thommeret" <hftom@free.fr>
In-Reply-To: <200807250902.15858.hftom@free.fr>
MIME-Version: 1.0
Content-Disposition: inline
References: <3a665c760807242347o4dc9bed2p62e5454fb432bece@mail.gmail.com>
	<200807250902.15858.hftom@free.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] question about section command in dvbsnoop
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

hi:
thanks for your help.
I can see the section information right now.

But I have one more question.
The option you tell me is used under ts mode.
If I remember correctly, the default mode which dvbsnoop operate is section.
And dvbsnoop should tell me the same section information under section
mode, just like the example webpage shows.

appreciate your help,
miloody


2008/7/25 Christophe Thommeret <hftom@free.fr>:
> Le Friday 25 July 2008 08:47:53 loody, vous avez =E9crit :
>> Dear all:
>> I try to get section information in my TS streams.
>> The commands I use are:
>> dvbsnoop.exe -n 1 -if F:\driver_source\TS_stream\mux1-cp.ts 0x00 >
>> PAT_0.log dvbsnoop.exe -n 1 -if F:\driver_source\TS_stream\Monza.trp 0x0=
0 >
>> PAT_1.log
>>
>> But after changing the command mode to TS, I can get what I need.
>> dvbsnoop.exe -s ts -N 1 -if F:\driver_source\TS_stream\mux1-cp.ts 0x00
>>
>> > PAT_0_ts.log
>>
>> dvbsnoop.exe -s ts -N 1 -if F:\driver_source\TS_stream\Monza.trp 0x00
>>
>> > PAT_1_ts.log
>>
>> Is there any option I should use but I forget?
>
> -tssubdecode
>
> --
> Christophe Thommeret
>
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
