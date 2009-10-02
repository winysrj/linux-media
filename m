Return-path: <linux-media-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:43776
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217AbZJBJNO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2009 05:13:14 -0400
Date: Fri, 2 Oct 2009 11:12:55 +0200
From: spam@systol-ng.god.lan
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: Henk.Vergonet@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] Zolid Hybrid PCI card add AGC control
Message-ID: <20091002091255.GA29221@systol-ng.god.lan>
Reply-To: Henk.Vergonet@gmail.com
References: <20090922210915.GD8661@systol-ng.god.lan> <37219a840909241155h1b809877mf7ae1807e34a2f87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37219a840909241155h1b809877mf7ae1807e34a2f87@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 24, 2009 at 02:55:42PM -0400, Michael Krufky wrote:
> On Tue, Sep 22, 2009 at 5:09 PM,  <spam@systol-ng.god.lan> wrote:
> >
> > Switches IF AGC control via GPIO 21 of the saa7134. Improves DTV reception and
> > FM radio reception.
> >
> > Signed-off-by: Henk.Vergonet@gmail.com
> 
> Reviewed-by: Michael Krufky <mkrufky@kernellabs.com>
> 
> Henk,
> 
> This is *very* interesting...  Have you taken a scope to the board to
> measure AGC interference?   This seems to be *very* similar to
> Hauppauge's design for the HVR1120 and HVR1150 boards, which are
> actually *not* based on any reference design.
> 
> I have no problems with this patch, but I would be interested to hear
> that you can prove it is actually needed by using a scope.  If you
> don't have a scope, I understand....  but this certainly peaks my
> interest.
> 
> Do you have schematics of that board?
> 
> Regards,
> 
> Mike Krufky
> 

One note: I have tested the tda18271 signedness fixes in the debug
repository. This is a big improvement in reception.

Based on the latest testing with all the fixes I would say that
switching the AGC line via gpio is not needed and leaving it at 0 gives
the best results.
(This is purely based on SNR and BER readings from tzap)

So I would recomend: leaving config at zero.

 static struct tda18271_config zolid_tda18271_config = {
 	.std_map = &zolid_tda18271_std_map,
 	.gate    = TDA18271_GATE_ANALOG,
-	.config  = 3,
+//	.config  = 3,
	.output_opt = TDA18271_OUTPUT_LT_OFF,
 };

Regards,
Henk
