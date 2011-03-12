Return-path: <mchehab@pedra>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:54544 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab1CLOFM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 09:05:12 -0500
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19835.32151.116648.554824@morden.metzler>
Date: Sat, 12 Mar 2011 15:05:11 +0100
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Martin Vidovic <xtronom@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
In-Reply-To: <4D7B7524.2050108@linuxtv.org>
References: <alpine.LNX.2.00.1103101608030.9782@hp8540w.home>
	<4D7A452C.7020700@linuxtv.org>
	<4D7A97BB.4020704@gmail.com>
	<4D7B7524.2050108@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Andreas Oberritter writes:
 > On 03/11/2011 10:44 PM, Martin Vidovic wrote:
 > > Andreas Oberritter wrote:
 > >> It's rather unintuitive that some CAMs appear as ca0, while others as
 > >> cam0.
 > >>   
 > > Ngene CI appears as both ca0 and cam0 (or sec0). The ca0 node is used
 > > as usual, to setup the CAM. The cam0 (or sec0) node is used to read/write
 > > transport stream. To me it  looks like an extension of the current API.
 > 
 > I see. This raises another problem. How to find out, which ca device
 > cam0 relates to, in case there are more ca devices than cam devices?
 > 

They should be in different adapterX directories. 
Even on the cards where you can connect up to 4 dual frontends or CAM adapters
I currently use one adapter directory for every frontend and CAM.

If you want to "save" adapters one could put them in the same
directory and caX would belong to camX. 
More ca than cam devices could only occur on cards with mixed old and
new style hardware. I am not aware of such cards.

I think there are cards with dual frontend and two CAM adapters where
normally data from frontendX is passed through caX (they are in the same adapter
directory) but the paths can also be switched. I do not now how this is
handled.


Regards,
Ralph

