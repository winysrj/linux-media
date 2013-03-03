Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52091 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab3CCABi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Mar 2013 19:01:38 -0500
Received: from mailout-de.gmx.net ([10.1.76.10]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0Ly8b5-1UqrkI3NJN-015dvs for
 <linux-media@vger.kernel.org>; Sun, 03 Mar 2013 01:01:35 +0100
Date: Sun, 3 Mar 2013 01:01:34 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: jandegr1@dommel.be
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: HAUPPAUGE HVR-930C analog tv feasible ??
Message-ID: <20130303000134.GA21166@minime.bse>
References: <20130225120117.atcsi16l8jokos80@webmail.dommel.be>
 <20130225083345.2d83d554@redhat.com>
 <20130301212854.93kflfbg4jc0kksk@webmail.dommel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130301212854.93kflfbg4jc0kksk@webmail.dommel.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, Mar 01, 2013 at 09:28:54PM +0100, jandegr1@dommel.be wrote:
> Citeren Mauro Carvalho Chehab <mchehab@redhat.com>:
> >nor I succeeded
> >to get any avf4910b datasheet or development kit.

and now that Trident went bankrupt chances are slim that one of us ever
will.

> Any other suggestions/comments or anyone wanting to work with me on this ?

I have an AF9035 based stick with that chip and once sniffed the
communication from cold state until about the 40th frame. At that
point what appears to be sound frames in the iso packets still just
contains 0x00 bytes at about 192kB/s. VBI data is captured as well
raw and sliced but I don't know if the slicing is done by the AF9035.
I beat the old log into a shape similar to your log's and uploaded it:
http://pastebin.com/mfN1TXrG
AF9035 firmare and iso data have been omitted.

As you can see, the driver uploads some kind of firmware to the upper
address space of the AVF4910B. According to
http://driveragent.com/c/archive/562634f6/image/2-1-0/Yuan-MC270B-TV-Tuner-Driver,-IdeaCentre-B310
the chip contains a 8051 microcontroller.

Devin Heitmueller once told me that he wrote a driver for the AVF4910A
as part of their Osprey 240e/450e driver. He also said that it was
completely different to the AVF4910B. I can no longer find it online,
but my local copy tells me that the AVF4910A also uses demod register
0x50 for I2S configuration and register 0x20 for standard selection.
Maybe they are not so different after all.

  Daniel
