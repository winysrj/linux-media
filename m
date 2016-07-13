Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:35667 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751495AbcGMHFx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 03:05:53 -0400
Subject: Re: [PATCH v4] [media] pci: Add tw5864 driver - fixed few style nits,
 going to resubmit soon
To: Andrey Utkin <andrey_utkin@fastmail.com>,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
References: <20160711151714.5452-1-andrey.utkin@corp.bluecherry.net>
 <20160713020504.GH5934@zver>
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
	=?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-pci@vger.kernel.org,
	kernel-mentors@selenic.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5d3d8684-fe20-0bc8-7465-53c5f7b55447@xs4all.nl>
Date: Wed, 13 Jul 2016 09:05:27 +0200
MIME-Version: 1.0
In-Reply-To: <20160713020504.GH5934@zver>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/13/2016 04:05 AM, Andrey Utkin wrote:
> Found and fixed few very minor coding style nits, will resubmit in few days,
> now still waiting for comments to v4.

Can you resubmit now? I plan to review it on Friday or Monday, and I'd rather
review the latest version.

Regards,

	Hans

> 
> https://github.com/bluecherrydvr/linux/commits/tw5864
> 
> commit 31f7c98a144cb3fb8a94662f002d9b6142d1f390
> Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> Date:   Wed Jul 13 05:00:28 2016 +0300
> 
>     Fix checkpatch --strict issue
>     
>      CHECK: Alignment should match open parenthesis
>      #3599: FILE: drivers/media/pci/tw5864/tw5864-video.c:539:
>      +static int tw5864_fmt_vid_cap(struct file *file, void *priv,
>      +                               struct v4l2_format *f)
> 
> commit 11a09a1048af597ecf374507b08c809eed91b86d
> Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> Date:   Wed Jul 13 04:59:34 2016 +0300
> 
>     Fix checkpatch --strict issue
>     
>      CHECK: Please don't use multiple blank lines
>      #3244: FILE: drivers/media/pci/tw5864/tw5864-video.c:184:
> 
> commit 861b2ba8593db7abe89291a4ba85976519783f4a
> Author: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> Date:   Wed Jul 13 04:58:37 2016 +0300
> 
>     Fix checkpatch --strict issue
>     
>      CHECK: No space is necessary after a cast
>      #3053: FILE: drivers/media/pci/tw5864/tw5864-util.c:36:
>      +       return (u8) tw_readl(TW5864_IND_DATA);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
