Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f20.google.com ([209.85.217.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1Kd5EC-0003Mt-Co
	for linux-dvb@linuxtv.org; Tue, 09 Sep 2008 17:34:05 +0200
Received: by gxk13 with SMTP id 13so11585186gxk.17
	for <linux-dvb@linuxtv.org>; Tue, 09 Sep 2008 08:33:30 -0700 (PDT)
Message-ID: <d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
Date: Tue, 9 Sep 2008 17:33:30 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Rudy Zijlstra" <rudy@grumpydevil.homelinux.org>
In-Reply-To: <48C66829.1010902@grumpydevil.homelinux.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<48C66829.1010902@grumpydevil.homelinux.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

On Tue, Sep 9, 2008 at 2:12 PM, Rudy Zijlstra
<rudy@grumpydevil.homelinux.org> wrote:
> barry bouwsma wrote:
>> --- On Tue, 9/9/08, hermann pitton <hermann-pitton@arcor.de> wrote:
>>
>>
>>> following your thoughts, you are likely right. DVB-T2 likely indicates
>>> that you need new hardware, like it is for sure on DVB-S2.
>>>
>>
>> Servus,
>>
>> Disclaimer:  I'm only an outsider, not a programmer, and not
>> familiar with the digital broadcast specs or the DVB API, so
>> I will both not know what I'm talking about, and be asking
>> stupid questions.
>>
>>
>> I decided to look again at DVB-T2, as it's likely to be the
>> next change that will be in need of Linux support in a year
>> or so, at least in the UK, when hardware becomes available.
>>
> Likely true, DVB-T2 is well on the way in development.
>> My stupid question is, will DVB-T2, in Transport Stream mode,
>> be similar enough to existing DVB-T, apart from the extended
>> modulation parameters, that it can be fit into the existing
>> API, or am I overlooking something in my ignorance of the API?
>>
> TS is unchanged from DVB-T, simply higher capacity. The changes are in
> the modulation (and additional table entries)
>> This seems to me somewhat like the case of existing DVB-C,
>> where some hardware is incapable of 256QAM and so cannot tune
>> all the carriers, but I really haven't tried to understand
>> the API or how it can be extended without breaking things...
>>
> That is old... QAM256 is pretty standard now. Only rather old HW should
> be incapable of handling QAM-256.
>
>>
>> In looking at the Wikipedia article on DVB-T, it appears that
>> at least the following diffs to include/dvb/frontend.h might
>> be needed to support the additional possibilities that a DVB-T2
>> tuner would be likely to support -- diff against the S2API, as
>> this file is unchanged in multiproto, while S2API already has
>>
>> the additional FEC values present...
>>
>
>  From my understanding, S2API is a generic approach, and should not have
> troubles supporting these standards.
>> goto Disclaimer;
>>
>>
>
>
> DVB-C2, i do not expect to get beyond definition stage, as - unless
> someone is really willing to pay for it - it seems unlikely there will
> be a market for it.
> Too many significantly cheaper solutions to solve the problem on cable.
>

How many devices are currently supported by the multiproto API
compared with the s2 tree?
I know the same happened with the em28xx tree initially where a few
10k lines just got burned in
favor of having something else. The same should just not happen again I'd say.
Since I went through retesting many devices and since I'm now still
not completely done with that
this should seriously be avoided, especially in terms of delaying
support for many devices.
As from my side I have to write it was a good move for the em28xx to
make it independent especially
since business customers use the improved version now and don't have
to fear any uncoordinated
breakage.
Although back to the first question - this is the interesting one.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
