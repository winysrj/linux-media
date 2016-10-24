Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46222 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754766AbcJXHRR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 03:17:17 -0400
Date: Mon, 24 Oct 2016 08:17:12 +0100
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        mchehab@kernel.org, stable@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        maintainers@bluecherrydvr.com, ismael@iodev.co.uk,
        hverkuil@xs4all.nl, hans.verkuil@cisco.com
Subject: Re: [PATCH v2] media: solo6x10: fix lockup by avoiding delayed
 register write
Message-ID: <20161024071712.GA20892@dell-m4800.home>
References: <20161022153436.12076-1-andrey.utkin@corp.bluecherry.net>
 <m3zilu4a4q.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3zilu4a4q.fsf@t19.piap.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 24, 2016 at 06:57:25AM +0200, Krzysztof Hałasa wrote:
> Andrey Utkin <andrey.utkin@corp.bluecherry.net> writes:
> 
> > --- a/drivers/media/pci/solo6x10/solo6x10.h
> > +++ b/drivers/media/pci/solo6x10/solo6x10.h
> > @@ -284,7 +284,10 @@ static inline u32 solo_reg_read(struct solo_dev *solo_dev, int reg)
> >  static inline void solo_reg_write(struct solo_dev *solo_dev, int reg,
> >  				  u32 data)
> >  {
> > +	u16 val;
> > +
> >  	writel(data, solo_dev->reg_base + reg);
> > +	pci_read_config_word(solo_dev->pdev, PCI_STATUS, &val);
> >  }
> >  
> >  static inline void solo_irq_on(struct solo_dev *dev, u32 mask)
> 
> This is ok for now. I hope I will find some to refine this, so not all
> register writes are done with the penalty - eventually.

I'm afraid it'd be hard if you don't have a hardware sample which hangs.
I could in theory provide you with SSH access to my dev machine, but
currently I'm in another country so managing this is hard, too.
