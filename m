Return-path: <linux-media-owner@vger.kernel.org>
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:43578 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751456Ab3ECGzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 May 2013 02:55:40 -0400
Date: Fri, 3 May 2013 08:58:46 +0200
From: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>,
	mchehab@redhat.com, linux-media@vger.kernel.org,
	jonjon.arnearne@gmail.com
Subject: Re: [PATCH V2 1/3] saa7115: move the autodetection code out of the
 probe function
Message-ID: <20130503065846.GD1232@dell.arpanet.local>
References: <1367268069-11429-1-git-send-email-jonarne@jonarne.no>
 <1367268069-11429-2-git-send-email-jonarne@jonarne.no>
 <20130503020913.GB5722@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130503020913.GB5722@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 02, 2013 at 11:09:14PM -0300, Ezequiel Garcia wrote:
> Hi Jon,
> 
> On Mon, Apr 29, 2013 at 10:41:07PM +0200, Jon Arne Jørgensen wrote:
> > As we're now seeing other variants from chinese clones, like
> > gm1113c, we'll need to add more bits at the detection code.
> > 
> > So, move it into a separate function.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
> 
> As far as I can see, this patch is identical to the one sent
> by Mauro. Therefore, your SOB here is incorrect, since you are not
> the author of the patch.
> 
> The proper way of re-submitting patches that have been previously
> submitted by another developer is this:
> 
> --
> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Commit message goes here.
> 
> Notice how the first line is a 'From:' tagcindicating who's the
> real submitter. The SOB tag indicates the patch author, and you
> can add your acked-by, tested-by or reported-by if you want.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> Reported-by: Jon Arne Jørgensen <jonarne@jonarne.no>
> --
> 
> You can read more about this in Documentation/SubmittingPatches.

I just re-read SubmittingPatches.
I couldn't see that there is anything wrong with multiple sign-off's.

Quote:
  The Signed-off-by: tag indicates that the signer was involved in the
  development of the patch, or that he/she was in the patch's delivery
  path.

and:
  (c) The contribution was provided directly to me by some other
      person who certified (a), (b) or (c) and I have not modified
      it.

It's not that important to me, so If you insist, I'll remove the
signed-off-by line :)

> -- 
> Ezequiel García, Free Electrons
> Embedded Linux, Kernel and Android Engineering
> http://free-electrons.com
