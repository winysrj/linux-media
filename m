Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.230])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1Ketfr-0000KF-Vs
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 17:38:09 +0200
Received: by wx-out-0506.google.com with SMTP id t16so677420wxc.17
	for <linux-dvb@linuxtv.org>; Sun, 14 Sep 2008 08:38:04 -0700 (PDT)
Message-ID: <d9def9db0809140838k2ced5211gc2690e76f53a98be@mail.gmail.com>
Date: Sun, 14 Sep 2008 17:38:03 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Manu Abraham" <abraham.manu@gmail.com>
In-Reply-To: <48CC4D35.3000003@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<48C66829.1010902@grumpydevil.homelinux.org>
	<d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
	<48CC42D8.8080806@gmail.com>
	<d9def9db0809131556i6f0d07aci49ab288df38a8d5e@mail.gmail.com>
	<48CC4D35.3000003@gmail.com>
Cc: linux-dvb@linuxtv.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
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

On Sun, Sep 14, 2008 at 1:31 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
> Markus Rechberger wrote:
>> On Sun, Sep 14, 2008 at 12:46 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>>> Markus Rechberger wrote:
>>>
>>>> How many devices are currently supported by the multiproto API
>>>> compared with the s2 tree?
>>> The initial set of DVB-S2 multistandard devices supported by the
>>> multiproto tree is follows. This is just the stb0899 based dvb-s2 driver
>>> alone. There are more additions by 2 more modules (not devices), but for
>>> the simple comparison here is the quick list of them, for which some of
>>> the manufacturers have shown support in some way. (There has been quite
>>> some contributions from the community as well.):
>>>
>>> (Also to be noted is that, some BSD chaps also have shown interest in
>>> the same)
>>>
>>
>> they're heavy into moving the whole framework over as far as I've seen
>> yes, also including yet unmerged drivers.
>
>
> Using the same interface, the same applications will work there as well
> which is a bonus, but isn't the existing user interface GPL ? (A bit
> confused on that aspect)
>
>
>>> * STB0899 based
>>>
>>> Anubis
>>> Typhoon DVB-S2 PCI
>>>
>>> Azurewave/Twinhan
>>> VP-1041
>>> VP-7050
>>>
>>> Digital Now
>>> AD SP400
>>> AD SB300
>>>
>>> KNC1
>>> TV Station DVB-S2
>>> TV Station DVB-S2 Plus
>>>
>>> Pinnacle
>>> PCTV Sat HDTV Pro USB 452e
>>>
>>> Satelco
>>> TV Station DVB-S2
>>> Easywatch HDTV USB CI
>>> Easywatch HDTV PCI
>>>
>>> Technisat
>>> Skystar HD
>>> Skystar HD2
>>> Skystar USB2 HDCI
>>>
>>> Technotrend
>>> TT S2 3200
>>> TT S2 3600
>>> TT S2 3650
>>>
>>> Terratec
>>> Cinergy S2 PCI HD
>>> Cinergy S2 PCI HDCI
>>>
>>
>> those are pullable now against the current tree?
>
>
> These devices, depend upon the DVB API update without which it wouldn't
> work as they depend heavily on the DVB API framework. Without the
> updated framework, it doesn't make any sense to pull them: they won't
> even compile. The last but not least reason is that, the stb0899 driver
> is a DVB-S2 multistandard device which requires DVB-S2/DSS support
> additionally.
>

so the framework is available, and the drivers could be pushed in
right afterwards, I wonder
who is willing to port those drivers to the other API (including testing).
It's not going to happen any time soon I guess, if there's not an
agreement with Manu's
work. Dumping this code would show another step of ignorance and
selfishness against the
people who worked on it.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
