Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KesZl-0007Pq-Hg
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 16:27:48 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K76009K5W5A3H20@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sun, 14 Sep 2008 10:27:11 -0400 (EDT)
Date: Sun, 14 Sep 2008 10:27:10 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <d9def9db0809131910h2ff43b9auf86eb340adb2fac8@mail.gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Message-id: <48CD1F3E.6080900@linuxtv.org>
MIME-version: 1.0
References: <466109.26020.qm@web46101.mail.sp1.yahoo.com>
	<48C66829.1010902@grumpydevil.homelinux.org>
	<d9def9db0809090833v16d433a1u5ac95ca1b0478c10@mail.gmail.com>
	<48CC42D8.8080806@gmail.com>
	<d9def9db0809131556i6f0d07aci49ab288df38a8d5e@mail.gmail.com>
	<48CC4D35.3000003@gmail.com>
	<d9def9db0809131910h2ff43b9auf86eb340adb2fac8@mail.gmail.com>
Cc: linux-dvb@linuxtv.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>
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

Markus Rechberger wrote:
> On Sun, Sep 14, 2008 at 1:31 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>> Markus Rechberger wrote:
>>> On Sun, Sep 14, 2008 at 12:46 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
>>>> Markus Rechberger wrote:
>>>>
>>>>> How many devices are currently supported by the multiproto API
>>>>> compared with the s2 tree?
>>>> The initial set of DVB-S2 multistandard devices supported by the
>>>> multiproto tree is follows. This is just the stb0899 based dvb-s2 driver
>>>> alone. There are more additions by 2 more modules (not devices), but for
>>>> the simple comparison here is the quick list of them, for which some of
>>>> the manufacturers have shown support in some way. (There has been quite
>>>> some contributions from the community as well.):
>>>>
>>>> (Also to be noted is that, some BSD chaps also have shown interest in
>>>> the same)
>>>>
>>> they're heavy into moving the whole framework over as far as I've seen
>>> yes, also including yet unmerged drivers.
>>
>> Using the same interface, the same applications will work there as well
>> which is a bonus, but isn't the existing user interface GPL ? (A bit
>> confused on that aspect)
>>
> 
> I think it's good to have something that competes with Linux, I talked to some
> guys at that front too, and they seem to work close with application
> developers too
> As for the em28xx driver I agreed with pushing all my code (in case of
> linux, which
> includes unmerged independent drivercode from manufacturers) into their system
> using their license.

Something that competes with Linux, absolutely, I could not agree more - 
especially if the licenses are compatible and cross O/S pollination of 
ideas/code can occur. Everyone benefits from this.

Hauppauge had a guy from the BSD community contact us and ask for 
datasheets for certain parts. Part of the problem, as I understand it, 
is that the BSD folks can't port the GPL license into BSD because it's 
not compatible.

I owe it to myself to spend somehime reading the BSD licencing. Maybe 
the GPL is compatible with BSD.

Just my 2 cents.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
