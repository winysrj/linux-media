Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KizpM-0005VP-8k
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 01:00:53 +0200
Received: by fg-out-1718.google.com with SMTP id e21so455511fga.25
	for <linux-dvb@linuxtv.org>; Thu, 25 Sep 2008 16:00:49 -0700 (PDT)
Message-ID: <d9def9db0809251600s455f6d68ve11671cd17485791@mail.gmail.com>
Date: Fri, 26 Sep 2008 01:00:48 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Patrick Boettcher" <patrick.boettcher@desy.de>
In-Reply-To: <alpine.LRH.1.10.0809251156390.1247@pub1.ifh.de>
MIME-Version: 1.0
Content-Disposition: inline
References: <573008.36358.qm@web52908.mail.re2.yahoo.com>
	<alpine.LRH.1.10.0809251152480.1247@pub1.ifh.de>
	<01DE66C3-8E94-4DC3-9828-DF2CD7B59EBB@pobox.com>
	<alpine.LRH.1.10.0809251156390.1247@pub1.ifh.de>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] getting rid of input dev in dvb-usb (was: Re:
	[PATCH] Add remote control support to Nova-TD (52009))
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

On Thu, Sep 25, 2008 at 11:59 AM, Patrick Boettcher
<patrick.boettcher@desy.de> wrote:
> On Thu, 25 Sep 2008, Torgeir Veimo wrote:
>
>>
>> On 25 Sep 2008, at 19:53, Patrick Boettcher wrote:
>>
>>>>
>>>> This patch is against the 2.6.26.5 kernel, and adds remote control support
>>>> for the Hauppauge WinTV Nova-TD (Diversity) model. (That's the 52009
>>>> version.) It also adds the key-codes for the credit-card style remote
>>>> control that comes with this particular adapter.
>>>
>>> Committed and ask to be pulled, thanks.
>>
>>
>> Am curious, would it be possible to augment these drivers to provide the raw
>> IR codes on a raw hid device, eg. /dev/hidraw0 etc, so that other RC5 remotes
>> than the ones that actually are sold with the card can be used with the card?
>
> I would love that idea. Maybe this is the solution I have searched for so
> long. I desparately want to put those huge remote-control-table into
> user-space.
>

I'd also vote for this, the problem I experienced is that the timer
api has problems at the
deinitialization if the polling rate is too high. I read alot other
remote control code too even
figured out a bug in the i2c-kbd-dev module and submitted the
situation about it.

It's also commonly that the same USBid have different remote controls
using the same protocol (eg rc5, although
64bit keycodes are also coming up and those keymaps are just designed
for 32bit matching keys.

Markus

> If hidraw is the right way, I'm with you. So far I wasn't sure what to
> do?!
>
> How would it work with the key-table onces it is done with hidraw?
>
> Patrick.
>
> --
>   Mail: patrick.boettcher@desy.de
>   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
