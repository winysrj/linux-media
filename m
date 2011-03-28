Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:47681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab1C1V6b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2011 17:58:31 -0400
Message-ID: <4D910477.1030408@redhat.com>
Date: Mon, 28 Mar 2011 18:58:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Marko Ristola <marko.ristola@kolumbus.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Subject: Re: Pending dvb_dmx_swfilter(_204)() patch tested enough
References: <4D8E4AA2.7070408@kolumbus.fi> <4D9079FD.1060303@linuxtv.org>
In-Reply-To: <4D9079FD.1060303@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 28-03-2011 09:07, Andreas Oberritter escreveu:
> Hello Marko,
> 
> On 03/26/2011 09:20 PM, Marko Ristola wrote:
>> Following patch has been tested enough since last Summer 2010:
>>
>> "Avoid unnecessary data copying inside dvb_dmx_swfilter_204() function"
>> https://patchwork.kernel.org/patch/118147/
>> It modifies both dvb_dmx_swfilter_204() and dvb_dmx_swfilter()  functions.
> 
> sorry, I didn't know about your patch. Can you please resubmit it with
> the following changes?
> 
> - Don't use camelCase (findNextPacket)
> 
> - Remove disabled printk() calls.
> 
> - Only one statement per line.
> 	if (unlikely(lost = pos - start)) {
> 	while (likely((p = findNextPacket(buf, p, count, pktsize)) < count)) {
> 
> - Add white space between while and the opening brace.
> 	while(likely(pos < count)) {
> 
> - Use unsigned data types for pos and pktsize:
> 	static inline int findNextPacket(const u8 *buf, int pos, size_t count,
> 	const int pktsize)
> 
> The CodingStyle[1] document can serve as a guideline on how to properly
> format kernel code.

A good way for testing coding style is to run the scripts/checkpatch.pl.

It points most of the stuff at CodingStyle.

> Does the excessive use of likely() and unlikely() really improve the
> performance or is it just a guess?

I never tried to perf likely/unlikely, but, AFAIK, it will affect cache miss
rate and will also affect performance on superscalar architecture, as a
branch operation may clean the pipelines. So, avoiding an unneeded branch
will improve speed.

So, it is recommended to use it when you know what you're doing and need to
optimize performance.

There's an interesting explanation about it at:
	http://kerneltrap.org/node/4705

> 
> Regards,
> Andreas
> 
> [1]
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/CodingStyle

