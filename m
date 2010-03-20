Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45941 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751707Ab0CTOH1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Mar 2010 10:07:27 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: linux-media@vger.kernel.org
Subject: av7110 and budget_av are broken! (was: Re: changeset 14351:2eda2bcc8d6f)
Date: Sat, 20 Mar 2010 15:07:08 +0100
Cc: e9hack <e9hack@googlemail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <4B8E4A6F.2050809@googlemail.com> <201003131727.06450.hverkuil@xs4all.nl> <4B9FDC37.8000806@googlemail.com>
In-Reply-To: <4B9FDC37.8000806@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003201507.09504@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

e9hack wrote:
> Am 13.3.2010 17:27, schrieb Hans Verkuil:
> > If there are no further comments, then I'll post a pull request in a few days.
> > 
> > Tested with the mxb board. It would be nice if you can verify this with the
> > av7110.
> 
> Hi hans,
> 
> it works with my TT-C2300 perfectly. The main problem of your changes was: It wasn't
> possible to unload the module for the TT-C2300.

Guys, when will you finally apply this fix?

As Hartmut pointed out, changeset 14351:2eda2bcc8d6f broke the av7110
driver (and also budget-av).

It is time to fix it. This bug must not go into the kernel!

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
