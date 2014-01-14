Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:39641 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbaANMq6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jan 2014 07:46:58 -0500
Message-ID: <52D52F8D.4020806@schinagl.nl>
Date: Tue, 14 Jan 2014 13:37:33 +0100
From: Olliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Philip Yarra <philip.yarra@gmail.com>, linux-media@vger.kernel.org
CC: oliver@schinagl.nl
Subject: Re: Initial scan table for au-Melbourne-Selby
References: <52CBA1C3.3000105@gmail.com>
In-Reply-To: <52CBA1C3.3000105@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philip,

On 07-01-14 07:42, Philip Yarra wrote:
> Hi, please find attached a scan table for au-Melbourne-Selby. This file
> is very similar to the scan table file for au-Melbourne-Upwey (which I
> was able to use until quite recently). However the fec_hi value of "2/3"
> for SBS no longer works for me, and I need to use "AUTO" instead. I
> don't know if this change also affects the Upwey repeater.
>
> Details on the geographic locations of these repeaters can be found here:
> Upwey: http://www20.sbs.com.au/transmissions/index.php?pid=2&id=795
> Selby: http://www20.sbs.com.au/transmissions/index.php?pid=2&id=792
>
> Note that the Selby repeater actually covers the parts of Upwey which
> are not able to get signal from the Upwey repeater, due to hilly
> terrain. Although they use identical frequencies, the polarisation is
> different.
I think that makes sense to have the two transmitters seperated then.
>
> I assume AUTO allows the DVB tuner to choose one of the FEC types
> dynamically, though I don't know if this is supported by all tuners. If
> there's a way I can find out which actual fec_hi is in use, please let
> me know and I will supply it.
>
> I have provided a brief write-up at
> http://pyarra.blogspot.com.au/2014/01/mythtv-and-sbs-in-dandenong-ranges.html
> - please let me know if there is further information I can provide.
Next time use git send-mail ;)

>
> Regards,
> Philip.
Thanks, I've pushed it now.
Oliver
