Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2183 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbZHIITp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Aug 2009 04:19:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: wk <handygewinnspiel@gmx.de>
Subject: Re: [patch review 6/6] radio-mr800: redesign radio->users counter
Date: Sun, 9 Aug 2009 10:19:10 +0200
Cc: Alexey Klimov <klimov.linux@gmail.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
References: <1249753576.15160.251.camel@tux.localhost> <208cbae30908081208o5a048fb0qdd6c356b0c6d3eb9@mail.gmail.com> <4A7DDD1C.1030906@gmx.de>
In-Reply-To: <4A7DDD1C.1030906@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908091019.10222.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 08 August 2009 22:16:28 wk wrote:
> Alexey Klimov schrieb:
> > On Sat, Aug 8, 2009 at 10:01 PM, Trent Piepho<xyzzy@speakeasy.org> wrote:
> >   
> >> On Sat, 8 Aug 2009, Alexey Klimov wrote:
> >>     
> >>> Redesign radio->users counter. Don't allow more that 5 users on radio in
> >>>       
> >> Why?
> >>     
> >
> > Well, v4l2 specs says that multiple opens are optional. Honestly, i
> > think that five userspace applications open /dev/radio is enough. Btw,
> > if too many userspace applications opened radio that means that
> > something wrong happened in userspace. And driver can handle such
> > situation by disallowing new open calls(returning EBUSY). I can't
> > imagine user that runs more than five mplayers or gnomeradios, or
> > kradios and so on.
> >
> > Am i totally wrong here?
> >
> > Thanks.
> >   
> "I can't imagine.." Funny answer, reminds at the 640kB limit of old 
> computers.. :)
> But if there's no real technical restriction, the driver should not 
> restrict access a device at all.

Exactly. It's an artificial restriction that serves no purpose. Also
remember that apps can open a radio device just to do e.g. a QUERYCAP
or something like that. It does not necessarily has to be an mplayer
or gnomeradio.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
