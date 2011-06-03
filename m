Return-path: <mchehab@pedra>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55870 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab1FCFj2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 01:39:28 -0400
Received: by pvg12 with SMTP id 12so710122pvg.19
        for <linux-media@vger.kernel.org>; Thu, 02 Jun 2011 22:39:28 -0700 (PDT)
Message-ID: <4DE873B4.4050306@gmail.com>
Date: Thu, 02 Jun 2011 22:40:04 -0700
From: John McMaster <johndmcmaster@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Anchor Chips V4L2 driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I'd like to write a driver for an Anchor Chips (seems to be bought by
Cypress) USB camera Linux driver sold as an AmScope MD1800.  It seems
like this implies I need to write a V4L2 driver.  The camera does not
seem its currently supported (checked on Fedora 13 / 2.6.34.8) and I did
not find any information on it in mailing list archives.  Does anyone
know or can help me identify if a similar camera might already be
supported?  lsusb gives the following output:

Bus 001 Device 111: ID 0547:4d88 Anchor Chips, Inc.

I've started reading the "Video for Linux Two API Specification" which
seems like a good starting point and will move onto using source code as
appropriate.  Any help would be appreciated.  Thanks!

John

