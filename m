Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752243AbeFFRN2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 13:13:28 -0400
Date: Wed, 6 Jun 2018 14:13:19 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Tomasz Figa <tfiga@chromium.org>, mchehab@s-opensource.com,
        Hans Verkuil <hverkuil@xs4all.nl>, pali.rohar@gmail.com,
        sre@kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC, libv4l]: Make libv4l2 usable on devices with complex
 pipeline
Message-ID: <20180606141312.3c2913e2@coco.lan>
In-Reply-To: <20180606105116.GA4328@amd>
References: <c0fa64ac-4185-0e15-c938-0414e9f07c42@xs4all.nl>
        <20180319120043.GA20451@amd>
        <ac65858f-7bf3-4faf-6ebd-c898b6107791@xs4all.nl>
        <20180319095544.7e235a3e@vento.lan>
        <20180515200117.GA21673@amd>
        <20180515190314.2909e3be@vento.lan>
        <20180602210145.GB20439@amd>
        <CAAFQd5ACz1DNW07-vk6rCffC0aNcUG_9+YVNK9HmOTg0+-3yzg@mail.gmail.com>
        <20180606084612.GB18743@amd>
        <CAAFQd5CGKd=jP+h5b7HwSgd5HBoQFUX8Vd6pKLzzJFtCSukBLg@mail.gmail.com>
        <20180606105116.GA4328@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 6 Jun 2018 12:51:16 +0200
Pavel Machek <pavel@ucw.cz> escreveu:

> > > > The scenario that I could think of is:
> > > > - legacy app would call open(/dev/video?), which would be handled by
> > > > libv4l open hook (v4l2_open()?),  
> > >
> > > I don't think that kind of legacy apps is in use any more. I'd prefer
> > > not to deal with them.  
> > 
> > In another thread ("[ANN v2] Complex Camera Workshop - Tokyo - Jun,
> > 19"), Mauro has mentioned a number of those:
> > 
> > "open source ones (Camorama, Cheese, Xawtv, Firefox, Chromium, ...) and closed
> > source ones (Skype, Chrome, ...)"  
> 
> Thanks for thread pointer... I may be able to get in using hangouts.
> 
> Anyway, there's big difference between open("/dev/video0") and
> v4l2_open("/dev/video0"). I don't care about the first one, but yes we
> should be able to support the second one eventually.
> 
> And I don't think Mauro says apps like Camorama are of open() kind.

All open source apps we care use v4l2_open() & friends. the ones
that use just open() work via LD_PRELOAD. It is a hack, but it
was needed when libv4l was added (as there were lots of apps
to be touched). Also, we had problems on that time with closed
source app developers. I guess nowadays, among v4l-specific
apps, only closed source ones use just open().

Haven't check how browsers open cameras, though. A quick look at the
Fedora 60 dependencies, though, doesn't show libv4l:

	https://rpmfind.net/linux/RPM/fedora/devel/rawhide/x86_64/f/firefox-60.0.1-5.fc29.x86_64.html

It might be statically linking libv4l, or maybe they rely on something
else (like java/flash/...), but I guess it is more likely that they're
just using open() somehow. The same kind of issue may also be present
on other browsers and on java libraries.

Thanks,
Mauro
