Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62662 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756236AbeATPCJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Jan 2018 10:02:09 -0500
Received: from minime.bse ([77.22.132.34]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0M8NBi-1eyPkr0Hha-00vuco for
 <linux-media@vger.kernel.org>; Sat, 20 Jan 2018 16:02:07 +0100
Date: Sat, 20 Jan 2018 16:02:05 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Florian Boor <florian.boor@kernelconcepts.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: MT9M131 on I.MX6DL CSI color issue
Message-ID: <20180120150204.GA17833@minime.bse>
References: <b704a2fb-efa1-a2f8-7af0-43d869c688eb@kernelconcepts.de>
 <20180112105840.75260abb@crub>
 <20180112110606.47499410@crub>
 <929ef892-467b-dfd1-8ae0-0190263be38a@kernelconcepts.de>
 <20180117103109.GA18072@minime.bse>
 <ff51f6e2-270d-c881-4445-8dadf5d7db6f@kernelconcepts.de>
 <20180118040308.GA21998@minime.bse>
 <4407aea6-4a7e-a637-40ae-3b25f43b81e5@kernelconcepts.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4407aea6-4a7e-a637-40ae-3b25f43b81e5@kernelconcepts.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Florian,

On Thu, Jan 18, 2018 at 05:31:43PM +0100, Florian Boor wrote:
> > But that does not explain the wraparounds. Can you rule out that the
> > data lines have been connected in the wrong order?
> 
> According to the schematics and camera documentation I have the order of the
> data lines is correct. I checked one more time... but I'm not sure if the
> configuration of the parallel camera input is perfectly right.
> 
> The hardware uses CSI0 data lines 12 to 19 and so I used the configuration
> from the SabreLite board:

The VM-009 has 10 data lines. Do you use a board designed by Phytec?
If not, did you connect the lower or the upper 8 data lines to the i.MX6?
Using the upper 8 data lines is correct.

I'm asking because the raw frames I asked for off list* contain only odd
bytes except for some null bytes. And for all components they exceed the
standard value range (Y 16-235, Cb/Cr 16-240).

Have you ever tried to capture images in one of the RGB formats?

Best regards,

  Daniel

*)
http://www.kernelconcepts.de/~florian/frame.raw
http://www.kernelconcepts.de/~florian/frame2.raw
