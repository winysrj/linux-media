Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42243 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaBPRED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Feb 2014 12:04:03 -0500
Received: by mail-qa0-f46.google.com with SMTP id k15so7389559qaq.33
        for <linux-media@vger.kernel.org>; Sun, 16 Feb 2014 09:04:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1757001.8sWyckB0oo@radagast>
References: <CAKv9HNYxY0isLt+uZvDZJJ=PX0SF93RsFeS6PsRMMk5gqtu8kQ@mail.gmail.com>
	<2457095.pZsX4lrjVF@radagast>
	<CAKv9HNbh39=QjyHggge3w-ke658ndCnPP+0EqPL9iUFrf3+imQ@mail.gmail.com>
	<1757001.8sWyckB0oo@radagast>
Date: Sun, 16 Feb 2014 19:04:01 +0200
Message-ID: <CAKv9HNZ2E00RPno0PX5=V-4gy8kxxP7zgW-NH729Ye1g+Myz=w@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] ir-rc5-sz: Add ir encoding support
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12 February 2014 01:39, James Hogan <james.hogan@imgtec.com> wrote:
> On Tuesday 11 February 2014 20:14:19 Antti Seppälä wrote:
>> Are you working on the wakeup protocol selector sysfs interface?
>
> I gave it a try yesterday, but it's a bit of a work in progress at the moment.
> It's also a bit more effort for img-ir to work properly with it, so I'd
> probably just limit the allowed wakeup protocols to the enabled normal
> protocol at first in img-ir.
>
> Here's what I have (hopefully kmail won't corrupt it), feel free to take and
> improve/fix it. I'm not keen on the invasiveness of the
> allowed_protos/enabled_protocols change (which isn't complete), but it
> should probably be abstracted at some point anyway.
>

Hi James.

In general the approach here looks good. At least I couldn't figure
any easy way to be less intrusive towards drivers/decoders and still
support wakeup filters.

I've just sent a new version of my rc-5-sz encoder patches for review.

I was thinking that once you are finished with the wakeup protocol
sysfs interface maybe you could combine my patchset and your changes
into a single "review patch" series and send it to the list? That
would keep the entire wakeup filter series easier to track.

Br,
-Antti
