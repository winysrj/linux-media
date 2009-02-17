Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:9990 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813AbZBQWUa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 17:20:30 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: Minimum kernel version supported by v4l-dvb
Date: Tue, 17 Feb 2009 23:24:03 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
References: <20090217142327.1678c1a6@hyperion.delvare>
In-Reply-To: <20090217142327.1678c1a6@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902172324.03697.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean,

On Tuesday 17 February 2009 14:23:27 Jean Delvare wrote:
> Hi Mauro,
>
> These days I am helping Hans Verkuil convert the last users of the
> legacy i2c device driver binding model to the new, standard binding
> model. It turns out to be a very complex task because the v4l-dvb
> repository is supposed to still support kernels as old as 2.6.16, while
> the initial support for the new i2c binding model was added in kernel
> 2.6.22 (and even that is somewhat different from what is upstream now.)
> This forces us to add quirks all around the place, which will surely
> result in bugs because the code becomes hard to read, understand and
> maintain.
>
> In fact, without this need for backwards compatibility, I would
> probably have been able to convert most of the drivers myself, without
> Hans' help, and this would already be all done. But as things stand
> today, he has to do most of the work, and our progress is slow.
>
> So I would like you to consider changing the minimum kernel version
> supported by the v4l-dvb repository from 2.6.16 to at least 2.6.22.
> Ideal for us would even be 2.6.26, but I would understand that this is
> too recent for you. Kernel 2.6.22 is one year and a half old, I
> honestly doubt that people fighting to get their brand new TV adapter
> to work are using anything older. As a matter of fact, kernel 2.6.22 is
> what openSUSE 10.3 has, and this is the oldest openSUSE product that is
> still maintained.

Dropping pre-2.6.22 support may not be an issue for desktop systems that 
probably already run newer kernel versions. It might be a different story for 
embedded systems, as many users are stuck with old vendor-provided kernels.

I have no idea how many users we're talking about, but I know that the UVC 
driver is used with a 2.6.10 kernel on an embedded system by at least one 
person.

> I understand and respect your will to let a large range of users build
> the v4l-dvb repository, but at some point the cost for developers seems
> to be too high, so there's a balance to be found between users and
> developers. At the moment the balance isn't right IMHO.

I won't vote against setting the minimum kernel version to 2.6.22, but we 
should at least be aware that embedded users, even if they're not very vocal, 
are lurking out there in the darkness of vendor-provided kernels.

Cheers,

Laurent Pinchart

