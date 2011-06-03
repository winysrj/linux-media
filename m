Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:20484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab1FCMPg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2011 08:15:36 -0400
Message-ID: <4DE8D065.7020502@redhat.com>
Date: Fri, 03 Jun 2011 09:15:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: John McMaster <johndmcmaster@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Anchor Chips V4L2 driver
References: <4DE873B4.4050306@gmail.com>
In-Reply-To: <4DE873B4.4050306@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-06-2011 02:40, John McMaster escreveu:
> I'd like to write a driver for an Anchor Chips (seems to be bought by
> Cypress) USB camera Linux driver sold as an AmScope MD1800.  It seems
> like this implies I need to write a V4L2 driver.  The camera does not
> seem its currently supported (checked on Fedora 13 / 2.6.34.8) and I did
> not find any information on it in mailing list archives.  Does anyone
> know or can help me identify if a similar camera might already be
> supported? 

I've no idea. Better to wait for a couple days for developers to manifest
about that, if they're already working on it.

> lsusb gives the following output:
> 
> Bus 001 Device 111: ID 0547:4d88 Anchor Chips, Inc.
> 
> I've started reading the "Video for Linux Two API Specification" which
> seems like a good starting point and will move onto using source code as
> appropriate.  Any help would be appreciated.  Thanks!

You'll find other useful information at linuxtv.org wiki page. The better
is to write it as a sub-driver for gspca. The gspca core have already all
that it is needed for cameras. So, you'll need to focus only at the device-specific
stuff.

Cheers,
Mauro
