Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47625 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab0JUSxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 14:53:12 -0400
Received: by yxn35 with SMTP id 35so57933yxn.19
        for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 11:53:11 -0700 (PDT)
Subject: Re: [PATCH 3/4] [media] mceusb: Improve parser to get codes sent together with IR RX data
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <20101021120747.1aca4517@pedra>
Date: Thu, 21 Oct 2010 14:53:25 -0400
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <F4910ACF-BF61-41C9-86E5-EF5510A51845@wilsonet.com>
References: <cover.1287669886.git.mchehab@redhat.com> <20101021120747.1aca4517@pedra>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Oct 21, 2010, at 10:07 AM, Mauro Carvalho Chehab wrote:

> On cx231xx, sometimes, several control messages are sent together
> with data. Improves the parser to also handle those cases.
> 
> For example:
> 
> [38777.211690] mceusb 7-6:1.0: rx data: 9f 14 01 9f 15 00 00 80  (length=8)
> [38777.211696] mceusb 7-6:1.0: Got long-range receive sensor in use
> [38777.211700] mceusb 7-6:1.0: Received pulse count is 0
> [38777.211703] mceusb 7-6:1.0: IR data len = 0
> [38777.211707] mceusb 7-6:1.0: New data. rem: 0x1f, cmd: 0x80
> 
> Before this patch, only the first message would be displayed, as the
> parser would be stopping at "9f 14 01".
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

So two minor issues with this patch...

First, the debug spew looks slightly confusing, though through no fault of yours, really. Now that you're parsing all three chunks of that final sequence, you see a "New data." message that actually comes from the first chunk of the three, but after you've already seen the other three. We should probably just drop that dev_dbg and rely on the 'IR data len' one.

The second issue is the very last hunk of the patch that moves the call to ir_raw_event_handle, which should be unrelated to the rest of this patch (and may, iirc, cause issues for the first-gen transceiver -- I'd have to re-test to be sure).

But otherwise, looks good to me.


> diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
> index a726f63..609bf3d 100644
> --- a/drivers/media/IR/mceusb.c
> +++ b/drivers/media/IR/mceusb.c
...
> @@ -724,9 +755,9 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
> 		if (ir->buf_in[i] == 0x80 || ir->buf_in[i] == 0x9f)
> 			ir->rem = 0;
> 
> -		dev_dbg(ir->dev, "calling ir_raw_event_handle\n");
> -		ir_raw_event_handle(ir->idev);
> 	}
> +	dev_dbg(ir->dev, "calling ir_raw_event_handle\n");
> +	ir_raw_event_handle(ir->idev);
> }
> 
> static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)

^^^ the unrelated hunk.

-- 
Jarod Wilson
jarod@wilsonet.com



