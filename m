Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1730 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab1AJLIq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 06:08:46 -0500
Message-ID: <7be530a8d14997437511b57e7504785a.squirrel@webmail.xs4all.nl>
In-Reply-To: <AANLkTi=9jZPTin=0TCrfPeiO9koE69pQLkqFjHOhLMZA@mail.gmail.com>
References: <1294484508-14820-1-git-send-email-hverkuil@xs4all.nl>
    <20110109095540.21fcd9e4@bike.lwn.net>
    <AANLkTi=9jZPTin=0TCrfPeiO9koE69pQLkqFjHOhLMZA@mail.gmail.com>
Date: Mon, 10 Jan 2011 12:08:42 +0100
Subject: Re: [RFCv2 PATCH 0/5] Use control framework in cafe_ccic and
 s_config removal
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Daniel Drake" <dsd@laptop.org>
Cc: "Jonathan Corbet" <corbet@lwn.net>, linux-media@vger.kernel.org,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Hi,
>
>>> Another reason why s_config is a bad idea.
>
> Thanks a lot for working on this. I had a quick look and don't have
> any objections.
>
>>> This has been extensively tested on my humble OLPC laptop (and it took
>>> me 4-5
>>> hours just to get the damn thing up and running with these drivers).
>
> In future, come into irc.oftc.net #olpc-devel and talk to me (dsd) or
> cjb (Chris Ball), we'll get you up and running in less time!

If you have a link to some instructions on how to get the latest kernel up
and running for olpc, then that would be handy :-)

> I'll test the via-camera patch unless Jon beats me too it, but won't
> be immediately. If you are ever interested in doing more in-depth work
> on that driver, please drop me a mail and we will send you a XO-1.5.

It's just for ongoing V4L2 maintenance (such as this sort of work).

>
> Also, perhaps you are interested in working on this bug, which is
> probably reproducible with cafe_ccic too:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg23841.html

I'll see if I can reproduce this with cafe_ccic. Weird that I haven't seen
this before. The code looks fishy: my first guess is that sd->flags should
be put in a local variable before it is being tested.

I must have missed that bug report the first time around.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

