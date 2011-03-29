Return-path: <mchehab@pedra>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:50813 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1C2Vie (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2011 17:38:34 -0400
Message-ID: <4D925153.30403@kolumbus.fi>
Date: Wed, 30 Mar 2011 00:38:27 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Subject: Re: Pending dvb_dmx_swfilter(_204)() patch tested enough
References: <4D8E4AA2.7070408@kolumbus.fi> <4D9079FD.1060303@linuxtv.org>
In-Reply-To: <4D9079FD.1060303@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hello Andreas and Mauro

Thank you for looking at the patch.
Than you Mauro for giving the likely() unlikely() GCC assembly example
and remind of scripts/checkpatch.pl.

28.03.2011 15:07, Andreas Oberritter wrote:
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
I'll rename it as find_next_packet().

>
> - Remove disabled printk() calls.
I'll do that.

>
> - Only one statement per line.
> 	if (unlikely(lost = pos - start)) {
> 	while (likely((p = findNextPacket(buf, p, count, pktsize))<  count)) {

I'll alter while() line as:

	while (1) {
		p = find_next_packet(buf, p, count, pktsize);
		if (p >= count)
			break;
		if (count - p < pktsize)
			break;



>
> - Add white space between while and the opening brace.
> 	while(likely(pos<  count)) {
Thanks.

>
> - Use unsigned data types for pos and pktsize:
> 	static inline int findNextPacket(const u8 *buf, int pos, size_t count,
> 	const int pktsize)

I'll change them.

>
> The CodingStyle[1] document can serve as a guideline on how to properly
> format kernel code.
Thanks. I have read it, but reading again is always good for learning.
>
> Does the excessive use of likely() and unlikely() really improve the
> performance or is it just a guess?

I'll try to measure performance difference next weekend: I haven't tested the effect
on likely/unlikely operations. I have tested the effect of the whole patch only.
I selected likely and unlikely() sentences very carefully, so they should be correct.



I'm not sure if recovering a packet by backtracking is worth it on my patch:
If recovered packets are typically discarded by dvb_dmx_swfilter_packet() later, I'll drop the code.

Here is a description of the problem as I saw it last Summer:

My DVB card seemed to lose a few packets somewhere in the DMA transfer buffer and then had a short packet
(less than 204 garbage bytes) and then normal good packets.

Backtracking use case (deliver 16K bytes of data for dvb_dmx_swfilter_204() per call):
1. DVB card loses a few packets.
2. DVB card delivers less than 204 bytes garbage, containing packet start byte in the middle.
3. dvb_dmx_swfilter_204() finds start byte from garbage. Deliver 204 sized garbage packet into dvb_dmx_swfilter_packet().
4. dvb_dmx_swfilter_204() detects that packet at (3) was garbage. One good packet can be restored by buffer backtracking.
5. dvb_dmx_swfilter_204() delivers restored packet into dvb_dmx_swfilter_packet().
6. dvb_dmx_swfilter_204() continues to deliver 204 sized packets into dvb_dmx_swfilter_packet().

I suspect that on (5), the restored packet is discarded by dvb_dmx_swfilter_packet() because of
packet counter sequencing error. There is no benefit with recovering the packet in this (typical) case.
dvb_dmx_swfilter_packet() will discard packets until it finds a next group of packets with group
start identifier. Is this correct?

Regards,
Marko Ristola

>
> Regards,
> Andreas
>
> [1]
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/CodingStyle
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

