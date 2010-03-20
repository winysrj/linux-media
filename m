Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43423 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751765Ab0CTPON (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Mar 2010 11:14:13 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: av7110 and budget_av are broken! (was: Re: changeset 14351:2eda2bcc8d6f)
Date: Sat, 20 Mar 2010 16:13:52 +0100
Cc: linux-media@vger.kernel.org, e9hack <e9hack@googlemail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <4B8E4A6F.2050809@googlemail.com> <201003201507.09504@orion.escape-edv.de> <201003201520.40069.hverkuil@xs4all.nl>
In-Reply-To: <201003201520.40069.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003201613.53396@orion.escape-edv.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Saturday 20 March 2010 15:07:08 Oliver Endriss wrote:
> > e9hack wrote:
> > > Am 13.3.2010 17:27, schrieb Hans Verkuil:
> > > > If there are no further comments, then I'll post a pull request in a few days.
> > > > 
> > > > Tested with the mxb board. It would be nice if you can verify this with the
> > > > av7110.
> > > 
> > > Hi hans,
> > > 
> > > it works with my TT-C2300 perfectly. The main problem of your changes was: It wasn't
> > > possible to unload the module for the TT-C2300.
> > 
> > Guys, when will you finally apply this fix?
> 
> Thanks for reminding me, I frankly forgot about this.
> 
> Hartmut, is the problem with unloading the module something that my patch
> caused? Or was that there as well before changeset 14351:2eda2bcc8d6f?
> Are there any kernel messages indicating why it won't unload?

The patch caused the problem.

You moved v4l2_device_register() from saa7146_vv_init() to
saa7146_vv_devinit(), but you did not modify av7110_v4l.c and
budget-av.c accordingly.

$ grep saa7146_vv_init v4l/*c
v4l/av7110_v4l.c:       ret = saa7146_vv_init(dev, vv_data);
v4l/budget-av.c:                if (0 != saa7146_vv_init(dev, &vv_data)) {
v4l/hexium_gemini.c:    saa7146_vv_init(dev, &vv_data);
v4l/hexium_orion.c:     saa7146_vv_init(dev, &vv_data);
v4l/mxb.c:      saa7146_vv_init(dev, &vv_data);
v4l/saa7146_fops.c:int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
v4l/saa7146_fops.c:EXPORT_SYMBOL_GPL(saa7146_vv_init);
v4l/saa7146_fops.c:static int __init saa7146_vv_init_module(void)
v4l/saa7146_fops.c:module_init(saa7146_vv_init_module);

$ grep saa7146_vv_devinit v4l/*c
v4l/hexium_gemini.c:    ret = saa7146_vv_devinit(dev);
v4l/hexium_orion.c:     err = saa7146_vv_devinit(dev);
v4l/mxb.c:      err = saa7146_vv_devinit(dev);
v4l/saa7146_fops.c:int saa7146_vv_devinit(struct saa7146_dev *dev)
v4l/saa7146_fops.c:EXPORT_SYMBOL_GPL(saa7146_vv_devinit);

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
