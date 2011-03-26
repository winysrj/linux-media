Return-path: <mchehab@pedra>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:48877 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab1CZUU4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2011 16:20:56 -0400
Message-ID: <4D8E4AA2.7070408@kolumbus.fi>
Date: Sat, 26 Mar 2011 22:20:50 +0200
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Subject: Pending dvb_dmx_swfilter(_204)() patch tested enough
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi Mauro.

Following patch has been tested enough since last Summer 2010:

"Avoid unnecessary data copying inside dvb_dmx_swfilter_204() function"
https://patchwork.kernel.org/patch/118147/
It modifies both dvb_dmx_swfilter_204() and dvb_dmx_swfilter()  functions.

I Myself tested dvb_dmx_swfilter_204() with terrestrial DVB-C, using 204 sized packets.
Some other Mantis users have satellite receiver equipment, using 188 sized packets, thus
using dvb_dmx_swfilter().

The patch has been in yaVDR/testing branch and used there.

So both functions are tested enough during one half year period.
I was asked by a person this week that if the patch could go forward.

Regards,
Marko Ristola

