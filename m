Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48ACC98A.4090201@linuxtv.org>
Date: Wed, 20 Aug 2008 21:48:58 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Damien Morrissey <damien@damienandlaurel.com>
References: <d16b033e0808201810wca140d8ob33dd6bae2dfcf8b@mail.gmail.com>
	<ee0ad0230808201844s512f8658pb2459c192cfa21d6@mail.gmail.com>
In-Reply-To: <ee0ad0230808201844s512f8658pb2459c192cfa21d6@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
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

On Thu, Aug 21, 2008 at 11:10 AM, Bonne Eggleston
<b.eggleston@gmail.com>wrote:
>   
>> Hi all,
>> I have a working Dvico Dual Digital 4 rev1 using some older drivers
>> (from http://linuxtv.org/hg/~pascoe/xc-test/<http://linuxtv.org/hg/%7Epascoe/xc-test/>
>> ).
>> I'm looking to upgrade my kernel from 2.6.18 to 2.6.25 or 26 and
>> thought I should get the most up to date dvb driver too.
>> What's the current recommended driver and firmware for this card?
>>
>>     

Damien Morrissey wrote:
> Be warned that there seems to be a funky thing with the firmware (in
> australia at least). I needed no less than three different firmware files to
> get my DVico Dual Digital 4 (rev1) to be recognised AND to successfully lock
> on a channel. Check for dmesg warnings. I am using mythbuntu 8.04.
>   

Please be advised that the posting policy on this mailing list is to
post your reply BELOW the quote.

It's irritating that I have to tell this to people repeatedly, and I'm
sure its even more irritating for others that have to constantly read my
complaints about it.

Nothing against you -- please don't top-post in the future.

Anyway, Damien....  Please try the latest driver in the v4l-dvb master
branch -- recent changesets have improved driver performance, and you
should not have the problems anymore that you have described, above.

The AU-specific firmware images have been deprecated, in favor of a much
better driver that works regardless of location.  Standard firmware is
not used, instead.

-Mike



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
