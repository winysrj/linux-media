Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:42385 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbZKEQCS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 11:02:18 -0500
Received: by gxk26 with SMTP id 26so159446gxk.1
        for <linux-media@vger.kernel.org>; Thu, 05 Nov 2009 08:02:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911051522.10007.hverkuil@xs4all.nl>
References: <200909100913.09065.hverkuil@xs4all.nl>
	 <Pine.LNX.4.64.0910270854300.4828@axis700.grange>
	 <829197380910270656s18d0ce9n87f452888b6983ba@mail.gmail.com>
	 <200911051522.10007.hverkuil@xs4all.nl>
Date: Thu, 5 Nov 2009 11:02:22 -0500
Message-ID: <829197380911050802w501bb060xe763ccc6583e9eba@mail.gmail.com>
Subject: Re: RFCv2: Media controller proposal
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Cohen David Abraham <david.cohen@nokia.com>,
	"Koskipaa Antti (Nokia-D/Helsinki)" <antti.koskipaa@nokia.com>,
	Zutshi Vimarsh <vimarsh.zutshi@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 5, 2009 at 9:22 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Does anyone know if alsa has similar routing problems as we have for SoCs?
> Currently the MC can be used to discover and change the routing of video streams,
> but it would be very easy indeed to include audio streams (or any type of
> stream for that matter) as well.
>
> Regards,
>
>        Hans

As far as I have seen, generally speaking the audio rerouting is done
automatically when changing video sources (and doesn't get done by
ALSA itself but rather in the code for the decoder or bridge).  In
theory people might want to be able to play with the routing through
some sort of ALSA controls, but I don't think anyone is doing that
now.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
