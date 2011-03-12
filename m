Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60499 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab1CLSIQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 13:08:16 -0500
Date: Sat, 12 Mar 2011 21:08:09 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Manjunatha Halli <manjunatha_halli@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: [bug] radio: wl128x: sleep inside of spinlock
Message-ID: <20110312180809.GA17963@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

There is a copy_to_user() call inside of spin_lock_irqsave()/spin_unlock_irqrestore():

drivers/media/radio/wl128x/fmdrv_common.c:

    /* Copies RDS data from internal buffer to user buffer */
    u32 fmc_transfer_rds_from_internal_buff(struct fmdev *fmdev, struct file *file,
            u8 __user *buf, size_t count)
    {
        ...
        spin_lock_irqsave(&fmdev->rds_buff_lock, flags);
        ...
            if (copy_to_user(buf, &fmdev->rx.rds.buff[fmdev->rx.rds.rd_idx],
        ...
        spin_unlock_irqrestore(&fmdev->rds_buff_lock, flags);
        return ret;
    }

-- 
Vasiliy
