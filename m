Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor4.renesas.com ([210.160.252.174]:49884 "EHLO
	relmlor4.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3FDRXj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jun 2013 13:23:39 -0400
Received: from relmlir1.idc.renesas.com ([10.200.68.151])
 by relmlor4.idc.renesas.com ( SJSMS)
 with ESMTP id <0MNV00HBLPND50B0@relmlor4.idc.renesas.com> for
 linux-media@vger.kernel.org; Wed, 05 Jun 2013 02:23:37 +0900 (JST)
Received: from relmlac2.idc.renesas.com ([10.200.69.22])
 by relmlir1.idc.renesas.com (SJSMS)
 with ESMTP id <0MNV00IJ1PNDEPC0@relmlir1.idc.renesas.com> for
 linux-media@vger.kernel.org; Wed, 05 Jun 2013 02:23:37 +0900 (JST)
In-reply-to: <CAGGh5h1btafaMoaB89RBND2L8+Zg767HW3+hKG7Xcq2fsEN6Ew@mail.gmail.com>
References: <201306031547.52124.hverkuil@xs4all.nl>
 <1370276302-7295-1-git-send-email-phil.edworthy@renesas.com>
 <CAGGh5h1btafaMoaB89RBND2L8+Zg767HW3+hKG7Xcq2fsEN6Ew@mail.gmail.com>
To: jean-philippe francois <jp.francois@cynove.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	jphilippe.francois@gmail.com,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-version: 1.0
From: phil.edworthy@renesas.com
Subject: Re: [PATCH v2] ov10635: Add OmniVision ov10635 SoC camera driver
Message-id: <OFE9AF5116.6C737633-ON80257B80.005E56FF-80257B80.005F7B22@eu.necel.com>
Date: Tue, 04 Jun 2013 18:22:53 +0100
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Philippe,

Thanks for the review.

<snip>
> > +static const struct ov10635_reg ov10635_regs_enable[] = {
> > +       { 0x3042, 0xf0 }, { 0x3042, 0xf0 }, { 0x3042, 0xf0 }, { 
> 0x3042, 0xf0 },
> > +       { 0x3042, 0xf0 }, { 0x3042, 0xf0 }, { 0x3042, 0xf0 }, { 
> 0x3042, 0xf0 },
> > +       { 0x3042, 0xf0 }, { 0x3042, 0xf0 }, { 0x3042, 0xf0 }, { 
> 0x3042, 0xf0 },
> > +       { 0x3042, 0xf0 }, { 0x3042, 0xf0 }, { 0x3042, 0xf0 }, { 
> 0x3042, 0xf0 },
> > +       { 0x3042, 0xf0 }, { 0x3042, 0xf0 }, { 0x3042, 0xf0 }, { 
> 0x3042, 0xf0 },
> > +       { 0x3042, 0xf0 }, { 0x3042, 0xf0 }, { 0x3042, 0xf0 }, { 
> 0x3042, 0xf0 },
> > +       { 0x3042, 0xf0 }, { 0x3042, 0xf0 }, { 0x301b, 0xf0 }, { 
> 0x301c, 0xf0 },
> > +       { 0x301a, 0xf0 },
> > +};
> 
> Register 0x3042 is only touched by the enable part, not by the "change
> mode" part
> I think you could move the {0x3042, 0xf0} sequence in the
> standard_regs array, and keep
> only the 0x301b, 0x301c, 0x301a registers.
I tried this, but it doesn't work. You have to write to the 0x3042 
register after other setup writes.

> By the way, did you test with a single write ? There is the same
> sequence in ov5642
> init, so I believe it is copy pasted in every omnivision init. Is it
> actually useful ?
I tried this & a single write works so I'll change this. iirc, it was 
taken from a reference set of writes from OmniVision. 

<snip>
> > +static int ov10635_video_probe(struct i2c_client *client)
> > +{
> > +       struct ov10635_priv *priv = to_ov10635(client);
> > +       u8 pid, ver;
> > +       int ret;
> > +
> > +       /* Program all the 'standard' registers */
> > +       ret = ov10635_set_regs(client, ov10635_regs_default,
> > +               ARRAY_SIZE(ov10635_regs_default));
> > +       if (ret)
> > +               return ret;
> > +
> > +       /* check and show product ID and manufacturer ID */
> > +       ret = ov10635_reg_read(client, OV10635_PID, &pid);
> > +       if (ret)
> > +               return ret;
> > +       ret = ov10635_reg_read(client, OV10635_VER, &ver);
> > +       if (ret)
> > +               return ret;
> > +
> > +       if (OV10635_VERSION(pid, ver) != OV10635_VERSION_REG) {
> > +               dev_err(&client->dev, "Product ID error %x:%x\n", pid, 
ver);
> > +               return -ENODEV;
> > +       }
> 
> Shouldn't the order be reversed here ?
> iow, first chek chip id register, then proceed with the register init ?
Good point! I'll fix this.

Thanks
Phil
