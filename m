Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:40431 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab0IWLWU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 07:22:20 -0400
Date: Thu, 23 Sep 2010 13:21:10 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	linux-media@vger.kernel.org, "Janne Grunau" <j@jannau.net>,
	"Jarod Wilson" <jarod@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove v4l2-i2c-drv.h and most of  
 i2c-id.h
Message-ID: <20100923132110.69f6aab8@endymion.delvare>
In-Reply-To: <a7c1e59279e4144dc224cc7978d3708c.squirrel@webmail.xs4all.nl>
References: <201009152200.27132.hverkuil@xs4all.nl>
	<4C9AD51D.2010400@redhat.com>
	<201009230814.43504.hverkuil@xs4all.nl>
	<20100923114420.746a605f@endymion.delvare>
	<a7c1e59279e4144dc224cc7978d3708c.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 23 Sep 2010 11:59:55 +0200, Hans Verkuil wrote:
> > On Thu, 23 Sep 2010 08:14:43 +0200, Hans Verkuil wrote:
> >> this obsolete I2C_HW_B_RIVA:
> >>
> >> drivers/video/riva/rivafb-i2c.c:        chan->adapter.id
> >> = I2C_HW_B_RIVA;
> >
> > I'll have to wait for your cleanup to hit upstream before I can remove
> > that one.
> 
> No need to wait. All that happens if this is removed is that the bogus
> initialization function in tvaudio is no longer doing anything. And when
> my patch is merged, then that function is removed completely.

Sure, but I still think it's easier to let you merge your changes
first. After that, I can kill the whole thing without a thinking and
without the need to explain why it is safe to do - because it will be
totally obvious then.

Thanks a lot for your work!

-- 
Jean Delvare
