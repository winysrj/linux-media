Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43913 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2IWSkk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 14:40:40 -0400
Received: by bkcjk13 with SMTP id jk13so531154bkc.19
        for <linux-media@vger.kernel.org>; Sun, 23 Sep 2012 11:40:39 -0700 (PDT)
Message-ID: <505F57A4.3040409@gmail.com>
Date: Sun, 23 Sep 2012 20:40:36 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>, remi@remlab.net,
	laurent.pinchart@ideasonboard.com
Subject: Re: [RFC] Timestamps and V4L2
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <201209211133.24174.hverkuil@xs4all.nl> <505DB12F.1090600@iki.fi> <505DF194.9030007@gmail.com> <20120922202814.GA4891@minime.bse>
In-Reply-To: <20120922202814.GA4891@minime.bse>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/22/2012 10:28 PM, Daniel Glöckner wrote:
> On Sat, Sep 22, 2012 at 07:12:52PM +0200, Sylwester Nawrocki wrote:
>> If we ever need the clock selection API I would vote for an IOCTL.
>> The controls API is a bad choice for something such fundamental as
>> type of clock for buffer timestamping IMHO. Let's stop making the
>> controls API a dumping ground for almost everything in V4L2! ;)
> 
>> Perhaps VIDIOC_QUERYBUF and VIDIOC_DQBUF should be reporting
>> timestamps type only for the time they are being called. Not per buffer,
>> per device. And applications would be checking the flags any time they
>> want to find out what is the buffer timestamp type. Or every time if it
>> don't have full control over the device (S/G_PRIORITY).
> 
> I'm all for adding an IOCTL, but if we think about adding a
> VIDIOC_S_TIMESTAMP_TYPE in the future, we might as well add a
> VIDIOC_G_TIMESTAMP_TYPE right now. Old drivers will return ENOSYS,
> so the application knows it will have to guess the type (or take own
> timestamps).

Hmm, would it make sense to design a single ioctl that would allow
getting and setting the clock type, e.g. VIDIOC_CLOCK/TIMESTAMP_TYPE ?

> I can't imagine anything useful coming from an app that has to process
> timestamps that change their source every now and then and I seriously
> doubt anyone will go to such an extent that they check the timestamp
> type on every buffer. If they don't set their priority high enough to
> prevent others from changing the timestamp type, they also run the
> risk of someone else changing the image format. It should be enough to
> forbid changing the timestamp type while I/O is in progress, as it is
> done for VIDIOC_S_FMT.

I agree, but mem-to-mem devices can have multiple logically independent,
"concurrent" streams active. If the clock type is per device it might 
not be that straightforward...


Regards,
Sylwester
