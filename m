Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:48861 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab0DEPrK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Apr 2010 11:47:10 -0400
Received: by gxk9 with SMTP id 9so3030123gxk.8
        for <linux-media@vger.kernel.org>; Mon, 05 Apr 2010 08:47:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1270436282.12543.18.camel@palomino.walls.org>
References: <201004041741.51869.hverkuil@xs4all.nl>
	 <1270436282.12543.18.camel@palomino.walls.org>
Date: Mon, 5 Apr 2010 11:47:09 -0400
Message-ID: <y2i829197381004050847p430f9f29me0289c2cb3c80995@mail.gmail.com>
Subject: Re: RFC: new V4L control framework
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Apr 4, 2010 at 10:58 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> I think I have 2 cases where that is undesriable:
>
> 1. cx18 volume control: av_core subdev has a volume control (which the
> bridge driver currently reports as it's volume control) and the cs5435
> subdev has a volume control.
>
> I'd really need them *both* to be controllable by the user.  I'd also
> like them to appear as a single (bridge driver) volume control to the
> user - as that is what a user would expect.

For what it's worth, I've got a similar problem I am going to need to
deal with.  I'm working on a hardware design which has a volume
control built into the audio processor, as well as a separate i2c
controllable volume control (a cs3308).

So I am indeed *very* interested in seeing the best approach for
dealing with this issue.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
