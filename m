Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:40972 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab0JUMwd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 08:52:33 -0400
Date: Thu, 21 Oct 2010 14:52:24 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH 3/4] MFC: Add MFC 5.1 V4L2 driver
In-reply-to: <007601cb70b3$5c1fdcc0$145f9640$%oh@samsung.com>
To: jaeryul.oh@samsung.com, linux-media@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, kgene.kim@samsung.com
Message-id: <000901cb711e$d2614a20$7723de60$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-us
Content-transfer-encoding: 7BIT
References: <1286968160-10629-1-git-send-email-k.debski@samsung.com>
 <1286968160-10629-4-git-send-email-k.debski@samsung.com>
 <000201cb6c1e$52002130$f6006390$%oh@samsung.com>
 <000001cb7062$a1e00470$e5a00d50$%debski@samsung.com>
 <007601cb70b3$5c1fdcc0$145f9640$%oh@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

 
> I commented as belows,
> And you missed one important things 'cause there were my comments
> in the very long email which is strongly fixed in the reset seq.

Yes, thanks for your suggestion.
 
> 
> [....]
> > +#define READL(offset)		readl(dev->regs_base + (offset))
> > +#define WRITEL(data, offset)	writel((data), dev->regs_base +
> (offset))
> > +#define OFFSETA(x)		(((x) - dev->port_a) >> 11)
> > +#define OFFSETB(x)		(((x) - dev->port_b) >> 11)
> > +
> > +/* Reset the device */
> > +static int s5p_mfc_cmd_reset(struct s5p_mfc_dev *dev)
> > +{
> > +	unsigned int mc_status;
> > +	unsigned long timeout;
> > +	mfc_debug("s5p_mfc_cmd_reset++\n");
> > +	/* Stop procedure */
> > +	WRITEL(0x3f7, S5P_FIMV_SW_RESET);	/*  reset VI */
> 
> Ahm, This (WRITEL(0x3f7, S5P_FIMV_SW_RESET)) might be a problem.
> In the reset seq. of MFC driver, we checked out
> That FW(s5pc110-mfc.fw in the s5p_mfc_load_firmware()) runned by RISC
> core
> at this point could access invalid address. It should be removed.
> 

Thanks for pointing this out. I will remove it in the next version.

[snip]

Best regards
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

