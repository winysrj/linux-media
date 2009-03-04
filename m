Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:45251 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbZCDClS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2009 21:41:18 -0500
Message-ID: <49ADEA4A.4080800@linuxtv.org>
Date: Wed, 04 Mar 2009 03:41:14 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: Re: V4L/DVB: dvb_dmx_swfilter_section_copy_dump() assignment or addition?
References: <49ADAB54.5020004@gmail.com>
In-Reply-To: <49ADAB54.5020004@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Roel,

Roel Kluin wrote:
> vi drivers/media/dvb/dvb-core/dvb_demux.c +214
> 
> and note:
> 
> static int dvb_dmx_swfilter_section_copy_dump(struct dvb_demux_feed *feed,
>                                               const u8 *buf, u8 len)
> {
> 	...
>         if (sec->tsfeedp + len > DMX_MAX_SECFEED_SIZE) {
> 		...
>                 len = DMX_MAX_SECFEED_SIZE - sec->tsfeedp;
> 		    ^------------shouldn't this be '+='?

No. Read it like this: If there isn't enough space for 'len' bytes,
then reduce 'len' to the number of bytes available.

>         }
> 
> 	if (len <= 0)
>                 return 0;
> 
> Also note: len cannot be less than 0 since it's an u8.

Yes. This function seems to be overcautious in other places, too.
These two checks can probably get removed:

        if (sec->tsfeedp >= DMX_MAX_SECFEED_SIZE)
                return 0;

        if (limit > DMX_MAX_SECFEED_SIZE)
                return -1;      /* internal error should never happen */

Regards,
Andreas
