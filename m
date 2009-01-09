Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:60348 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbZAIUMK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jan 2009 15:12:10 -0500
Date: Fri, 9 Jan 2009 12:12:09 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	V4L and DVB maintainers <v4l-dvb-maintainer@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: zr36067 no longer loads automatically (regression)
In-Reply-To: <20090109124357.549acef6@hyperion.delvare>
Message-ID: <Pine.LNX.4.58.0901091112590.1626@shell2.speakeasy.net>
References: <20090108143315.2b564dfe@hyperion.delvare>
 <20090108175627.0ebd9f36@pedra.chehab.org> <Pine.LNX.4.58.0901081319340.1626@shell2.speakeasy.net>
 <20090108193923.580fcd5b@pedra.chehab.org> <Pine.LNX.4.58.0901082156270.1626@shell2.speakeasy.net>
 <20090109092018.59a6d9eb@pedra.chehab.org> <20090109124357.549acef6@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 9 Jan 2009, Jean Delvare wrote:
> On Fri, 9 Jan 2009 09:20:18 -0200, Mauro Carvalho Chehab wrote:
> > On Thu, 8 Jan 2009 22:01:08 -0800 (PST)
> > Trent Piepho <xyzzy@speakeasy.org> wrote:
> > >
> > > Yuck, why don't we fix this instead?
> >
> > This will be much better.
> >
> > > Here's an initial test.  I haven't yet found my dc10+ to test it with.
> >
> > Unfortunately, I don't have any Zoran card here to test.
> >
> > Jean, it is up to you to test Trent's patch.
>
> Will do as soon as I manage to apply it.

Here is a new version against latest v4l-dvb sources.  Jean, are you trying
to apply against the kernel tree?  These patches are against the v4l-dvb Hg
repository which isn't quite the same as what's in the kernel.

I have some more patches at http://linuxtv.org/hg/~tap/zoran
