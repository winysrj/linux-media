Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:38139 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab0HGLWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Aug 2010 07:22:42 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh03-2.mail.saunalahti.fi (Postfix) with SMTP id 09144EBFDE
	for <linux-media@vger.kernel.org>; Sat,  7 Aug 2010 14:22:41 +0300 (EEST)
Message-ID: <4C5D41FE.8070808@kolumbus.fi>
Date: Sat, 07 Aug 2010 14:22:38 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Marko Ristola <marko.ristola@kolumbus.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Avoid unnecessary data copying inside dvb_dmx_swfilter_204()
 function
References: <4C5D2BA1.60804@kolumbus.fi>
In-Reply-To: <4C5D2BA1.60804@kolumbus.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi

The old patch with broken spaces is https://patchwork.kernel.org/patch/108274/
The one with good patch and bad introduction is https://patchwork.kernel.org/patch/118147/

Regards,
Marko Ristola

07.08.2010 12:47, Marko Ristola wrote:
> 
> Hi.
> 
> This patch is like the original, but without mangled spaces.
> I found Documentation/email-clients.txt to be useful for tuning Thunderbird.
> 
> DVB-S2 users with high volume stream data are interested in trying this patch too.
> 
> Signed-off-by: Marko Ristola <marko.ristola@kolumbus.fi>
> 
[ snip ]

