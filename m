Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:42259 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907Ab1CZTjy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2011 15:39:54 -0400
Subject: Re: Analog input for Hauppauge express-card HVR-1400
From: Andy Walls <awalls@md.metrocast.net>
To: Emil Meier <emil276me@yahoo.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <601699.85761.qm@web29505.mail.ird.yahoo.com>
References: <601699.85761.qm@web29505.mail.ird.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Mar 2011 15:40:32 -0400
Message-ID: <1301168432.2338.19.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-03-22 at 19:57 +0000, Emil Meier wrote:
> In the attached files I have added some code for the analog part of a HVR-1400 
> card. (The patch is taken from a patch for HVR1800..)
> Until now only the composite video input is functional. 
> The s-video input captures only the b&w part of the video.
> The patch in cx25840-core.c was needed to get PAL support for the video input. 
> If the line
> cx25840_write(client, 0x2, 0x76);
> is needed by other cards,

You patches have a problem:

Your first patch modifies a card entry in the cx23885 driver, but your
second patch changes the cx231xx_initialize() function in
cx25840-core.c. 

http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/cx25840/cx25840-core.c;h=35796e0352475b6536bfd47315107e418e6716fa;hb=refs/heads/staging/for_v2.6.39#l638

The second patch should have no effect on the operation of a CX2388[578]
based card.

Regards,
Andy



>  the skipping should depend on the card-name... but I 
> don't know how I can get the card-model in this module...
> 
> Maybe this helps someone else in using the analog part of this card.
> 
> Emil
> 
> 
>       


