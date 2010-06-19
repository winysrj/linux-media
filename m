Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1305 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab0FSUKk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jun 2010 16:10:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Report of Helsinki mini-summit
Date: Sat, 19 Jun 2010 22:12:56 +0200
Cc: linux-media@vger.kernel.org
References: <201006191611.25271.hverkuil@xs4all.nl> <Pine.LNX.4.64.1006192130120.16798@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1006192130120.16798@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006192212.56514.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 19 June 2010 21:37:22 Guennadi Liakhovetski wrote:
> On Sat, 19 Jun 2010, Hans Verkuil wrote:
> 
> > 6) TO DO list regarding V4L2 core framework including the new control framework.
> > 
> > - Control Framework: done, just needs a pull request. Some discussions on how
> >   to handle 'auto-foo' and 'foo' controls (e.g. autogain/gain). Can be fixed
> >   later.
> > - Replace all s/g/try_fmt subdev ops with s/g/try_busfmt. Mostly done, want to
> 
> s/g/try_mbus_fmt were probably meant, as well as enum_mbus_fmt for that 
> matter;)

Yes, indeed. You mentioned that during the summit and I forgot to correct it
in my notes. Well, as I said, all mistakes are mine :-)

Regards,

	Hans

> 
> >   finish this for 2.6.36.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
