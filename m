Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab2EPVPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 17:15:13 -0400
Received: by pbbrp8 with SMTP id rp8so1624824pbb.19
        for <linux-media@vger.kernel.org>; Wed, 16 May 2012 14:15:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120516151253.24d12245@lwn.net>
References: <20120515194331.77C519D401E@zog.reactivated.net>
	<20120516151253.24d12245@lwn.net>
Date: Wed, 16 May 2012 15:15:12 -0600
Message-ID: <CAMLZHHTb+wgRiefVrA2rq0GCUPiBj4jm=kU2QGq1JGq+=6yCuA@mail.gmail.com>
Subject: Re: [PATCH] mmp-camera: specify XO-1.75 clock speed
From: Daniel Drake <dsd@laptop.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 16, 2012 at 3:12 PM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Tue, 15 May 2012 20:43:31 +0100 (BST)
> Daniel Drake <dsd@laptop.org> wrote:
>
>> Jon, is it OK to assume that XO-1.75 is the only mmp-camera user?
>
> It's the only one I know of at the moment, certainly.
>
> Even so, I think it would be a lot better to put this parameter into the
> mmp_camera_platform_data structure instead of wiring it into the driver
> source; it could then be set in olpc-xo-1-75.c with the other relevant
> parameters.  I won't oppose the inclusion of this patch, but...any chance
> it could be done that way?

I'll look into it. Please put this patch on pause for now.

Thanks
Daniel
