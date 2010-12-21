Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.126.186]:53989 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab0LUTDR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Dec 2010 14:03:17 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thiago Farina <tfransosi@gmail.com>
Subject: Re: [PATCH] drivers/media/video/v4l2-compat-ioctl32.c: Check the return value of copy_to_user
Date: Tue, 21 Dec 2010 20:03:11 +0100
Cc: linux-kernel@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <d21ad74592c295d59f5806f30a053745b5765397.1292894256.git.tfransosi@gmail.com> <201012211925.38201.arnd@arndb.de> <AANLkTikbvST_B+4x3Xt=gxFhM1TBOrXVc1HjZT3zTXrt@mail.gmail.com>
In-Reply-To: <AANLkTikbvST_B+4x3Xt=gxFhM1TBOrXVc1HjZT3zTXrt@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012212003.11446.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tuesday 21 December 2010 19:34:04 Thiago Farina wrote:
> > You can probably change this function to look at the return code of
> > copy_to_user, but then you need to treat the put_user return code
> > the same, and change the comment.
> >
> 
> Right, I will do the same with put_user, but I'm afraid of changing the comment.

The comment makes no sense when the code doesn't do what is explained
there.

	Arnd
