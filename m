Return-path: <mchehab@pedra>
Received: from ist.d-labs.de ([213.239.218.44]:54821 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757444Ab1CRV2Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2011 17:28:25 -0400
Date: Fri, 18 Mar 2011 22:28:19 +0100
From: Florian Mickler <florian@mickler.org>
To: Antti Palosaari <crope@iki.fi>
Cc: mchehab@infradead.org, oliver@neukum.org, jwjstone@fastmail.fm,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 06/16] [media] ce6230: get rid of on-stack dma buffer
Message-ID: <20110318222819.3ab2424a@schatten.dmk.lab>
In-Reply-To: <4D8389FB.6040707@iki.fi>
References: <20110315093632.5fc9fb77@schatten.dmk.lab>
	<1300178655-24832-1-git-send-email-florian@mickler.org>
	<1300178655-24832-6-git-send-email-florian@mickler.org>
	<4D8389FB.6040707@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 18 Mar 2011 18:36:11 +0200
Antti Palosaari <crope@iki.fi> wrote:

> On 03/15/2011 10:43 AM, Florian Mickler wrote:
> > usb_control_msg initiates (and waits for completion of) a dma transfer using
> > the supplied buffer. That buffer thus has to be seperately allocated on
> > the heap.
> >
> > In lib/dma_debug.c the function check_for_stack even warns about it:
> > 	WARNING: at lib/dma-debug.c:866 check_for_stack
> >
> > Note: This change is tested to compile only, as I don't have the hardware.
> >
> > Signed-off-by: Florian Mickler<florian@mickler.org>
> 
> Acked-by: Antti Palosaari <crope@iki.fi>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
> Tested-by: Antti Palosaari <crope@iki.fi>
> 
> 
> t. Antti
> 

Thanks for your feedback!

Regards,
Flo
