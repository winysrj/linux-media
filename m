Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:62764 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752689AbeAREDM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 23:03:12 -0500
Received: from minime.bse ([77.22.132.34]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LwGDy-1etHdY1oHW-017zlW for
 <linux-media@vger.kernel.org>; Thu, 18 Jan 2018 05:03:10 +0100
Date: Thu, 18 Jan 2018 05:03:08 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Florian Boor <florian.boor@kernelconcepts.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: MT9M131 on I.MX6DL CSI color issue
Message-ID: <20180118040308.GA21998@minime.bse>
References: <b704a2fb-efa1-a2f8-7af0-43d869c688eb@kernelconcepts.de>
 <20180112105840.75260abb@crub>
 <20180112110606.47499410@crub>
 <929ef892-467b-dfd1-8ae0-0190263be38a@kernelconcepts.de>
 <20180117103109.GA18072@minime.bse>
 <ff51f6e2-270d-c881-4445-8dadf5d7db6f@kernelconcepts.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff51f6e2-270d-c881-4445-8dadf5d7db6f@kernelconcepts.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 17, 2018 at 01:58:42PM +0100, Florian Boor wrote:
> http://www.kernelconcepts.de/~florian/screenshot.png
> 
> Its not really obvious for me what is wrong but these wraparounds Philipp
> mentioned are really nice to see within the bars.

The vertical lines tell me that videoparse format=5 is wrong. Since the
U and V planes are so similar in the screenshot, it is most likely
format 4 or 19.

But that does not explain the wraparounds. Can you rule out that the
data lines have been connected in the wrong order?

Best regards,

  Daniel
