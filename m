Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:57073 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752306AbdKAMrl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 08:47:41 -0400
Date: Wed, 1 Nov 2017 12:47:39 +0000
From: Sean Young <sean@mess.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: linux-media@vger.kernel.org,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>
Subject: Re: [PATCH] media: rc: remove ir-rx51 in favour of generic pwm-ir-tx
Message-ID: <20171101124738.5ddbsp5gmkehikw6@gofer.mess.org>
References: <20171101115533.14418-1-sean@mess.org>
 <20171101115821.anem4aatlruks2in@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171101115821.anem4aatlruks2in@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 01, 2017 at 12:58:21PM +0100, Pali Rohár wrote:
> On Wednesday 01 November 2017 11:55:33 Sean Young wrote:
> > The ir-rx51 is a pwm-based TX driver specific to the n900. This can be
> > handled entirely by the generic pwm-ir-tx driver.
> > 
> > Note that the suspend code in the ir-rx51 driver is unnecessary, since
> > during transmit, the current process is not in interruptable sleep. The
> > process is not put to sleep until the transmit completes.
> 
> Hello, have you tested this patch that IR transmitter is still working
> fine on the real Nokia N900 device?

No, I have not. My n900 died many years ago. I was hoping someone could
this for me please.

I should have called this out more explicitly.

If anyone could test please, thank you very much!

Regards,

Sean
