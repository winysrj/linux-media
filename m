Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:11913 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbZAIU27 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jan 2009 15:28:59 -0500
Date: Fri, 9 Jan 2009 21:28:31 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	V4L and DVB maintainers <v4l-dvb-maintainer@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: zr36067 no longer loads automatically (regression)
Message-ID: <20090109212831.332ebe47@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.58.0901091112590.1626@shell2.speakeasy.net>
References: <20090108143315.2b564dfe@hyperion.delvare>
	<20090108175627.0ebd9f36@pedra.chehab.org>
	<Pine.LNX.4.58.0901081319340.1626@shell2.speakeasy.net>
	<20090108193923.580fcd5b@pedra.chehab.org>
	<Pine.LNX.4.58.0901082156270.1626@shell2.speakeasy.net>
	<20090109092018.59a6d9eb@pedra.chehab.org>
	<20090109124357.549acef6@hyperion.delvare>
	<Pine.LNX.4.58.0901091112590.1626@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 9 Jan 2009 12:12:09 -0800 (PST), Trent Piepho wrote:
> On Fri, 9 Jan 2009, Jean Delvare wrote:
> > On Fri, 9 Jan 2009 09:20:18 -0200, Mauro Carvalho Chehab wrote:
> > > Unfortunately, I don't have any Zoran card here to test.
> > >
> > > Jean, it is up to you to test Trent's patch.
> >
> > Will do as soon as I manage to apply it.
> 
> Here is a new version against latest v4l-dvb sources.

-ENOPATCH

>  Jean, are you trying
> to apply against the kernel tree?  These patches are against the v4l-dvb Hg
> repository which isn't quite the same as what's in the kernel.

I know that, I was working off the hg repository, but had some build
problems against Linus' latest kernel. Solved by building against
2.6.28 instead, but then I had to wait until I could reboot to that
kernel before I could test. This just happened. I'll report as soon as
I am done with testing.

> I have some more patches at http://linuxtv.org/hg/~tap/zoran

I'll take a look, thanks.

-- 
Jean Delvare
