Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57576 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbbERKbW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2015 06:31:22 -0400
Date: Mon, 18 May 2015 12:31:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	maxx <maxx@spaceboyz.net>
Subject: Re: [PATCH] radio-bcm2048: Enable access to automute and ctrl
 registers
Message-ID: <20150518103119.GA14355@amd>
References: <1431725511-7379-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1431725511-7379-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 2015-05-15 23:31:51, Pali Rohár wrote:
> From: maxx <maxx@spaceboyz.net>
> 
> This enables access to automute function of the chip via sysfs and
> gives direct access to FM_AUDIO_CTRL0/1 registers, also via sysfs. I
> don't think this is so important but helps in developing radio scanner
> apps.

Is directly exposing hardware registers in sysfs a good idea?
(Debugfs?)

If this goes to sysfs, could we get interface description?


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
