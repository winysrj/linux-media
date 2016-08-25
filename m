Return-path: <linux-media-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35687 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933796AbcHYP2D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Aug 2016 11:28:03 -0400
Message-Id: <1472136366.1628907.705944009.76C1558A@webmail.messagingengine.com>
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Subject: Re: [PATCH 1/2] [media] tw5864-core: remove double irq lock code
Date: Thu, 25 Aug 2016 17:46:06 +0300
In-Reply-To: <c5f789d7d85f4c4b6bcdb2b1674d6495f05ada42.1472056235.git.mchehab@s-opensource.com>
References: <c5f789d7d85f4c4b6bcdb2b1674d6495f05ada42.1472056235.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For some reason (maybe "unlisted recipients"?), my reply didn't get
through to maillists. Resending my reply.

On Wed, Aug 24, 2016, at 19:30, Mauro Carvalho Chehab wrote:
> As warned by smatch:
> 	drivers/media/pci/tw5864/tw5864-core.c:160 tw5864_h264_isr() error: double lock 'irqsave:flags'
> 	drivers/media/pci/tw5864/tw5864-core.c:174 tw5864_h264_isr() error: double unlock 'irqsave:flags'
> 
> Remove the IRQ duplicated lock.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/pci/tw5864/tw5864-core.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/media/pci/tw5864/tw5864-core.c
> b/drivers/media/pci/tw5864/tw5864-core.c
> index 440cd7bb8d04..e3d884e963c0 100644
> --- a/drivers/media/pci/tw5864/tw5864-core.c
> +++ b/drivers/media/pci/tw5864/tw5864-core.c
> @@ -157,12 +157,10 @@ static void tw5864_h264_isr(struct tw5864_dev *dev)
>  
>  		cur_frame = next_frame;
>  
> -               spin_lock_irqsave(&input->slock, flags);
>  		input->frame_seqno++;
>  		input->frame_gop_seqno++;
>  		if (input->frame_gop_seqno >= input->gop)
>  			input->frame_gop_seqno = 0;
> -               spin_unlock_irqrestore(&input->slock, flags);
>  	} else {
>  		dev_err(&dev->pci->dev,
>  			"Skipped frame on input %d because all buffers busy\n",


Thank you very much for catching this issue, but NACK on the patch.

These two lock operations are on different spinlocks. One for device,
another
one for input (a subordinate entity of device). What is superfluous here
is
second _irqsave. Also "flags" variable reuse is wrong. So what would be
right,
in my opinion, is the following (going to submit this patch):

diff --git a/drivers/media/pci/tw5864/tw5864-core.c
b/drivers/media/pci/tw5864/tw5864-core.c
index 440cd7b..1d43b96 100644
--- a/drivers/media/pci/tw5864/tw5864-core.c
+++ b/drivers/media/pci/tw5864/tw5864-core.c
@@ -157,12 +157,12 @@ static void tw5864_h264_isr(struct tw5864_dev
*dev)
 
 		cur_frame = next_frame;
 
-               spin_lock_irqsave(&input->slock, flags);
+               spin_lock(&input->slock);
 		input->frame_seqno++;
 		input->frame_gop_seqno++;
 		if (input->frame_gop_seqno >= input->gop)
 			input->frame_gop_seqno = 0;
-               spin_unlock_irqrestore(&input->slock, flags);
+               spin_unlock(&input->slock);
 	} else {
 		dev_err(&dev->pci->dev,
 			"Skipped frame on input %d because all buffers
 			busy\n",
