Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:55126 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab1AJOFh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 09:05:37 -0500
Message-ID: <4D2B122E.3050803@linuxtv.org>
Date: Mon, 10 Jan 2011 15:05:34 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Oliver Endriss <o.endriss@gmx.de>
CC: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH 07/16] ngene: CXD2099AR Common Interface driver
References: <1294652184-12843-1-git-send-email-o.endriss@gmx.de> <1294652184-12843-8-git-send-email-o.endriss@gmx.de>
In-Reply-To: <1294652184-12843-8-git-send-email-o.endriss@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 01/10/2011 10:36 AM, Oliver Endriss wrote:
> From: Ralph Metzler <rjkm@metzlerbros.de>
> 
> Driver for the Common Interface Controller CXD2099AR.
> Supports the CI of the cineS2 DVB-S2.
> 
> For now, data is passed through '/dev/dvb/adapterX/sec0':
> - Encrypted data must be written to 'sec0'.
> - Decrypted data can be read from 'sec0'.
> - Setup the CAM using device 'ca0'.

Nack. In DVB API terms, "sec" stands for satellite equipment control,
and if I remember correctly, sec0 already existed in the first versions
of the API and that's why its leftovers can be abused by this driver.

The interfaces for writing data are dvr0 and demux0. If they don't fit
for decryption of recorded data, then they should be extended.

For decryption of live data, no new user interface needs to be created.

Regards,
Andreas
