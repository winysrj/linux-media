Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43253 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2ADJ7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 04:59:46 -0500
Received: by vbbfc26 with SMTP id fc26so13194359vbb.19
        for <linux-media@vger.kernel.org>; Wed, 04 Jan 2012 01:59:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120104093909.GA9323@valkosipuli.localdomain>
References: <CAHG8p1Ao8UDuCytunFjvGZ1Ugd_xVU9cf_iXv6YjcRD41aMYtw@mail.gmail.com>
	<20111230213301.GA3677@valkosipuli.localdomain>
	<CAHG8p1ACi7CGFEBVaSr5G1cUMqtH8wX2mRY6n1yKF8TqgJ0oYw@mail.gmail.com>
	<20111231113529.GC3677@valkosipuli.localdomain>
	<4EFEFA08.805@gmail.com>
	<CAHG8p1AjoV1gBhQGFm0rEYSkHrpG+XtQB7kYXc8x5nuqjW4Z4g@mail.gmail.com>
	<20120104082742.GL3677@valkosipuli.localdomain>
	<CAHG8p1DxPJthH8JOH9AEmLyCwas4O0f16ytk3FeknaPLnP_-2g@mail.gmail.com>
	<20120104093909.GA9323@valkosipuli.localdomain>
Date: Wed, 4 Jan 2012 17:59:45 +0800
Message-ID: <CAHG8p1BmtK5dydPZxsT7hoE1JoSFsN1MsXA0qaeVQBzpCeb0VQ@mail.gmail.com>
Subject: Re: v4l: how to get blanking clock count?
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> If I disable this interrupt, other errors like fifo underflow are ignored.
>> Perhaps I can add a parameter in platform data to let user decide to
>> register this interrupt or not.
>
> I think a more generic solution would be preferrable. If that causes
> ignoring real errors, that's of course bad. I  wonder if there would be a
> way around that.
>
> Is there a publicly available datasheet for the bridge that I could take a
> look at?
>
Yes, http://www.analog.com/en/processors-dsp/blackfin/adsp-bf548/processors/technical-documentation/index.html.
There is a hardware reference manual for bf54x, bridge is eppi.
