Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:19407 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbeBRUz4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Feb 2018 15:55:56 -0500
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23177.59478.243278.702389@morden.metzler>
Date: Sun, 18 Feb 2018 21:55:50 +0100
To: "Jasmin J." <jasmin@anw.at>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net
Subject: Re: [PATCH V2 0/3] Add timers to en50221 protocol driver
In-Reply-To: <ef72a382-5d30-526c-ae09-ed50d9d4790d@anw.at>
References: <1513862559-19725-1-git-send-email-jasmin@anw.at>
        <ef72a382-5d30-526c-ae09-ed50d9d4790d@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jasmin,

Jasmin J. writes:
 > Hi!
 > 
 > Please hold on in merging this series, because I have to investigate a hint
 > I got related to the buffer size handshake of the protocol driver:
 >   https://www.linuxtv.org/pipermail/linux-dvb/2007-July/019116.html
 > 
 > BR,
 >    Jasmin


So, there seem to be two bugs:

1. The SW bit is cleared too early during the whole buffer size negotiation.

This should be fixed.


2. IRQEN = CMDREG_DAIE = 0x80 is always set in the command register.

DAIE and FRIE were introduced as recommendation in Cenelec R06-001:1998 and are a requirement for
CI+.

They could cause problems if the IRQ line goes high and the interrupt is enabled but not handled.
They should not cause a problem if the host ignores the interrupt or if the CAM does not support it,
but one never knows with some CAMs ...

So, they should probably only be used if both the host and module say they support it.
R06 does not mention it but CI+ also requires a CIS entry to be present in modules 
supporting this feature.



Regards,
Ralph
