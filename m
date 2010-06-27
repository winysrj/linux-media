Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760Ab0F0KNO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 06:13:14 -0400
Message-ID: <4C27242B.9040609@redhat.com>
Date: Sun, 27 Jun 2010 07:12:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Correct way to do s_ctrl ioctl taking into account subdev 	framework?
References: <AANLkTim9TfITmvy7nEuSVJnCxRwCkpbmgRc2FIIIWHGF@mail.gmail.com>	<201006262051.52754.hverkuil@xs4all.nl>	<AANLkTikPKv6iCQmV14JSiR61AUMswsOoTB7i-eSHAwH4@mail.gmail.com>	<4C26AAAC.1020803@redhat.com> <AANLkTimAXMupX9hYyfiTwZdi4d9a1v_N5sdz8k6b_Xhs@mail.gmail.com>
In-Reply-To: <AANLkTimAXMupX9hYyfiTwZdi4d9a1v_N5sdz8k6b_Xhs@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-06-2010 00:26, Devin Heitmueller escreveu:
> On Sat, Jun 26, 2010 at 9:34 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> would do the trick. Yet, the application is broken, as it is considering a positive
>> return as an error. A positive code should never be considered as an error. So, we
>> need to fix v4l2-ctl as well (ok, returning 1 is wrong as well, as this is a non-v4l2
>> compliance in this case).
> 
> A strict interpretation of the spec would read that returning zero is
> success, -1 is an well-formed error condition, and *ANYTHING* else is
> a violation of the spec and an application used for testing compliance
> should complain very loudly (which is exactly what it does).
> 
> In effect, the only patch I would consider valid for v4l2-ctl would be
> one that makes the error even more LOUD than it already is.

It should output it as an API violation, not as a failure on setting the value.
That's said, I think that a few ioctl calls used to return positive values under
certain special conditions. Not sure if this is a non-compliance or if the 
API allows it.

Cheers,
Mauro
