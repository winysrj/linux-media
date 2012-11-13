Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:46122 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab2KMRHC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 12:07:02 -0500
Received: by mail-qa0-f53.google.com with SMTP id k31so2345510qat.19
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2012 09:07:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <k7tt38$aol$1@ger.gmane.org>
References: <k7tkcu$m6j$1@ger.gmane.org>
	<CAGoCfiwBJv04ffd+gDn1t+_3GPn+KeDdcaRQ+PbrqAjAsiMEHg@mail.gmail.com>
	<k7tt38$aol$1@ger.gmane.org>
Date: Tue, 13 Nov 2012 12:07:01 -0500
Message-ID: <CAGoCfiww92i7w9xuG199Pdv5EQbFButWxT=CHC9Wg2ypY+M1PA@mail.gmail.com>
Subject: Re: Color problem with MPX-885 card (cx23885)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Neuer User <auslands-kv@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 13, 2012 at 11:39 AM, Neuer User <auslands-kv@gmx.de> wrote:
> I had looked through the linux-media GIT tree for any commits that have
> "cx23885" in the description. The last ones I found were from mid 2011.

Yeah, the changes were actually made to the cx25840 driver, which is
used/shared by the cx23885.

> I can confirm that the biggest problem, the color problem, is fixed at
> least with kernel 3.5.7 (maybe earlier).

Ok, good.

> The minor ones (card not autodetected, and black border on the left
> side) can probably be dealt with, e.g. in postprocessing. Or is there a
> chance to fix these in the driver?

They can almost certainly be fixed in the driver (the black border is
a result of incorrect HSYNC configuration for PAL standards).  The
bigger issue though is finding someone willing to do the work.  If
this is for a commercial application, you may wish to reach out to
Steven Toth.  He did the original MPX support as a consulting project.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
