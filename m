Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36435 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab2ANUHG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jan 2012 15:07:06 -0500
Received: by eekd4 with SMTP id d4so1452170eek.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jan 2012 12:07:05 -0800 (PST)
Message-ID: <4F11E065.8080509@gmail.com>
Date: Sat, 14 Jan 2012 21:07:01 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH/RFC v2 3/4] gspca: sonixj: Add V4L2_CID_JPEG_COMPRESSION_QUALITY
 control support
References: <4EBECD11.8090709@gmail.com>	<1325873682-3754-4-git-send-email-snjw23@gmail.com>	<20120114094720.781f89a5@tele>	<4F11BE7C.3060601@gmail.com> <20120114192414.05ad2e83@tele>
In-Reply-To: <20120114192414.05ad2e83@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/14/2012 07:24 PM, Jean-Francois Moine wrote:
> 
> Setting the JPEG quality in sonixj has been removed when automatic
> quality adjustment has been added (git commit b96cfc33e7). At this
> time, I let the JPEG get function, but it could have been removed as
> well: I don't think the users are interested by this quality, and the
> applications may find it looking at the quantization tables of the
> images.
> 
> Otherwise, letting the users/applications to set this quality is
> dangerous: if the quality is too high, the images cannot be fully
> transmitted because their size is too big for the USB 1.1 channel.
> 
> So, IMO, you should let the sonixj as it is, and I will remove the
> get_jepgcomp.

I see, indeed the quantization tables provide much more precise 
information. I've dropped the sonixj patch from the series then.

--
Thanks,
Sylwester
