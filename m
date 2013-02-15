Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.unixsol.org ([193.110.159.2]:58165 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932333Ab3BOOkH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 09:40:07 -0500
Message-ID: <511E4797.5000306@unixsol.org>
Date: Fri, 15 Feb 2013 16:35:03 +0200
From: Georgi Chorbadzhiyski <gf@unixsol.org>
MIME-Version: 1.0
To: Ralph Metzler <rjkm@metzlerbros.de>
CC: Oliver Schinagl <oliver+list@schinagl.nl>,
	Martin Vidovic <xtronom@gmail.com>, linux-media@vger.kernel.org
Subject: Re: ddbridge v0.8
References: <CAAKANDV1QWHeuA3XG7+HK2Fc8rLBpkVWGWcJ0Bdc_3A_yAEVLA@mail.gmail.com> <511C0385.2060308@schinagl.nl> <20766.15478.535523.4665@morden.metzler>
In-Reply-To: <20766.15478.535523.4665@morden.metzler>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Around 02/15/2013 03:47 PM, Ralph Metzler scribbled:
> Oliver Schinagl writes:
>  > On 02/11/13 23:20, Martin Vidovic wrote:
>  > > Is there any plan to include ddbridge driver version 0.8 in mainline kernel
>  > > (currently it's 0.5). I really see no reason it's in the vacuum like now
>  > > for almost a year. No sign of pushing it into mainline. Why is that so?
>  > > It's a good driver.
>  > You should ask Ralph Metzler (added to CC) as he wrote the driver I 
>  > think or atleast maintains it.
> 
> I wrote the driver but I never submitted it to the kernel myself. I got frustrated
> with that process years ago. Oliver Endriss took care of it and necessary coding style
> adjustments etc. in the last few years. (Many thanks again!) 
> But now he also stopped to pass it into the kernel due to some complications
> with other changes upstream.
> 
> I usually distribute a package with own versions of dvb-core, frontend and 
> ddbridge drivers now. When the next major restructuring due to the DVB-C modulator
> card and the stand-alone hardware network streamer (octopus net) support is done, 
> I will make it publically available. The current driver is version 0.9.7.
> It should be up to kernel coding style and can be easily copied over into
> a current kernel. But I am not about to take it apart into little patches.

We have more than 30 cards that use ddbridge drivers and the fact that the driver
in mainline is out of date is big PITA.

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/
