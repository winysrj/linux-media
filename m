Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340Ab2CWOpw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 10:45:52 -0400
Message-ID: <4F6C8C94.4010408@redhat.com>
Date: Fri, 23 Mar 2012 11:45:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] em28xx-dvb: enable LNA for cxd2820r in DVB-T mode
References: <1331832829-4580-1-git-send-email-gennarone@gmail.com> <1331832829-4580-3-git-send-email-gennarone@gmail.com> <4F6C72A6.30908@iki.fi> <CACOeW9MNoRZOs5yruTSEqcj_576ih6cnpW-j0HzKCs0Qyy=P4w@mail.gmail.com>
In-Reply-To: <CACOeW9MNoRZOs5yruTSEqcj_576ih6cnpW-j0HzKCs0Qyy=P4w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-03-2012 11:30, Gianluca Gennari escreveu:
> 
> 
> On Fri, Mar 23, 2012 at 1:55 PM, Antti Palosaari <crope@iki.fi <mailto:crope@iki.fi>> wrote:
> 
>     As we speak earlier LNA support is not implemented at all as our API / framework. My personal opinion LNA should be always disabled by default since it still makes some noise. Current hard coded values are just selected what gives better signal for me and thus are not optimal nor correct. Anyhow, I would not like to change those as for some user it could cause problems. And if I would change those I will disable all :)
> 
>     So better to left as those are currently until API/DVB core is fixed to support LNA.
> 
>     regards
>     Antti
> 
> 
>  
> Hi Antti,
> my opinion is that, if we have to choose between LNA always ON or always OFF (until we have proper API support), the best option is always ON.

Just add an API for it. It is simple and clean: all you need to do is to add a new DVBv5 props.
Please don't forget to update the DocBook when doing that.

> 
> For sure, an amplifier adds some noise (so it makes SNR a little worse). On the other hand, it make signals stronger and every demodulator needs a minimum signal strength to lock the channel.
> 
> So LNA is helping weak signals with good SNR, while it's damaging strong signals with poor SNR. I believe the first category of signals is far more common (especially if you want to use USB devices with portable antennas).
> 
> A secondary reason to disable LNA could be to reduce power consumption, but i believe this embedded LNA devices consume just a few mA (but I don't have exact figures) so I don't see this as a major issue.
> 
> The cxd2820r itself is a power hog so I think LNA does not make a substantial difference on power consumption.
> 
> Best regards,
> Gianluca

