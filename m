Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:21878 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751780AbeBSAYH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Feb 2018 19:24:07 -0500
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23178.6434.506346.934156@morden.metzler>
Date: Mon, 19 Feb 2018 01:24:02 +0100
To: "Jasmin J." <jasmin@anw.at>
Cc: Ralph Metzler <rjkm@metzlerbros.de>, linux-media@vger.kernel.org,
        mchehab@s-opensource.com, d.scheller@gmx.net
Subject: Re: [PATCH V2 0/3] Add timers to en50221 protocol driver
In-Reply-To: <2c7a385f-2d98-a30e-6714-ab6aa86288d2@anw.at>
References: <1513862559-19725-1-git-send-email-jasmin@anw.at>
        <ef72a382-5d30-526c-ae09-ed50d9d4790d@anw.at>
        <23177.59478.243278.702389@morden.metzler>
        <2c7a385f-2d98-a30e-6714-ab6aa86288d2@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jasmin,

Jasmin J. writes:
 > Hallo Ralph!
 > 
 > > 1. The SW bit is cleared too early during the whole buffer size negotiation.
 > > This should be fixed.
 > I will look into this when I have time again. Probably end of next week.
 > 
 > > 2. IRQEN = CMDREG_DAIE = 0x80 is always set in the command register.
 > > So, they should probably only be used if both the host and module say they
 > > support it.
 > How can we know that in the driver?
 > I haven't seen an API for this.

The flags parameter of dvb_ca_en50221_init() allow these values:

#define DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE       1
#define DVB_CA_EN50221_FLAG_IRQ_FR              2
#define DVB_CA_EN50221_FLAG_IRQ_DA              4

but only DVB_CA_EN50221_FLAG_IRQ_CAMCHANGE seems to be used in dvb_ca_en50221.c.
Support for this was seemingly planned but never implemented.

Annex G.2 of
http://www.ci-plus.com/data/ci-plus_specification_v1.3.pdf
contains details about how support is announced in the CIS.


 > There is the flag "da_irq_supported", which might be used to set the IRQEN
 > bit it the bit is set.

Sure, e.g. to store the result from the CIS parsing.
The current use is not much help. It is set if an interrupt occured with DA bit set, which is
a little too late.


 > Any suggestions how to proceed with item 2?

Check the CIS for support by the CAM and ca->flags for support by the host.
If both support it, set CMDREG_FRIE and/or CMDREG_DAIE in command reg.


Regards,
Ralph
