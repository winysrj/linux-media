Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:46414 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbZICLRy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 07:17:54 -0400
Subject: Re: libv4l2 and the Hauppauge HVR1600 (cx18 driver) not working
	well together
From: Andy Walls <awalls@radix.net>
To: Simon Farnsworth <simon.farnsworth@onelan.com>
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4A9FA0E4.2080603@onelan.com>
References: <4A9E9E08.7090104@onelan.com> <4A9EAF07.3040303@hhs.nl>
	 <4A9F89AD.7030106@onelan.com> <4A9F9006.6020203@hhs.nl>
	 <4A9F98BA.3010001@onelan.com> <4A9F9C5F.9000007@onelan.com>
	 <4A9FA0E4.2080603@onelan.com>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 07:16:20 -0400
Message-Id: <1251976581.22279.15.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-09-03 at 11:56 +0100, Simon Farnsworth wrote:
> Simon Farnsworth wrote:
> > I appear to lose colour after a few seconds of capture, which I shall chase
> > further.
> 
> And resolved - I was off-frequency by 2MHz, which leaves me surprised that
> I got picture. Only thing left for me to sort out is audio support.


I've got a start at cx18-alsa support in

http://linuxtv.org/hg/~awalls/mc-lab  (IIRC)

But it's only really the non-working skeleton of things to get ALSA
device nodes.  The behind the scenes work of actually opening the PCM
stream for ALSA PCM nodes and proper locking with the /dev/video24 PCM
stream nodes is not there.

You'll have to use /dev/video24 for now.

Regards,
Andy

