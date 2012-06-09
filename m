Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55763 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab2FIPxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jun 2012 11:53:55 -0400
Received: by obbtb18 with SMTP id tb18so4050393obb.19
        for <linux-media@vger.kernel.org>; Sat, 09 Jun 2012 08:53:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACSP8SiyzYHZJNxuNoVOqPCj-FwWy3dNMxhoixrwKfQt+2g7jg@mail.gmail.com>
References: <4fbf6893.a709d80a.4f7b.0e0eSMTPIN_ADDED@mx.google.com>
	<CACSP8SgSi+v70+-r1wR1hM0rDzmJK0g20i0fxRePLPuTXqrxuA@mail.gmail.com>
	<CAO8GWq=UYWTuJ=V6Luh4z49=og2X2wrHzVNYvbK7Tnw2zgzNeA@mail.gmail.com>
	<CACSP8Sgog0cDtxG+JsWQ=aYyiXtEr-N7+xPPRsAjwt3LAYC+uw@mail.gmail.com>
	<CAO8GWqnVN3tVp2chzsYKjhfzoupxsWwUT_LojzJ7kYWPRdZYJw@mail.gmail.com>
	<CACSP8SiVYiEg8BY9gvmbqiKNXEwEjHa+vxOvXpEgr+W-Wd5+rg@mail.gmail.com>
	<4fd09200.830ed80a.24f9.1a54SMTPIN_ADDED@mx.google.com>
	<CACSP8SgrB2YxsvUx6y-EomgJhupb3uVmF_hH0Sd-PG6G6G9Cfg@mail.gmail.com>
	<20120608214229.GH5761@phenom.ffwll.local>
	<CACSP8SiyzYHZJNxuNoVOqPCj-FwWy3dNMxhoixrwKfQt+2g7jg@mail.gmail.com>
Date: Sat, 9 Jun 2012 17:53:54 +0200
Message-ID: <CAKMK7uHwMo6DTNFeV4pTX7snb+mYkcyZS3W6KQAj7f2JsRPk=g@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC] Synchronizing access to buffers shared with
 dma-buf between drivers/devices
From: Daniel Vetter <daniel@ffwll.ch>
To: Erik Gilling <konkers@android.com>
Cc: Tom Cooksey <tom.cooksey@arm.com>, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 9, 2012 at 12:22 AM, Erik Gilling <konkers@android.com> wrote:
> The current linux graphics stack does not allow synchronization
> between the GPU and a camera/video decoder.  When we've seen people
> try to support this behind the scenes, they get it wrong and introduce
> bugs that can take weeks to track down.  As stated in the previous
> email, one of our goals is to centrally manage synchronization so that
> it's easer for people bringing up a platform to get it right.

I agree that letting everyone reinvent the wheel isn't the best idea
for cross-device sync - people will just get it wrong way too often.
I'm not convinced yet that doing it with explicit sync points/fences
and in userspace is the best solution. dri2/gem all use implicit sync
points managed by the kernel in a transparent fashion, so I'm leaning
towards such a sulotion for cross-device sync, too. Imo the big upside
of such an implicitly sync'ed approach is that it massively simplifies
cross-process protocols (i.e. for the display server).

So to foster understanding of the various requirements and use-cases,
could you elaborate on the pros and cons a bit and explain why you
think explicit sync points managed by the userspace display server is
the best approach for android?

Yours, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
