Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42636 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbZELKaD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 06:30:03 -0400
Date: Tue, 12 May 2009 07:29:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: eduardo.valentin@nokia.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>
Subject: Re: [PATCH v2 1/7] v4l2: video device: Add V4L2_CTRL_CLASS_FMTX
 controls
Message-ID: <20090512072954.07e2b303@pedra.chehab.org>
In-Reply-To: <200905120826.40836.hverkuil@xs4all.nl>
References: <1242034309-13448-1-git-send-email-eduardo.valentin@nokia.com>
	<20090511231703.17087c01@pedra.chehab.org>
	<20090512061043.GB4639@esdhcp037198.research.nokia.com>
	<200905120826.40836.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 12 May 2009 08:26:40 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> The only reason why such a table might end up in the kernel is if there are 
> legal requirements forcing strict control on what is allowed for an FM 
> transmitter in each country, and in that case a similar mechanism as is 
> used for wifi should be used. I know we discussed this earlier, but I've 
> forgotten the exact name of that API.

If the usage of FM transmission is for very short range transmissions (for
example, to listen to a phone call inside your car stereo, or to listen to your
baby's room noises or to see him while you're in the kitchen), I doubt that
there are any legal requirements. Such usage is called by the regulatory
agencies as "secondary usage"[1]. The secondary usage for FM and for their
adjacent frequencies (the TV range) should allow such domestic usage [2]. In
general, the restriction for secondary usage is just the power level, to avoid
interferences with the primary usage. In general, the secondary usage for TV
and FM ranges are the same (and both ranges are adjacent).

On the other hand, for FM primary usage, e. g. a FM broadcaster, the
restriction is that you should transmit _ONLY_ at the authorized frequency, at
the specified maximum power (that may have a different max power during the day
or during the night), using strict shapes for frequency shift, and for
modulation levels. It also restricts the location of the FM station, and the
characteristics of the antenna beams. Such constraints require application,
infrastructure and hardware control that couldn't be done at kernel level.

So, I don't see how legal issues might affect this driver.

[1] Maybe the specific term may change from country to country, but the idea
remains the same, since this concept exists on ITU-R regulations.

[2] I'm not aware of any country that forbids the usage of FM/TV ranges for
domestic usage. Yet, if such country does exist, then the usage of this module
should be forbidden at such country, no matter what frequency you're
generating. So, again, it seems pointless to add such restriction in kernel.

Cheers,
Mauro
