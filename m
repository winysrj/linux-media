Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52139 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2HNN5p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 09:57:45 -0400
Received: by yhmm54 with SMTP id m54so444293yhm.19
        for <linux-media@vger.kernel.org>; Tue, 14 Aug 2012 06:57:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50292351.4080600@bmat.es>
References: <5028CC8C.3060907@bmat.es>
	<CALzAhNXim6t=w-49+TmzKr5sGu6uwgisc6O3oqVkUShYpu+PJQ@mail.gmail.com>
	<50290BFF.6070503@bmat.es>
	<CALzAhNX_DZ4WqaKKRJq0GFrPPdXZMp8jW0n3Zq9jMG7YtXUO7w@mail.gmail.com>
	<50292351.4080600@bmat.es>
Date: Tue, 14 Aug 2012 09:57:44 -0400
Message-ID: <CALzAhNXpSNb2XYX+a0NV0QfFKOpPGXAQcdJ0kwGWOszh_JA5wg@mail.gmail.com>
Subject: Re: Question Hauppauge Nova-S-Plus.
From: Steven Toth <stoth@kernellabs.com>
To: mark@bmat.es
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> And regarding 2 hours, normally it's about 2 or 3 days before fails.
> Sometimes it's some hours later. Totally random. For example today I
> restarted this morning, and no failure for the moment on any of both
> transponders.
>
> The problem is really very strange.

Hmm. I don't know then.

Other Hauppauge commercial customers are using those cards 7x24 with
no problem, although I don't know with which kernel and or/driver
version.

My guess is that the the PCI reset which occurs during a reboot is
fixing or resolving some issue with either an internal CX23883 issue
(unlikely) or more likely, the tuner/demod/LNB power block becomes
unstable, is not reset by reloading the driver (as it should be) and
the only course of action is a full reboot.

I just don't know why other users would not be seeing that.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
