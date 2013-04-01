Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:34327 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759152Ab3DAKHk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Apr 2013 06:07:40 -0400
Message-ID: <51595CBA.8050602@schinagl.nl>
Date: Mon, 01 Apr 2013 12:08:58 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Ralph Metzler <rjkm@metzlerbros.de>
CC: linux-media@vger.kernel.org
Subject: Re: ddbridge v0.8
References: <CAAKANDV1QWHeuA3XG7+HK2Fc8rLBpkVWGWcJ0Bdc_3A_yAEVLA@mail.gmail.com> <511C0385.2060308@schinagl.nl> <20766.15478.535523.4665@morden.metzler>
In-Reply-To: <20766.15478.535523.4665@morden.metzler>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Ralph,

On 02/15/13 14:47, Ralph Metzler wrote:
> Oliver Schinagl writes:
>   > On 02/11/13 23:20, Martin Vidovic wrote:
>   > > Hi,
>   > >
>   > > Is there any plan to include ddbridge driver version 0.8 in mainline kernel
>   > > (currently it's 0.5). I really see no reason it's in the vacuum like now
>   > > for almost a year. No sign of pushing it into mainline. Why is that so?
>   > > It's a good driver.
>   > You should ask Ralph Metzler (added to CC) as he wrote the driver I
>   > think or atleast maintains it.
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
What is the current status of this? I saw that the DVB-C modulator is on 
sale now.

I guess octopus-net isn't announced yet and will be something like the 
current octopus, but as a streamer instead of receiver?
>
> Regards,
> Ralph
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

