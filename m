Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59381 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753625AbZENLow (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 07:44:52 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: e9hack <e9hack@googlemail.com>
Subject: Re: BUG in av7110_vbi_write()
Date: Thu, 14 May 2009 13:44:15 +0200
Cc: linux-media@vger.kernel.org
References: <4A0B414D.5000106@googlemail.com>
In-Reply-To: <4A0B414D.5000106@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905141344.15927@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

e9hack wrote:
> Hi,
> 
> it seems there is a bug in av7110_vbi_write() (av7110_v4l.c). If an user mode application
> tries to write more bytes than the size of the structure v4l2_slices_vbi_data,
> copy_from_user() will overwrite parts of the kernel stack.

No, it cannot happen:

|        if (FW_VERSION(av7110->arm_app) < 0x2623 || !av7110->wssMode || count != sizeof d)
|                return -EINVAL;
|        if (copy_from_user(&d, data, count))
|                return -EFAULT;

copy_from_user() will only be called if count == sizeof d.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------
