Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36889 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1AZObq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 09:31:46 -0500
Received: by eye27 with SMTP id 27so464822eye.19
        for <linux-media@vger.kernel.org>; Wed, 26 Jan 2011 06:31:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D400727.3000205@redhat.com>
References: <4D3FDAAC.2020303@redhat.com>
	<4D3FE453.6080307@redhat.com>
	<613f734c5a59a342c587769455e939af.squirrel@webmail.xs4all.nl>
	<4D400727.3000205@redhat.com>
Date: Wed, 26 Jan 2011 09:31:44 -0500
Message-ID: <AANLkTim-OSvLCowCuRy3qvgAey8Ot=ofAo24drj86qFj@mail.gmail.com>
Subject: Re: What to do with videodev.h
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jan 26, 2011 at 6:36 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> We should touch the tools that we care of. Maybe Devin could change tvtime,
> we should remove V4L1 driver from xawtv3/xawtv4.

Yeah, I have some tvtime work planned, and dropping v4l1 was
definitely on the list.  I actually dropped the private versions of
videodev.h/videodev2.h from my repo, so I won't have much choice.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
