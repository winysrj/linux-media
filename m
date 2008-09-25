Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+aab6bb3e1a0954efc56a+1859+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1KinqL-0005wE-VS
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 12:13:06 +0200
Date: Thu, 25 Sep 2008 07:12:50 -0300 (BRT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Patrick Boettcher <patrick.boettcher@desy.de>
In-Reply-To: <alpine.LRH.1.10.0809251156390.1247@pub1.ifh.de>
Message-ID: <alpine.LFD.1.10.0809250708330.21990@areia.chehab.org>
References: <573008.36358.qm@web52908.mail.re2.yahoo.com>
	<alpine.LRH.1.10.0809251152480.1247@pub1.ifh.de>
	<01DE66C3-8E94-4DC3-9828-DF2CD7B59EBB@pobox.com>
	<alpine.LRH.1.10.0809251156390.1247@pub1.ifh.de>
MIME-Version: 1.0
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

On Thu, 25 Sep 2008, Patrick Boettcher wrote:

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
> If hidraw is the right way, I'm with you. So far I wasn't sure what to
> do?!
>
> How would it work with the key-table onces it is done with hidraw?

Patrick,

If implemented properly, key code tables can be replaced anytime in 
userspace.

We have already a tool for this, under v4l2-apps/util. It is called 
keytable. The tool can be used to get the current key association of an 
input device, generating a text file, or to load a text file into an input 
device.

When you build the tool, the Makefile will parse several keycode tables 
already existing on V4L and at the common IR files, writing them into 
keycodes/ dir. It would be really easy to parse other files and create 
their tables as well.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
