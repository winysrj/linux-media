Return-path: <mchehab@pedra>
Received: from ist.d-labs.de ([213.239.218.44]:47837 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab1DDTfI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Apr 2011 15:35:08 -0400
Date: Mon, 4 Apr 2011 21:34:27 +0200
From: Florian Mickler <florian@mickler.org>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, oliver@neukum.org,
	linux-kernel@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [media] dib0700: get rid of on-stack dma buffers
Message-ID: <20110404213427.28d69419@schatten.dmk.lab>
In-Reply-To: <alpine.LRH.2.00.1104040940000.31158@pub1.ifh.de>
References: <1301851423-21969-1-git-send-email-florian@mickler.org>
	<alpine.LRH.2.00.1104040940000.31158@pub1.ifh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 4 Apr 2011 09:42:04 +0200 (CEST)
Patrick Boettcher <pboettcher@kernellabs.com> wrote:

> Hi Florian,
> 

> For this one we implemented an alternative. See here:
> 
> http://git.linuxtv.org/pb/media_tree.git?a=commit;h=16b54de2d8b46e48c5c8bdf9b350eac04e8f6b46
> 
> which I pushed, but obviously forgot to send the pull-request.
> 

OK, I just looked over it. What about dib0700_rc_query_old_firmware,
that would also need to be fixed. 

I don't have an overview over the media framework, so I wonder what
arbitrates concurrent access to the buffer? Functions which are only
called from the initialization and probe routines are probably properly
arbitrated by the driver core. But I would expect (perhaps
that is me being naive) stuff like dib0700_change_protocol to need some
sort of mutex ? 

It seems to be called from some /sys/class/*/ file while for example
legacy_dvb_usb_read_remote_control, which calls dib0700_rc_query_old_firmware, is 
described as being a polling function, i.e. periodically executed...
or the streaming_ctrl function, that looks like it is executed at
times...  

Thanks,
Flo


p.s.: 
can you add yourself to the
MAINTAINERS file please? 
