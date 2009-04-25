Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:23082 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZDYNVQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Apr 2009 09:21:16 -0400
Received: by yx-out-2324.google.com with SMTP id 3so933309yxj.1
        for <linux-media@vger.kernel.org>; Sat, 25 Apr 2009 06:21:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49F2DCBD.20105@freenet.de>
References: <49F2DCBD.20105@freenet.de>
Date: Sat, 25 Apr 2009 09:21:15 -0400
Message-ID: <412bdbff0904250621m7f43735eu730fac87bd121b57@mail.gmail.com>
Subject: Re: Installation of Cinergy HTC USB Driver in Ubuntu Jaunty
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Peter Hoyland <Peter.Hoyland@t-online.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 25, 2009 at 5:49 AM, Peter Hoyland
<Peter.Hoyland@t-online.de> wrote:
> Hallo
>
> I have a Terratec Cinergy HTC USB XS Stick and want to use this with
> Me-TV in order to record and view TV via Cable (Germany).
>
> My research shows that a driver is in development under this link
> http://mcentral.de/wiki/index.php5?title=Terratec_HTC_XS&oldid=2804.
>
> This link offers no instructions to installation, I was hoping that it
> would be included In Ubuntu Jaunty, alas to no avail. I am hoping that
> you can help me further or at least tell me in which Kernel release this
> driver will be integrated.
>
> Thanks in advance
> Peter Hoyland

This device is supported in Markus's closed source driver only.  It
will not be merged into the mainline kernel, and there are no plans at
this time for anyone else to reverse engineer the Micronas demod and
write an open source driver.

My advice: return it and buy something supported.

Micronas actively screwed the Linux community when they had me do all
the integration work for their device and then refused to let me
release it.  I wouldn't buy any of their products if you care about
open source.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
