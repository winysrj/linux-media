Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59583 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728226AbeHML63 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 07:58:29 -0400
Date: Mon, 13 Aug 2018 10:17:04 +0100
From: Sean Young <sean@mess.org>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        linux-media@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v3 2/2] media: rc: remove ir-rx51 in favour of generic
 pwm-ir-tx
Message-ID: <20180813091703.oeybhwonpoiet5ac@gofer.mess.org>
References: <20180713122230.19278-1-sean@mess.org>
 <20180713122230.19278-2-sean@mess.org>
 <f44eb6ba-c94f-a397-1577-da647b880ac1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f44eb6ba-c94f-a397-1577-da647b880ac1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 13, 2018 at 05:38:25PM +0300, Ivaylo Dimitrov wrote:
> Hi,
> 
> On 13.07.2018 15:22, Sean Young wrote:
> > The ir-rx51 is a pwm-based TX driver specific to the N900. This can be
> > handled entirely by the generic pwm-ir-tx driver.
> > 
> > Note that the suspend code in the ir-rx51 driver is unnecessary, since
> > during transmit, the process is not in interruptable sleep. The process
> > is not put to sleep until the transmit completes.
> > 
> > Compile tested only.
> > 
> 
> I would like to see this being tested on a real HW, however I am on a
> holiday for the next week so won't be able to test till I am back.
> 
> @Pali - do you have n900 with fremantle, upstream kernel and pierogi to test
> pwm-ir-tx on it?

It would be nice to have this verified on real hardware, if possible. If
not, I would like to merge this anyway. If there are any problems we can
always later patch any problem in pwm-ir-tx for the n900.


Sean
