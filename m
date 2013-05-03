Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([94.23.35.102]:38081 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab3ECCIw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 May 2013 22:08:52 -0400
Date: Thu, 2 May 2013 23:09:14 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	jonjon.arnearne@gmail.com
Subject: Re: [PATCH V2 1/3] saa7115: move the autodetection code out of the
 probe function
Message-ID: <20130503020913.GB5722@localhost>
References: <1367268069-11429-1-git-send-email-jonarne@jonarne.no>
 <1367268069-11429-2-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367268069-11429-2-git-send-email-jonarne@jonarne.no>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

On Mon, Apr 29, 2013 at 10:41:07PM +0200, Jon Arne Jørgensen wrote:
> As we're now seeing other variants from chinese clones, like
> gm1113c, we'll need to add more bits at the detection code.
> 
> So, move it into a separate function.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>

As far as I can see, this patch is identical to the one sent
by Mauro. Therefore, your SOB here is incorrect, since you are not
the author of the patch.

The proper way of re-submitting patches that have been previously
submitted by another developer is this:

--
From: Mauro Carvalho Chehab <mchehab@redhat.com>

Commit message goes here.

Notice how the first line is a 'From:' tagcindicating who's the
real submitter. The SOB tag indicates the patch author, and you
can add your acked-by, tested-by or reported-by if you want.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Reported-by: Jon Arne Jørgensen <jonarne@jonarne.no>
--

You can read more about this in Documentation/SubmittingPatches.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
