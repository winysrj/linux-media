Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:38421 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718Ab3KEWaE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 17:30:04 -0500
Received: by mail-lb0-f177.google.com with SMTP id u14so6932716lbd.8
        for <linux-media@vger.kernel.org>; Tue, 05 Nov 2013 14:30:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKnK8-Q51UOqGc1T2jfJENm5pOWAutytKLcDkhgkM3yWjAtJ2w@mail.gmail.com>
References: <1383666180-9773-1-git-send-email-knightrider@are.ma>
	<CAOcJUbxCjEWk47MkJP15QBAuGd3ePYS3ZRMduqdMCrVT362-8Q@mail.gmail.com>
	<CAKnK8-Q51UOqGc1T2jfJENm5pOWAutytKLcDkhgkM3yWjAtJ2w@mail.gmail.com>
Date: Wed, 6 Nov 2013 07:30:01 +0900
Message-ID: <CAKnK8-Rva-m-tVN3n16Q3O0D5bhYrNsFm4+1f8=xvp92aMa-uA@mail.gmail.com>
Subject: Re: [PATCH] Full DVB driver package for Earthsoft PT3 (ISDB-S/T) cards
From: =?UTF-8?B?44G744Gh?= <knightrider@are.ma>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Michael Krufky <mkrufky <at> linuxtv.org> writes:

> As the DVB maintainer, I am telling you that I won't merge this as a
> monolithic driver.  The standard is to separate the driver into
> modules where possible, unless there is a valid reason for doing
> otherwise.
>
> I understand that you used the PT1 driver as a reference, but we're
> trying to enforce a standard of codingstyle within the kernel.  I
> recommend looking at the other DVB drivers as well.

OK Sir. Any good / latest examples?

> Please shorten it to something more along the lines of:
>
> Support for Earthsoft PT3 PCI-Express cards.
>
> Say Y or M to enable support for this device.

Roger

> > FYI, there is another version of PT3 driver, named pt3_drv.ko, that
> > utilize character devices as the I/O. I'd rather use pt3_dvb.ko to
> > distinguish.
>
> we're not interested in multiple drivers for the same hardware.  Only
> one will be merged into the kernel, if any at all, and users need not
> think about the names of these drivers.  One of the beauties of
> merging a driver into the kernel is that users gain automatic support
> for the hardware without having to think or care about the name of the
> driver.

pt3_drv.ko is a public domain (old-fashioned) chardev driver for PT3,
and does not conform to standard DVB platform.
It doesn't seem to be merged into the mainstreem kernel tree.

> > Maybe I'd like to change the dirname:
> > drivers/media/pci/pt3_dvb => drivers/media/pci/pt3
>
> not a bad idea

> >> every source file and header file should include GPLv2 license headers.
> >
> > Roger: not very crucial though...
>
> entirely crucial if you're looking to merge into the kernel.  ...or
> did we misunderstand your request?

I meant: not a big task... is the following enough?

/*
 * DVB driver for Earthsoft PT3 PCI-E ISDB-S/T card
 *
 * Copyright (C) 2013 xxxx xxxx <xxxxxx@zng.info>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

> >>> +#define PT3_QM_INIT_DUMMY_RESET 0x0c
> >>
> >> it's nicer when these macros are defined in one place, but its not a
> >> requirement.  It's OK to leave it here if you really want to, but I
> >> suggest instead to create a _reg.h file containing all register
> >> #defines
> >
> > Will consider...
