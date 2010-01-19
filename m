Return-path: <linux-media-owner@vger.kernel.org>
Received: from webmail.velocitynet.com.au ([203.17.154.21]:51555 "EHLO
	webmail2.velocitynet.com.au" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755611Ab0ASIv2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 03:51:28 -0500
MIME-Version: 1.0
Date: Tue, 19 Jan 2010 08:51:23 +0000
From: <paul10@planar.id.au>
To: "Igor M. Liplianin" <liplianin@me.by>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: DM1105: could not attach frontend 195d:1105
In-Reply-To: <8d15809584306ed08401d6b06dccfcaf@mail.velocitynet.com.au>
References: <3bf14d196e3bc8717d910d09a623f98e@mail.velocitynet.com.au> <fded4e7b5651846ee885157dff27bf5c@mail.velocitynet.com.au> <8d15809584306ed08401d6b06dccfcaf@mail.velocitynet.com.au>
Message-ID: <8f772b00c9ad2033899eeb1913ee42e0@mail.velocitynet.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Well, as I understood, GPIO15 drives reset for demod.
> dm1105 driver needs little patching.
> 
> 

Igor,

Not to hassle you, I'm sure you're very busy.  Is this something I could
undertake myself?  If so, which driver would you recommend I copy from - I
saw on the list that some drivers do their own GPIO management, and others
use a generic GPIO layer.  I presume we'd need to use the generic layer?

Also, from your explanation it sounds like we need to set GPIO 15 to true
before we attempt to attach.  Is that correct?  From my reading there are
two GPIO registers (8 bits each), so we'd be bit masking bit 7 in the
second GPIO register to 1, then sending that GPIO to the card?

Thanks for any tips,

Paul


