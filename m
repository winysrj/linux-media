Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47445 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab2IZWaw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 18:30:52 -0400
Received: by wibhr7 with SMTP id hr7so1299426wib.1
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 15:30:51 -0700 (PDT)
Message-ID: <50638219.7020105@gmail.com>
Date: Thu, 27 Sep 2012 00:30:49 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>, remi@remlab.net,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [RFC] Timestamps and V4L2
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <20120922202814.GA4891@minime.bse> <505F57A4.3040409@gmail.com> <32114057.tIVjSTYujk@avalon>
In-Reply-To: <32114057.tIVjSTYujk@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 09/25/2012 02:35 AM, Laurent Pinchart wrote:
> Does the clock type need to be selectable for mem-to-mem devices ? Do device-
> specific timestamps make sense there ?

I'd like to clarify one thing here, i.e. if we select device-specific
timestamps how should the v4l2_buffer::timestamp field behave ?

Are these two things exclusive ? Or should v4l2_buffer::timestamp be 
valid even if device-specific timestamps are enabled ?

With regards to your question, I think device-specific timestamps make
sense for mem-to-mem devices. Maybe not for the very simple ones, that
process buffers 1-to-1, but codecs may need it. I was told the Exynos/
S5P Multi Format Codec device has some register the timestamps could
be read from, but it's currently not used by the s5p-mfc driver. Kamil
might provide more details on that.

I guess if capture and output devices can have their timestamping clocks
selectable it should be also possible for mem-to-mem devices.

--

Regards,
Sylwester
