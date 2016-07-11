Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:34887 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030323AbcGKHoo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 03:44:44 -0400
Subject: Re: [PATCH v3] Add tw5864 driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andrey Utkin <andrey_utkin@fastmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kozlov Sergey <serjk@netup.ru>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Joe Perches <joe@perches.com>, khalasa@piap.pl,
	Guenter Roeck <linux@roeck-us.net>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
References: <20160709194618.15609-1-andrey_utkin@fastmail.com>
 <cac4c81a-9065-2337-7d34-eea8b8482519@xs4all.nl>
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	devel@driverdev.osuosl.org, kernel-mentors@selenic.com,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-pci@vger.kernel.org
From: Jiri Slaby <jslaby@suse.cz>
Message-ID: <aad971f2-914f-95a1-8681-201d50593bd9@suse.cz>
Date: Mon, 11 Jul 2016 09:44:40 +0200
MIME-Version: 1.0
In-Reply-To: <cac4c81a-9065-2337-7d34-eea8b8482519@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/11/2016, 07:58 AM, Hans Verkuil wrote:
>> +static char *artifacts_warning = "BEWARE OF KNOWN ISSUES WITH VIDEO QUALITY\n"
> 
> const char * const

Or even better, drop the extra space for pointer:

static const char artifacts_warning[] =

thanks,
-- 
js
suse labs
