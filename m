Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1KW0OZ-00060O-7B
	for linux-dvb@linuxtv.org; Thu, 21 Aug 2008 04:59:33 +0200
Message-ID: <48ACDA05.2070108@linuxtv.org>
Date: Wed, 20 Aug 2008 22:59:17 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Damien Morrissey <damien@damienandlaurel.com>
References: <d16b033e0808201810wca140d8ob33dd6bae2dfcf8b@mail.gmail.com>	
	<ee0ad0230808201844s512f8658pb2459c192cfa21d6@mail.gmail.com>	
	<48ACC98A.4090201@linuxtv.org>
	<ee0ad0230808201920p1bd21d1cpeb66c7c803c73333@mail.gmail.com>
In-Reply-To: <ee0ad0230808201920p1bd21d1cpeb66c7c803c73333@mail.gmail.com>
Cc: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Recommended repository for Dvico Dual Digital 4 rev1
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

Damien Morrissey wrote:
> On Thu, Aug 21, 2008 at 11:48 AM, Michael Krufky <mkrufky@linuxtv.org>wrote:
>> On Thu, Aug 21, 2008 at 11:10 AM, Bonne Eggleston
>> <b.eggleston@gmail.com>wrote:
>>     
>>>> Hi all,
>>>> I have a working Dvico Dual Digital 4 rev1 using some older drivers
>>>> (from http://linuxtv.org/hg/~pascoe/xc-test/<http://linuxtv.org/hg/%7Epascoe/xc-test/>
>>>>         
>> <http://linuxtv.org/hg/%7Epascoe/xc-test/>
>>     
>>>> ).
>>>> I'm looking to upgrade my kernel from 2.6.18 to 2.6.25 or 26 and
>>>> thought I should get the most up to date dvb driver too.
>>>> What's the current recommended driver and firmware for this card?
>>>>         
>> Damien Morrissey wrote:
>>     
>>> Be warned that there seems to be a funky thing with the firmware (in
>>> australia at least). I needed no less than three different firmware files to
>>>       
>>> get my DVico Dual Digital 4 (rev1) to be recognised AND to successfully lock
>>>       
>>> on a channel. Check for dmesg warnings. I am using mythbuntu 8.04.
>>>
>>>       
>> Anyway, Damien....  Please try the latest driver in the v4l-dvb master
>> branch -- recent changesets have improved driver performance, and you
>> should not have the problems anymore that you have described, above.
>>
>> The AU-specific firmware images have been deprecated, in favor of a much
>> better driver that works regardless of location.  Standard firmware is
>> not used, instead.
>>
>> -Mike
>>
>>
>>     
> I thought I was using the latest driver in the v4l-dvb master branch
> already... it's working now, but next release of mythbuntu I may clean the
> system out and I will report any issues then.
Unless somebody files a bug on launchpad, the fix won't be in Ubuntu
until Intrepid.  I think that comes out in a few months.

-Mike



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
