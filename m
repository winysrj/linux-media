Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:35684 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395Ab0BBBsM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 20:48:12 -0500
Subject: Re: [PATCH] saa7134: Fix IR support of some ASUS TV-FM 7135  
 variants
From: hermann pitton <hermann-pitton@arcor.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>, Daro <ghost-rider@aster.pl>,
	Roman Kellner <muzungu@gmx.net>
In-Reply-To: <20100201105628.77057856@hyperion.delvare>
References: <20100127120211.2d022375@hyperion.delvare>
	 <4B630179.3080006@redhat.com> <1264812461.16350.90.camel@localhost>
	 <20100130115632.03da7e1b@hyperion.delvare>
	 <1264986995.21486.20.camel@pc07.localdom.local>
	 <20100201105628.77057856@hyperion.delvare>
Content-Type: text/plain
Date: Tue, 02 Feb 2010 02:47:53 +0100
Message-Id: <1265075273.2588.51.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean,

Am Montag, den 01.02.2010, 10:56 +0100 schrieb Jean Delvare:
> Hi Hermann,
> 
> On Mon, 01 Feb 2010 02:16:35 +0100, hermann pitton wrote:
> > For now, I only faked a P7131 Dual with a broken IR receiver on a 2.6.29
> > with recent, you can see that gpio 0x40000 doesn't go high, but your
> > patch should enable the remote on that P7131 analog only.
> 
> I'm not sure why you had to fake anything? What I'd like to know is
> simply if my first patch had any negative effect on other cards.

because I simply don't have that Asus My Cinema analog only in question.

To recap, you previously announced a patch, tested by Daro, claiming to
get the remote up under auto detection for that device and I told you
having some doubts on it.

Mauro prefers to have a fix for that single card in need for now.

Since nobody else cares, "For now", see above, I can confirm that your
last patch for that single device should work to get IR up with auto
detection in delay after we change the card such late with eeprom
detection.

The meaning of that byte in use here is unknown to me, we should avoid
such as much we can! It can turn out to be only some pseudo service.

If your call for testers on your previous attempt, really reaches some
for some reason, I'm with you, but for now I have to keep the car
operable within all such snow.

Cheers,
Hermann














