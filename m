Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:45714 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbZLECLK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Dec 2009 21:11:10 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Andy Walls <awalls@radix.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <1259977687.27969.18.camel@localhost>
References: <20091204220708.GD25669@core.coreip.homeip.net>
	 <BEJgSGGXqgB@lirc>
	 <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
	 <1259977687.27969.18.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 21:10:34 -0500
Message-Id: <1259979034.27969.31.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-12-04 at 20:48 -0500, Andy Walls wrote:
> On Fri, 2009-12-04 at 19:28 -0500, Jon Smirl wrote:
> > On Fri, Dec 4, 2009 at 6:01 PM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
> > > BTW, I just came across a XMP remote that seems to generate 3x64 bit scan
> > > codes. Anyone here has docs on the XMP protocol?
> > 
> > Assuming a general purpose receiver (not one with fixed hardware
> > decoding), is it important for Linux to receive IR signals from all
> > possible remotes no matter how old or obscure?

Google reveals that XMP is somewhat new, proprietary, and not limited to
remotes:

http://www.uei.com/html.php?page_id=89


UEI is apparently the company responsible for the "One for All" brand of
remote controls:

http://www.uei.com/html.php?page_id=62



Here's some random tech details about one XMP remote:

http://irtek.wikidot.com/remotecomcastxmp


Regards,
Andy


