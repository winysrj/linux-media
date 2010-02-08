Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab0BHSTP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 13:19:15 -0500
Message-ID: <4B70559D.7070006@redhat.com>
Date: Mon, 08 Feb 2010 16:19:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Richard <tuxbox.guru@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: TM6000 Driver building
References: <4B7030C5.6000303@gmail.com>
In-Reply-To: <4B7030C5.6000303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Richard wrote:
> Hi all,
> 
> Pardon my green-ness to the whole process of the v4l-dvb and would like
> some pointers on how to build the TM6000 components of the drivers
> 
> in v4l/ directtory I edited the .config to enable the TM6000_DVB=m
> clause and rebuilt.. but lo and behold there were still no modules
> built.. I am trying to hack on the WinTV-NOVA-S USB2 device and register
> it as a Generic TM6000 to start my porting.
> 
> Is there a special branch or a quick 'howto' so I can enable this module
> 
> 
> Any help would be greatly appreciated.
> Richard

Richard,

This driver is not ready yet for users. There are several flaws on tm6000
design and the driver is not providing enough workarounds to all those bugs.
The current status is that the driver is not properly working yet.

You should wait for some time for the fixes to be added there. That's said,
after finishing the support for Analog and TV,someone will need to work at
the DVB-S part of the driver. So, I'm afraid that you'll need to wait for
some time in order to get it working with Nova-S.

-- 

Cheers,
Mauro
