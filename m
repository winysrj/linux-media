Return-path: <linux-media-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:36129
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZIXVcn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2009 17:32:43 -0400
Date: Thu, 24 Sep 2009 23:32:24 +0200
From: spam@systol-ng.god.lan
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] Zolid Hybrid PCI card add AGC control
Message-ID: <20090924213223.GA13550@systol-ng.god.lan>
Reply-To: Henk.Vergonet@gmail.com
References: <20090922210915.GD8661@systol-ng.god.lan> <37219a840909241155h1b809877mf7ae1807e34a2f87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37219a840909241155h1b809877mf7ae1807e34a2f87@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 24, 2009 at 02:55:42PM -0400, Michael Krufky wrote:
> 
> Henk,
> 
> This is *very* interesting...  Have you taken a scope to the board to
> measure AGC interference?   This seems to be *very* similar to
> Hauppauge's design for the HVR1120 and HVR1150 boards, which are
> actually *not* based on any reference design.

Yes a scope would be nice!

No I traced some pins with a ohm meter. After some gpio togling and measuring
the voltage on the hc4052 I found out the s0 and s1 pins.

For the dvb reception I looked at the BER (bit-error-rate) using tzap it
seemed to drop from 8000 or so to 4000 when using gpio21 = 1.
Analog reception is a no-go in this mode it only works when gpio21 = 0.

FM radio seemed a (little) bit better when using fm_rfn = 0 and the
1.5Mhz antialiasing filter enabled. But its all somewhat subjective I
must admit.

> 
> I have no problems with this patch, but I would be interested to hear
> that you can prove it is actually needed by using a scope.  If you
> don't have a scope, I understand....  but this certainly peaks my
> interest.
> 
> Do you have schematics of that board?

Nope, I will update the wiki with a few drawings that I have been able
to figure out.

Thanks for the support!

regards,
henk

BTW Currently the card is for sale in the Aldi for 28.99 euros if
someone is interested and in the proximity of Holland ;).

> 
