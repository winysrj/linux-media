Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47676 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbZAILW0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Jan 2009 06:22:26 -0500
Date: Fri, 9 Jan 2009 09:22:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Jean Delvare <khali@linux-fr.org>,
	V4L and DVB maintainers <v4l-dvb-maintainer@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: zr36067 no longer loads automatically (regression)
Message-ID: <20090109092210.6962024b@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.58.0901090112060.1626@shell2.speakeasy.net>
References: <20090108143315.2b564dfe@hyperion.delvare>
	<20090108175627.0ebd9f36@pedra.chehab.org>
	<Pine.LNX.4.58.0901081319340.1626@shell2.speakeasy.net>
	<20090108193923.580fcd5b@pedra.chehab.org>
	<Pine.LNX.4.58.0901082156270.1626@shell2.speakeasy.net>
	<20090109100531.01cb952c@hyperion.delvare>
	<Pine.LNX.4.58.0901090112060.1626@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Fri, 9 Jan 2009 01:13:59 -0800 (PST)
Trent Piepho <xyzzy@speakeasy.org> wrote:

> > > Here's an initial test.  I haven't yet found my dc10+ to test it with.
> >
> > I'm all for it, but what tree was your patch built against? It doesn't
> > seem to apply to anything I have.
> 
> The v4l-dvb main Hg from yesterday.  Looks like Maruo's since committed the
> small patch he posted earlier.

Yes. Better to have for now an interim solution, to avoid others to complain. I
also sent the interim solution to linux-next, but I'll hold a pull request for
a while, since your solution is better.

-- 

Cheers,
Mauro
