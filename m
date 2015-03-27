Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35422 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbbC0IOC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 04:14:02 -0400
Received: by lbdc10 with SMTP id c10so4117372lbd.2
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2015 01:14:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <551437F6.6010202@xs4all.nl>
References: <CAPybu_1vgJ3t8GnKDk02SH0KkuEQH-Q-6Ym6gNX7a5H5OekAuA@mail.gmail.com>
 <551437F6.6010202@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 27 Mar 2015 09:13:40 +0100
Message-ID: <CAPybu_2YBZ2cMDnwOdh8Qf+eQK-B1RRhVt8FscX-9ujkpxWRvA@mail.gmail.com>
Subject: Re: RFC: New format V4L2_PIX_FMT_Y16_BE ?
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On Thu, Mar 26, 2015 at 5:46 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Yes, but you might want to wait 1-2 weeks: I'm going to make a patch
> that moves the ENUMFMT description into the v4l2 core. So you want to be on
> top of that patch. I posted an RFC patch for that earlier (last week I
> think).

Absolutely no hurry.

My main worry is now this patch:

libv4lconvert: Fix support for Y16 pixel format
https://patchwork.linuxtv.org/patch/28989/

That fixes the implementation in v4lconvert. I introduced the original
bug and I don't want that anybody uses that library as a reference of
how the format should be.



Thanks!!



-- 
Ricardo Ribalda
