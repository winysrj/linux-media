Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3K0ECv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 23:02:51 -0500
Date: Tue, 26 Nov 2013 20:03:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Joe Perches <joe@perches.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	rkuo <rkuo@codeaurora.org>, hans.verkuil@cisco.com,
	m.chehab@samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] drivers: staging: media: go7007: go7007-usb.c use
 pr_*() instead of dev_*() before 'go' initialized in go7007_usb_probe()
Message-ID: <20131127040338.GB23930@kroah.com>
References: <528AEFB7.4060301@gmail.com>
 <20131125011938.GB18921@codeaurora.org>
 <5292B845.3010404@gmail.com>
 <5292B8A0.7020409@gmail.com>
 <5294255E.7040105@gmail.com>
 <52956442.50001@gmail.com>
 <1385522475.18487.34.camel@joe-AO722>
 <529569A5.1020008@gmail.com>
 <52956B78.6050107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52956B78.6050107@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 27, 2013 at 11:48:08AM +0800, Chen Gang wrote:
> dev_*() assumes 'go' is already initialized, so need use pr_*() instead
> of before 'go' initialized. Related warning (with allmodconfig under
> hexagon):
> 
>     CC [M]  drivers/staging/media/go7007/go7007-usb.o
>   drivers/staging/media/go7007/go7007-usb.c: In function 'go7007_usb_probe':
>   drivers/staging/media/go7007/go7007-usb.c:1060:2: warning: 'go' may be used uninitialized in this function [-Wuninitialized]
> 
> Also remove useless code after 'return' statement.

This should all be fixed in my staging-linus branch already, right?  No
need for this anymore from what I can tell, sorry.

greg k-h
