Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:43265 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726Ab3BOOY5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 09:24:57 -0500
Message-ID: <511E4503.3030300@schinagl.nl>
Date: Fri, 15 Feb 2013 15:24:03 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Ralph Metzler <rjkm@metzlerbros.de>
CC: Martin Vidovic <xtronom@gmail.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>, o.endriss@gmx.de
Subject: Re: ddbridge v0.8
References: <CAAKANDV1QWHeuA3XG7+HK2Fc8rLBpkVWGWcJ0Bdc_3A_yAEVLA@mail.gmail.com> <511C0385.2060308@schinagl.nl> <20766.15478.535523.4665@morden.metzler>
In-Reply-To: <20766.15478.535523.4665@morden.metzler>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15-02-13 14:47, Ralph Metzler wrote:
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
But do you have any problems with it being mainlined? If someone would 
take your newest version and work with Mauro/Oliver to mainline it?

What would be your ETA? weeks? months? end of the year?
>
> Regards,
> Ralph
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

