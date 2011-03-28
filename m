Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:58284 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab1C1MH3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2011 08:07:29 -0400
Message-ID: <4D9079FD.1060303@linuxtv.org>
Date: Mon, 28 Mar 2011 14:07:25 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Marko Ristola <marko.ristola@kolumbus.fi>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Subject: Re: Pending dvb_dmx_swfilter(_204)() patch tested enough
References: <4D8E4AA2.7070408@kolumbus.fi>
In-Reply-To: <4D8E4AA2.7070408@kolumbus.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Marko,

On 03/26/2011 09:20 PM, Marko Ristola wrote:
> Following patch has been tested enough since last Summer 2010:
>
> "Avoid unnecessary data copying inside dvb_dmx_swfilter_204() function"
> https://patchwork.kernel.org/patch/118147/
> It modifies both dvb_dmx_swfilter_204() and dvb_dmx_swfilter()  functions.

sorry, I didn't know about your patch. Can you please resubmit it with
the following changes?

- Don't use camelCase (findNextPacket)

- Remove disabled printk() calls.

- Only one statement per line.
	if (unlikely(lost = pos - start)) {
	while (likely((p = findNextPacket(buf, p, count, pktsize)) < count)) {

- Add white space between while and the opening brace.
	while(likely(pos < count)) {

- Use unsigned data types for pos and pktsize:
	static inline int findNextPacket(const u8 *buf, int pos, size_t count,
	const int pktsize)

The CodingStyle[1] document can serve as a guideline on how to properly
format kernel code.

Does the excessive use of likely() and unlikely() really improve the
performance or is it just a guess?

Regards,
Andreas

[1]
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/CodingStyle
