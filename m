Return-path: <linux-media-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:46550 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934046Ab2GLPuf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 11:50:35 -0400
Message-ID: <4FFEF21A.7050701@xenotime.net>
Date: Thu, 12 Jul 2012 08:49:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for July 12 (v4l2-ioctl.c)
References: <20120712160335.9cbff13c2f18eadc7d3cb0cf@canb.auug.org.au>
In-Reply-To: <20120712160335.9cbff13c2f18eadc7d3cb0cf@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/11/2012 11:03 PM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120710:



on i386 and/or x86_64, drivers/media/video/v4l2-ioctl.c has too many
errors to be listed here.  This is the beginning few lines of the errors:


drivers/media/video/v4l2-ioctl.c:1848:2: error: unknown field 'func' specified in initializer
drivers/media/video/v4l2-ioctl.c:1848:2: warning: missing braces around initializer
drivers/media/video/v4l2-ioctl.c:1848:2: warning: (near initialization for 'v4l2_ioctls[0].<anonymous>')
drivers/media/video/v4l2-ioctl.c:1848:2: warning: initialization makes integer from pointer without a cast
drivers/media/video/v4l2-ioctl.c:1848:2: error: initializer element is not computable at load time
drivers/media/video/v4l2-ioctl.c:1848:2: error: (near initialization for 'v4l2_ioctls[0].<anonymous>.offset')
drivers/media/video/v4l2-ioctl.c:1849:2: error: unknown field 'func' specified in initializer
drivers/media/video/v4l2-ioctl.c:1849:2: warning: initialization makes integer from pointer without a cast
drivers/media/video/v4l2-ioctl.c:1849:2: error: initializer element is not computable at load time
drivers/media/video/v4l2-ioctl.c:1849:2: error: (near initialization for 'v4l2_ioctls[2].<anonymous>.offset')
drivers/media/video/v4l2-ioctl.c:1850:2: error: unknown field 'func' specified in initializer
drivers/media/video/v4l2-ioctl.c:1850:2: warning: initialization makes integer from pointer without a cast
drivers/media/video/v4l2-ioctl.c:1850:2: error: initializer element is not computable at load time
drivers/media/video/v4l2-ioctl.c:1850:2: error: (near initialization for 'v4l2_ioctls[4].<anonymous>.offset')
drivers/media/video/v4l2-ioctl.c:1851:2: error: unknown field 'func' specified in initializer
drivers/media/video/v4l2-ioctl.c:1851:2: warning: initialization makes integer from pointer without a cast
drivers/media/video/v4l2-ioctl.c:1851:2: error: initializer element is not computable at load time
drivers/media/video/v4l2-ioctl.c:1851:2: error: (near initialization for 'v4l2_ioctls[5].<anonymous>.offset')
drivers/media/video/v4l2-ioctl.c:1852:2: error: unknown field 'func' specified in initializer
drivers/media/video/v4l2-ioctl.c:1852:2: warning: initialization makes integer from pointer without a cast
drivers/media/video/v4l2-ioctl.c:1852:2: error: initializer element is not computable at load time
drivers/media/video/v4l2-ioctl.c:1852:2: error: (near initialization for 'v4l2_ioctls[8].<anonymous>.offset')
drivers/media/video/v4l2-ioctl.c:1853:2: error: unknown field 'func' specified in initializer



-- 

~Randy
