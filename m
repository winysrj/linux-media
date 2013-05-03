Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([94.23.35.102]:38087 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab3ECCJu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 May 2013 22:09:50 -0400
Date: Thu, 2 May 2013 23:10:12 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	jonjon.arnearne@gmail.com
Subject: Re: [PATCH V2 2/3] saa7115: add detection code for gm7113c
Message-ID: <20130503021011.GC5722@localhost>
References: <1367268069-11429-1-git-send-email-jonarne@jonarne.no>
 <1367268069-11429-3-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367268069-11429-3-git-send-email-jonarne@jonarne.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 29, 2013 at 10:41:08PM +0200, Jon Arne Jørgensen wrote:
> Adds a code that (auto)detects gm7113c clones. The auto-detection
> here is not perfect, as, on contrary to what it would be expected
> by looking into its datasheets some devices would return, instead:
> 
> 	saa7115 0-0025: chip 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 10 @ 0x4a is unknown
> 
> (found on a device labeled as GM7113C 1145 by Ezequiel Garcia)
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>

Your SOB doesn't appear to be correct. See my previous comment.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
