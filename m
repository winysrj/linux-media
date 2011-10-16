Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46152 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1JPU0m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Oct 2011 16:26:42 -0400
Received: by wwe6 with SMTP id 6so1243618wwe.1
        for <linux-media@vger.kernel.org>; Sun, 16 Oct 2011 13:26:41 -0700 (PDT)
Message-ID: <4e9b3dff.e766e30a.54ec.4d44@mx.google.com>
Subject: Re: [PATCH] af9013 Extended monitoring in set_frontend.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Jason Hecker <jwhecker@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Josu Lazkano <josu.lazkano@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Date: Sun, 16 Oct 2011 21:26:33 +0100
In-Reply-To: <CAATJ+fub_tmoXxxPKU1vBnRNT=7MEUTn0T=_+iP2koj7N4MBrA@mail.gmail.com>
References: <4e83369f.5d6de30a.485b.ffffdc29@mx.google.com>
	 <CAL9G6WWK-Fas4Yx2q2gPpLvo5T2SxVVNFtvSXeD7j07JbX2srw@mail.gmail.com>
	 <CAATJ+fvHQgVMVp1uwxxci61qdCdxG89qK0ja-=jo4JRyGW52cw@mail.gmail.com>
	 <4e8b8099.95d1e30a.4bee.0501@mx.google.com>
	 <CAATJ+fvs5OXBS9VREpZM=tY+z+n97Pf42uJFqLXbh58GVZ_reA@mail.gmail.com>
	 <CAL9G6WWUv+jKY7LkcJMpwMTvV+A-fzwHYJNgpbAkOiQfPoj5ng@mail.gmail.com>
	 <CAATJ+fu2W=o_xhsoghK1756ZGCw2g0W_95iYC8OX04AK8jAHLg@mail.gmail.com>
	 <4e8f6b0b.c90fe30a.4a1d.26bb@mx.google.com>
	 <CAATJ+fvQA4zAcGq+D0+k+OHb8Xsrda5=DATWXbzEO5z=0rWZfw@mail.gmail.com>
	 <CAL9G6WWMw3npqjt0WHGhyjaW5Mu=1jA5Y_QduSr3KudZTKLgBw@mail.gmail.com>
	 <4e904f71.ce66e30a.69f3.ffff9870@mx.google.com>
	 <CAATJ+fstZmoctKrv8Owv53-oEPOn6C8d5FOwMAmLL=7R8UwYzg@mail.gmail.com>
	 <4E93481F.8010205@iki.fi> <1318278450.16238.15.camel@localhost>
	 <CAATJ+fub_tmoXxxPKU1vBnRNT=7MEUTn0T=_+iP2koj7N4MBrA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2011-10-11 at 08:06 +1100, Jason Hecker wrote:
> > Playing with Kaffeine or Mplayer all the devices are fine on the same
> > system.
> 
> Right, admittedly most of my testing has been done with MythTV.  I
> recall about a month ago I could also get corruption with mplayer.
> 
> > At the moment, I am going step by step what Myth TV is sending to the
> > devices.
> 
> Great.  If you want I can replicate your tests here to see what I get.
> 
> Antti, my AF9015 chips are integrated on PCI so I can't swap cables
> (alas, if only this was my problem!)

Jason, do you get firmware loading fails on boot with the PCI device?

There needs to be a delay put in the firmware download of at least 250uS
after each write, but this does not solve the corruption.

I have tried everything, but all of them fail to get rid of the
corruption on the first frontend when the second frontend starts and
then corruptions every 5 seconds or so. These only come through demux on
endpoint 84 and are not caused by any other frontend operations.

Trouble is, on a Nvidia motherboard I have it does not do it at all and
all applications work without any troubles.  This seems to suggest a USB
motherboard driver issue.

However, the frontend lock does make it at least work on Myth TV.

I am continuing to look into it.

Regards

Malcolm

