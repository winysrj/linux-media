Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:64066 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbZJWMxq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 08:53:46 -0400
Date: Fri, 23 Oct 2009 14:53:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: Details about DVB frontend API
Message-ID: <20091023145348.33f0b1d8@hyperion.delvare>
In-Reply-To: <20091023051025.597c05f4@caramujo.chehab.org>
References: <20091022211330.6e84c6e7@hyperion.delvare>
	<20091023051025.597c05f4@caramujo.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 23 Oct 2009 05:10:25 +0900, Mauro Carvalho Chehab wrote:
> Em Thu, 22 Oct 2009 21:13:30 +0200
> Jean Delvare <khali@linux-fr.org> escreveu:
> 
> > Hi folks,
> > 
> > I am looking for details regarding the DVB frontend API. I've read
> > linux-dvb-api-1.0.0.pdf, it roughly explains what the FE_READ_BER,
> > FE_READ_SNR, FE_READ_SIGNAL_STRENGTH and FE_READ_UNCORRECTED_BLOCKS
> > commands return, however it does not give any information about how the
> > returned values should be interpreted (or, seen from the other end, how
> > the frontend kernel drivers should encode these values.) If there
> > documentation available that would explain this?
> > 
> > For example, the signal strength. All I know so far is that this is a
> > 16-bit value. But then what? Do greater values represent stronger
> > signal or weaker signal? Are 0x0000 and 0xffff special values? Is the
> > returned value meaningful even when FE_HAS_SIGNAL is 0? When
> > FE_HAS_LOCK is 0? Is the scale linear, or do some values have
> > well-defined meanings, or is it arbitrary and each driver can have its
> > own scale? What are the typical use cases by user-space application for
> > this value?
> > 
> > That's the kind of details I'd like to know, not only for the signal
> > strength, but also for the SNR, BER and UB. Without this information,
> > it seems a little difficult to have consistent frontend drivers.
> 
> We all want to know about that ;)
> 
> Seriously, the lack of a description of the meaning of the ranges for those
> read values were already widely discussed at LMML and at the legacy dvb ML.
> We should return this discussion again and decide what would be the better
> way to describe those values.
> 
> My suggestion is that someone summarize the proposals we had and give some time
> for people vote. After that, we just commit the most voted one, and commit the
> patches for it. A pending question that should also be discussed is what we will
> do with those dvb devices where we simply don't know what scale it uses. There
> are several of them.
> 
> Btw, the new official documentation is the media infrastructure docbook that
> can be found at the Kernel and at:
> 	http://linuxtv.org/downloads/v4l-dvb-apis
> 
> This covers both DVB and V4L API's.

Ah, thank you. So I was reading old documentation. Too bad that
googling for "linux dvb api" points to the old documents. Maybe the new
document needs some more keywords so that search engines index it
properly?

Also, on http://linuxtv.org/docs.php, I can see links to
http://linuxtv.org/downloads/linux-dvb-api-1.0.0.pdf for DVB and
http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html
for V4L... but no link to http://linuxtv.org/downloads/v4l-dvb-apis .
Shouldn't the links be updated?

-- 
Jean Delvare
