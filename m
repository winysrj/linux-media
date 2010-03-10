Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:45043 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990Ab0CJFEw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Mar 2010 00:04:52 -0500
Subject: Re: v4l-utils: i2c-id.h and alevt
From: hermann pitton <hermann-pitton@arcor.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, hdegoede@redhat.com
In-Reply-To: <201003090848.29301.hverkuil@xs4all.nl>
References: <201003090848.29301.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Wed, 10 Mar 2010 06:04:17 +0100
Message-Id: <1268197457.3199.17.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, both,

Am Dienstag, den 09.03.2010, 08:48 +0100 schrieb Hans Verkuil:
> It's nice to see this new tree, that should be make it easier to develop
> utilities!
> 
> After a quick check I noticed that the i2c-id.h header was copied from the
> kernel. This is not necessary. The only utility that includes this is v4l2-dbg
> and that one no longer needs it. Hans, can you remove this?
> 
> The second question is whether anyone would object if alevt is moved from
> dvb-apps to v4l-utils? It is much more appropriate to have that tool in
> v4l-utils.

i wonder that this stays such calm, hopefully a good sign.

In fact alevt analog should come with almost every distribution, but the
former alevt-dvb, named now only alevt, well, might be ok in some
future, is enhanced for doing also dvb-t-s and hence there ATM.

> Does anyone know of other unmaintained but useful tools that we might merge
> into v4l-utils? E.g. xawtv perhaps?

If for xawtv could be some more care, ships also since close to ever
with alevtd, that would be fine, but I'm not sure we are talking about
tools anymore in such case, since xawtv4x, tvtime and mpeg4ip ;) for
example are also there and unmaintained.

Cheers,
Hermann


