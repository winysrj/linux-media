Return-path: <linux-media-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:43598 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbZC3Rbx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 13:31:53 -0400
Message-ID: <49D10206.5060105@rtr.ca>
Date: Mon, 30 Mar 2009 13:31:50 -0400
From: Mark Lord <lkml@rtr.ca>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Michael Krufky <mkrufky@linuxtv.org>, linux-media@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: bttv ir patch from Mark Lord
References: <200903301835.55023.hverkuil@xs4all.nl> <49D0FBCE.8050408@rtr.ca> <49D0FC14.6010109@rtr.ca> <200903301911.40249.hverkuil@xs4all.nl>
In-Reply-To: <200903301911.40249.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
>
> It's best to wait a bit. Jean Delvare is working on this ir-kbd-i2c driver 
> right now and when he's finished it should be much easier to add this. Most 
> importantly you can add this new i2c address to the cx18 driver rather than 
> add it to the probe_bttv list, which is rather overloaded anyway.
> 
> He should be finished within 1-3 weeks I guess. Probably sooner rather than 
> later. Just watch the linux-media list for it.
..

Thanks.  I'll just watch for it arriving upstream in 2.6.31 (?) then,
if the current ir-kbd-i2c patch doesn't end up in 2.6.30 already.

Good idea on the cleanup in there, too.  It was looking a bit tattered
around the edges, and my patch doesn't really help much with that aspect. :)

Cheers
