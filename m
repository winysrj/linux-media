Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33319 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297Ab3KFNOp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 08:14:45 -0500
Received: by mail-pa0-f50.google.com with SMTP id fb1so10414469pad.23
        for <linux-media@vger.kernel.org>; Wed, 06 Nov 2013 05:14:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKnK8-Rva-m-tVN3n16Q3O0D5bhYrNsFm4+1f8=xvp92aMa-uA@mail.gmail.com>
References: <1383666180-9773-1-git-send-email-knightrider@are.ma>
	<CAOcJUbxCjEWk47MkJP15QBAuGd3ePYS3ZRMduqdMCrVT362-8Q@mail.gmail.com>
	<CAKnK8-Q51UOqGc1T2jfJENm5pOWAutytKLcDkhgkM3yWjAtJ2w@mail.gmail.com>
	<CAKnK8-Rva-m-tVN3n16Q3O0D5bhYrNsFm4+1f8=xvp92aMa-uA@mail.gmail.com>
Date: Wed, 6 Nov 2013 08:14:45 -0500
Message-ID: <CAOcJUbx96JYHaqQd3BG-p3h1M9TXjvkvffnzURBgUrWoWOk9HQ@mail.gmail.com>
Subject: Re: [PATCH] Full DVB driver package for Earthsoft PT3 (ISDB-S/T) cards
From: Michael Krufky <mkrufky@linuxtv.org>
To: =?UTF-8?B?44G744Gh?= <knightrider@are.ma>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 5, 2013 at 5:30 PM, ほち <knightrider@are.ma> wrote:
> Michael Krufky <mkrufky <at> linuxtv.org> writes:
>
>> As the DVB maintainer, I am telling you that I won't merge this as a
>> monolithic driver.  The standard is to separate the driver into
>> modules where possible, unless there is a valid reason for doing
>> otherwise.
>>
>> I understand that you used the PT1 driver as a reference, but we're
>> trying to enforce a standard of codingstyle within the kernel.  I
>> recommend looking at the other DVB drivers as well.
>
> OK Sir. Any good / latest examples?

There are plenty of DVB drivers to look at under drivers/media/  ...
you may notice that there are v4l and dvb device drivers together
under this hierarchy.  It's easy to tell which drivers support DVB
when you look at the source.

I could name a few specific ones, but i'd really recommend for you to
take a look at a bunch of them.  No single driver should be considered
a 'prefect example' as they are all under constant maintenance.

Also, many of these drivers are for devices that support both v4l and
DVB interfaces.  One example is the cx23885 driver.  Still, please try
to look over the entire media tree, as that would give a better idea
of how the drivers are structured.

Best regards,

Mike Krufky
