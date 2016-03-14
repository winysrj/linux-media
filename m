Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41476 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbcCNDct (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2016 23:32:49 -0400
Date: Sun, 13 Mar 2016 20:32:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	devel@driverdev.osuosl.org, kernel-mentors@selenic.com,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Add tw5864 driver
Message-ID: <20160314033248.GA3905@kroah.com>
References: <1457920461-20713-1-git-send-email-andrey_utkin@fastmail.com>
 <1457920514-20792-1-git-send-email-andrey_utkin@fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1457920514-20792-1-git-send-email-andrey_utkin@fastmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 14, 2016 at 03:55:14AM +0200, Andrey Utkin wrote:
> From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> 
> Support for boards based on Techwell TW5864 chip which provides
> multichannel video & audio grabbing and encoding (H.264, MJPEG,
> ADPCM G.726).
> 
> Signed-off-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> Tested-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>

Meta-conmment, why add this to drivers/staging/media?  Why can't it just
go into drivers/media/ ?

thanks,

greg k-h
