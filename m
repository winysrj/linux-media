Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:34874 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab1FZPkU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2011 11:40:20 -0400
Message-ID: <4E0752E0.5030901@iki.fi>
Date: Sun, 26 Jun 2011 18:40:16 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl doesn't
 exist
References: <4E0519B7.3000304@redhat.com>
In-Reply-To: <4E0519B7.3000304@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro Carvalho Chehab wrote:
> Currently, -EINVAL is used to return either when an IOCTL is not
> implemented, or if the ioctl was not implemented.

Hi Mauro,

Thanks for the patch.

The V4L2 core probably should return -ENOIOCTLCMD when an IOCTL isn't 
implemented, but as long as vfs_ioctl() would stay as it is, the user 
space would still get -EINVAL. Or is vfs_ioctl() about to change?

fs/ioctl.c:
----8<-----------
static long vfs_ioctl(struct file *filp, unsigned int cmd,
                       unsigned long arg)
{
         int error = -ENOTTY;

         if (!filp->f_op || !filp->f_op->unlocked_ioctl)
                 goto out;

         error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
         if (error == -ENOIOCTLCMD)
                 error = -EINVAL;
  out:
         return error;
}
----8<-----------

-- 
Sakari Ailus
sakari.ailus@iki.fi
