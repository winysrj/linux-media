Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33097 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879AbcGMCFg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 22:05:36 -0400
Date: Wed, 13 Jul 2016 05:05:04 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Kozlov Sergey <serjk@netup.ru>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-pci@vger.kernel.org,
	kernel-mentors@selenic.com
Subject: Re: [PATCH v4] [media] pci: Add tw5864 driver - fixed few style
 nits, going to resubmit soon
Message-ID: <20160713020504.GH5934@zver>
References: <20160711151714.5452-1-andrey.utkin@corp.bluecherry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160711151714.5452-1-andrey.utkin@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Found and fixed few very minor coding style nits, will resubmit in few days,
now still waiting for comments to v4.

https://github.com/bluecherrydvr/linux/commits/tw5864

commit 31f7c98a144cb3fb8a94662f002d9b6142d1f390
Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Date:   Wed Jul 13 05:00:28 2016 +0300

    Fix checkpatch --strict issue
    
     CHECK: Alignment should match open parenthesis
     #3599: FILE: drivers/media/pci/tw5864/tw5864-video.c:539:
     +static int tw5864_fmt_vid_cap(struct file *file, void *priv,
     +                               struct v4l2_format *f)

commit 11a09a1048af597ecf374507b08c809eed91b86d
Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Date:   Wed Jul 13 04:59:34 2016 +0300

    Fix checkpatch --strict issue
    
     CHECK: Please don't use multiple blank lines
     #3244: FILE: drivers/media/pci/tw5864/tw5864-video.c:184:

commit 861b2ba8593db7abe89291a4ba85976519783f4a
Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Date:   Wed Jul 13 04:58:37 2016 +0300

    Fix checkpatch --strict issue
    
     CHECK: No space is necessary after a cast
     #3053: FILE: drivers/media/pci/tw5864/tw5864-util.c:36:
     +       return (u8) tw_readl(TW5864_IND_DATA);
