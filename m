Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39043 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab2ADFuS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 00:50:18 -0500
Received: by vbbfc26 with SMTP id fc26so13096504vbb.19
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2012 21:50:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EFEFA08.805@gmail.com>
References: <CAHG8p1Ao8UDuCytunFjvGZ1Ugd_xVU9cf_iXv6YjcRD41aMYtw@mail.gmail.com>
	<20111230213301.GA3677@valkosipuli.localdomain>
	<CAHG8p1ACi7CGFEBVaSr5G1cUMqtH8wX2mRY6n1yKF8TqgJ0oYw@mail.gmail.com>
	<20111231113529.GC3677@valkosipuli.localdomain>
	<4EFEFA08.805@gmail.com>
Date: Wed, 4 Jan 2012 13:50:17 +0800
Message-ID: <CAHG8p1AjoV1gBhQGFm0rEYSkHrpG+XtQB7kYXc8x5nuqjW4Z4g@mail.gmail.com>
Subject: Re: v4l: how to get blanking clock count?
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> I the case of your bridge, that may not be possible, but that's the only one
>> I've heard of so I think it's definitely a special case. In that case the
>> sensor driver can't be allowed to change the blanking periods while
>> streaming is ongoing.
>
> I agree, it's just a matter of adding proper logic at the sensor driver.
> However it might be a bit tricky, the bridge would have to validate blanking
> values before actually enabling streaming.
>
Yes, this value doesn't affect the result image. The hardware only
raises a error interrupt to signify that a horizontal tracking
overflow has
occurred, that means the programmed number of samples did not match up
with the actual number of samples counted between assertions of
HSYNC(I can only set active samples now).
