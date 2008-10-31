Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns1.nijcomplesk5.nl ([83.172.148.40])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jean-paul@goedee.nl>) id 1Kvpct-0001og-Bp
	for linux-dvb@linuxtv.org; Fri, 31 Oct 2008 09:45:03 +0100
Message-ID: <20081031094503.ytcihmrhckoskwwc@webmail.goedee.nl>
Date: Fri, 31 Oct 2008 09:45:03 +0100
From: jean-paul@goedee.nl
To: Alex Betis <alex.betis@gmail.com>
References: <20081029164747.h5xzc1hhwo0oocww@webmail.goedee.nl>
	<c74595dc0810291211k144f4f72nbbf85b3d3b8a79aa@mail.gmail.com>
	<20081030094113.zlaly2uj68ssgg4o@webmail.goedee.nl>
	<c74595dc0810301112h3d2ccf7ar7cf5e6bfe58f90d0@mail.gmail.com>
In-Reply-To: <c74595dc0810301112h3d2ccf7ar7cf5e6bfe58f90d0@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Update: S2API , scan-s2, TT 3200_CI, VDR 1.7.0,
	Streamdev (latest version)
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

I have change the makefile to correct place but i have some fs errors  =

and change the disk first before i test again.

JP



Citeren Alex Betis <alex.betis@gmail.com>:

> Do you have Igor's driver in ../s2/ directory?
>
> RTFM?
>
> Here's the part that I wrote in README:
> The driver directory was symbolically linked to "s2" directory. If you ha=
ve
> the driver in other directory,
> you'll have to change the following line in Makefile to point to the right
> place:
> INCLUDE=3D-I../s2/linux/include
>
>
> On Thu, Oct 30, 2008 at 10:41 AM, <jean-paul@goedee.nl> wrote:
>
>> compiled on opensuse 11.0 default.
>>
>>
>> gcc -I../s2/linux/include -c atsc_psip_section.c -o atsc_psip_section.o
>> gcc -I../s2/linux/include -c diseqc.c -o diseqc.o
>> gcc -I../s2/linux/include -c dump-vdr.c -o dump-vdr.o
>> gcc -I../s2/linux/include -c dump-zap.c -o dump-zap.o
>> gcc -I../s2/linux/include -c lnb.c -o lnb.o
>> gcc -I../s2/linux/include -c scan.c -o scan.o
>> scan.c: In function =E2tune_to_transponder=E2:
>> scan.c:1669: error: =E2SYS_DSS=E2 undeclared (first use in this function)
>> scan.c:1669: error: (Each undeclared identifier is reported only once
>> scan.c:1669: error: for each function it appears in.)
>> scan.c: In function =E2scan_tp=E2:
>> scan.c:2048: error: =E2SYS_DSS=E2 undeclared (first use in this function)
>> make: *** [scan.o] Error 1
>>
>> Jean-Paul
>>
>>
>>
>>  Please specify what was the error in scan-s2 compilation and what
>>> changeset
>>> you've used?
>>>
>>>
>>> On Wed, Oct 29, 2008 at 5:47 PM, <jean-paul@goedee.nl> wrote:
>>>
>>>  S2API (drivers) latest version compile without error, Compiling
>>>> scan-s2 give a error on DDS or something like that. Remove it from
>>>> scan.c and compile it again.
>>>>
>>>> Scanning booth LNB?s (astra 1  & 3) and only normal S. Try al options
>>>> but no S2 channels.  Compile VDR with S2API patch and streamdev
>>>> plugin. No problem so far. Copy the new channels.conf to the vdr
>>>> directory and start vdr. Tuning to FTA channels is no problem but
>>>> encrypt channels are not available. For so far as I can see the caids
>>>> are correct (verify with the caids of mij production system  (also
>>>> 2*tt 3200 incl cam/card and multiproto/vdr 1.7.0 and off Corse
>>>> streamdev.
>>>>
>>>> No S2 channels, No encrypt channels.
>>>>
>>>> Regards
>>>>
>>>> Jean-Paul
>>>>
>>>>
>>>>
>>>>
>>>>
>>>>
>>>> _______________________________________________
>>>> linux-dvb mailing list
>>>> linux-dvb@linuxtv.org
>>>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>>>
>>>>
>>>
>>
>>
>>
>




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
