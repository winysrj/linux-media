Return-path: <linux-media-owner@vger.kernel.org>
Received: from old.radier.ca ([76.10.149.124]:56285 "EHLO server.radier.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753636Ab1KBPkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 11:40:15 -0400
Received: from localhost (unknown [127.0.0.1])
	by server.radier.ca (Postfix) with ESMTP id 88CF27A52E9
	for <linux-media@vger.kernel.org>; Wed,  2 Nov 2011 11:40:13 -0400 (EDT)
Received: from server.radier.ca ([127.0.0.1])
	by localhost (server.radier.ca [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nQbiOOf5yNab for <linux-media@vger.kernel.org>;
	Wed,  2 Nov 2011 11:40:10 -0400 (EDT)
Received: from server.radier.ca (server.radier.ca [76.10.144.93])
	by server.radier.ca (Postfix) with ESMTPA id BA3EF7A52CD
	for <linux-media@vger.kernel.org>; Wed,  2 Nov 2011 11:40:10 -0400 (EDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1251.1)
Subject: Re: KWorld USB UB435-Q v2 vid 0x1B80 pid 0xE346
From: Dmitriy Fitisov <dmitriy@radier.ca>
In-Reply-To: <FB79ECA9-6D75-4FEC-8938-746CDA7C5987@radier.ca>
Date: Wed, 2 Nov 2011 11:40:09 -0400
Content-Transfer-Encoding: 8BIT
Message-Id: <FC86F484-0B9A-4093-9ECA-A943A4ED32E2@radier.ca>
References: <FB79ECA9-6D75-4FEC-8938-746CDA7C5987@radier.ca>
To: linux-media <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Got it.
Once I sent out email, found reason on google.
It has bulk endpoint which is used as isoc!
I see now..
Thank everyone.

On 2011-11-02, at 10:39 AM, Dmitriy Fitisov wrote:

> Hello everyone,
> I have made modifications to em28xx and lgdt3305 
> making it "kinda work".
> I'm using scan program from dvb-apps for testing.
> I'm saying "kinda work" because I cannot verify for sure, I suspect something is missing.
> When I run scan it successfully locks on all channels which I have on my TV,
> but cannot find PAT on most channels.
> In MPEG2 stream I see that there is TS with PID 0x0000, but in most cases adaptation_field is 0,
> which treated by DVB as a no payload.
> Interesting enough that PUSI is set in this case.
> Could not find any info on this situation, except that packets with adaptation_field == 0
> must be discarded. 
> I live in Toronto and this data is for CBLT channel 9 DVB-T antenna.
> Windows shows everything ok.
> A little bit info on the stick to help others.
> It has 4 main chips on the board, em2874b, which has 2 I2C buses (guessed from em28xx source files).
> First bus is connected to Atmel's AT24C32D - 32kbit flash memory with I2C address 0xA0,
> second bus is connected to LGDT3305 with I2C address 0x1C, so, in order to communicate with LGDT3305
> flag for secondary bus must be set (EM2874_I2C_SECONDARY_BUS_SELECT),
> TDA18271HDC2 is connected through repeater of LGDT3305, so, disable_repeater field in 
> lgdt configuration must not be set, and lgdt gate control should be called before starting to talk 
> to TDA18271.
> 
> So, may someone provide info on PID 0000 steam packets?
> Or, perhaps I'm doing something wrong and should test it in different way?
> 
> Thank you.
> Dmitriy  --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

