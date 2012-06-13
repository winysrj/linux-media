Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:32633 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab2FMNxm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 09:53:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: extend v4l2_mbus_framefmt
Date: Wed, 13 Jun 2012 15:53:21 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>,
	uclinux-dist-devel@blackfin.uclinux.org
References: <CAHG8p1AW6577=oGPo3o8S0LgF2p8_cfmLLnvYbikk7kEaYdxzw@mail.gmail.com> <201206111033.47369.hverkuil@xs4all.nl> <CAHG8p1Dc_FtTh4DOZO92VbJikk43CgVhQidXPjNwN3VcHrtKvA@mail.gmail.com>
In-Reply-To: <CAHG8p1Dc_FtTh4DOZO92VbJikk43CgVhQidXPjNwN3VcHrtKvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206131553.23161.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 13 June 2012 07:31:37 Scott Jiang wrote:
> Hi Hans,
> 
> > I would expect that the combination of v4l2_mbus_framefmt + v4l2_dv_timings
> > gives you the information you need.
> >
> I can solve this problem in HD, but how about SD? Add a fake
> dv_timings ops in SD decoder driver?
> 

No, you add g/s_std instead. SD timings are set through that API. It is not so
much that you give explicit timings, but that you give the SD standard. And from
that you can derive the timings (i.e., one for 60 Hz formats, and one for 50 Hz
formats).

SD is handled through the ENUM/G/S/QUERYSTD API (userspace) and s/g/querystd (in
the subdevice API).

HD is handled through the ENUM/G/S/QUERY_DV_TIMINGS API and enum/g/s/query_dv_timings
subdevice API.

I've updated my cisco.git tree today and SD support is added to adv7842.c. Most
of the other changes that I wanted to do are in there as well. It is not yet
prime time, but it is getting close.

Regards,

	Hans
