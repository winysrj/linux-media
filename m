Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41295 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbaFLMmw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 08:42:52 -0400
To: Niels Laukens <niels@dest-unreach.be>
Subject: Re: [BUG & PATCH] media/rc/ir-nec-decode : phantom keypress
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Thu, 12 Jun 2014 14:42:50 +0200
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
	=?UTF-8?Q?Antti_Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
In-Reply-To: <5399992E.8050502@dest-unreach.be>
References: <538994CB.6020205@dest-unreach.be>
 <53980DF8.5040206@dest-unreach.be>
 <330c58e7d7849824b812db007c03b08d@hardeman.nu>
 <53998D69.60901@dest-unreach.be>
 <754858effccb1d52ebec59f91f860c26@hardeman.nu>
 <5399992E.8050502@dest-unreach.be>
Message-ID: <0eaab4efe2fc37126f2bb444d7f3d507@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014-06-12 14:12, Niels Laukens wrote:
> On 2014-06-12 13:51, David Härdeman wrote:
>> On 2014-06-12 13:22, Niels Laukens wrote:
>>> In that case, the alternative would be to start a timer when the
>>> TRAILING_SPACE is entered, and trigger the key-event after, say 2
>>> bit-times.
>> 
>> Another alternative is fix the driver to implement a timeout so that
>> "unreasonable" values are not generated (I saw a 240550us space in 
>> your
>> log).
> 
> OK, that sounds like a good way to solve this as well.
> I'm very new to this subsystem, so I don't know what layer should
> perform what function.

I'm not 100% sure that would be the right fix, but I think so. Haven't 
looked at the driver.

>>>> Now, the question is why the trailing silence isn't generated
>>>> within a reasonable time. Which hardware decoder do you use?
>>> 
>>> I use the IR receiver built in to the TBS6281 DVB-T tuner card. I
>>> also have a TBS6982 DVB-S card, but I guess it's the same hardware.
>> 
>> Which driver?
> 
> I think it's the out-of-tree saa716x_tbs_dvb driver:
> 
> [    7.670565] input: saa716x IR (TurboSight TBS 6281) as
> /devices/pci0000:00/0000:00:1c.0/0000:02:00.0/rc/rc0/input6
> [    7.671156] rc0: saa716x IR (TurboSight TBS 6281) as
> /devices/pci0000:00/0000:00:1c.0/0000:02:00.0/rc/rc0

Could you paste the output from lsmod?

Where did you get the driver? Is it this one?
http://www.tbsdtv.com/download/document/common/tbs-linux-drivers_v140425.zip


>> And it's what most of the popular hardware does.
> 
> So I'll have to rework this patch to function at this lower level, and
> try to upstream it to TBS. Thank you for your time!
> 
> 
>> For instance, the
>> mceusb hardware will send a USB packet with timings including that
>> trailing silence. And the decoder can only do their work once a packet
>> has arrived (which will contain a number of samples). That also
>> demonstrates a potential problem with your suggested approach (i.e.
>> timings can be buffered so calls to the decoders are not necessarily
>> "real-time").
> 
> I see what you mean, but I don't see how the proposed patch fails in
> this sense. Or were you referring to the proposal of adding a timer at
> the ir-nec-decoder level?

Yes. The ir-nec-decoder timer doesn't know what the hardware is up to so 
it could timeout because it didn't get more data in time while at the 
same time the driver is buffering data...


