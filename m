Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0049.hostedemail.com ([216.40.44.49]:57284 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932760AbcCNCHI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2016 22:07:08 -0400
Message-ID: <1457921220.11972.58.camel@perches.com>
Subject: Re: [PATCH] Add tw5864 driver
From: Joe Perches <joe@perches.com>
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>, Jiri Slaby <jslaby@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-pci@vger.kernel.org,
	kernel-mentors@selenic.com
Date: Sun, 13 Mar 2016 19:07:00 -0700
In-Reply-To: <1457920751-21101-1-git-send-email-andrey.utkin@corp.bluecherry.net>
References: <1457920713-21009-1-git-send-email-andrey.utkin@corp.bluecherry.net>
	 <1457920751-21101-1-git-send-email-andrey.utkin@corp.bluecherry.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2016-03-14 at 03:59 +0200, Andrey Utkin wrote:
> Support for boards based on Techwell TW5864 chip which provides
> multichannel video & audio grabbing and encoding (H.264, MJPEG,
> ADPCM G.726).

trivia:

Perhaps all the __used arrays could be const

