Return-Path: <root@uli.uli-eckhardt.de>
MIME-version: 1.0
Content-disposition: inline
Content-type: text/plain; charset=iso-8859-1
Received: from gw-1.arm.linux.org.uk
 ([78.32.30.217]:42289 "EHLO	pandora.arm.linux.org.uk"
 rhost-flags-OK-OK-OK-FAIL)	by vger.kernel.org with ESMTP id S1752884AbaLTOx1
 (ORCPT	<rfc822;linux-media@vger.kernel.org>);	Sat, 20 Dec 2014 09:53:27 -0500
Date: Sat, 20 Dec 2014 14:53:21 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/8] Fix issues in em28xx
Message-id: <20141220145321.GI11285@n2100.arm.linux.org.uk>
References: <20141220124448.GG11285@n2100.arm.linux.org.uk>
 <5495833C.9080507@googlemail.com>
Content-transfer-encoding: 8bit
In-reply-to: <5495833C.9080507@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-Id: <linux-media.vger.kernel.org>
To: uli@uli-eckhardt.de

On Sat, Dec 20, 2014 at 03:10:04PM +0100, Frank Schäfer wrote:
> 
> Am 20.12.2014 um 13:44 schrieb Russell King - ARM Linux:
> > It isn't clear who is the maintainer for this driver; there is no
> > MAINTAINERS entry.  If there is a maintainer, please ensure that they
> > add themselves to this critical file.  Thanks.
> 
> (line 3598)
> 
> EM28XX VIDEO4LINUX DRIVER
> M:    Mauro Carvalho Chehab <m.chehab@samsung.com>
> L:    linux-media@vger.kernel.org
> W:    http://linuxtv.org
> T:    git git://linuxtv.org/media_tree.git
> S:    Maintained
> F:    drivers/media/usb/em28xx/

That's fine then - I thought my scripts picked Mauro up as the
drivers/media maintainer rather than the driver author.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
