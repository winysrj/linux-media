Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36671 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbcAWKpg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2016 05:45:36 -0500
Received: by mail-wm0-f43.google.com with SMTP id l65so12508588wmf.1
        for <linux-media@vger.kernel.org>; Sat, 23 Jan 2016 02:45:35 -0800 (PST)
Subject: Re: libv4l on OpenBSD
To: Ingo Feinerer <feinerer@logic.at>, linux-media@vger.kernel.org
References: <20160122191055.GA25166@blue.my.domain>
From: Gregor Jasny <gjasny@googlemail.com>
Message-ID: <56A359D2.7000000@googlemail.com>
Date: Sat, 23 Jan 2016 11:45:38 +0100
MIME-Version: 1.0
In-Reply-To: <20160122191055.GA25166@blue.my.domain>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 22/01/16 20:10, Ingo Feinerer wrote:
> in OpenBSD we recently updated our videoio.h (= videodev2.h in Linux)
> header and also imported libv4l in our ports tree
> (https://marc.info/?l=openbsd-ports-cvs&m=145218684026568&w=2).
> 
> However, we need a few patches to have it working. As there is already
> FreeBSD support in libv4l, I would like to ask you if it would be
> possible to add OpenBSD support as well (so that it works out of the
> box)? The diffs (on top of https://git.linuxtv.org/v4l-utils.git)
> towards this goal are as follows.

I will try to get out a new v4l-utils release soon and will have a look
at your patch afterwards. What I'd like to see in the BSDs is a working
V4L header (videodev2.h) that is a drop-in replacement for the Linux
one. That would help to get rid of all the #ifdef portions in the code.

Thanks,
Gregor
