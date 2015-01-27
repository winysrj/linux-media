Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:53812 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbbA0HEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2015 02:04:34 -0500
Received: by mail-oi0-f44.google.com with SMTP id a3so11060957oib.3
        for <linux-media@vger.kernel.org>; Mon, 26 Jan 2015 23:04:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150121173128.GV26493@n2100.arm.linux.org.uk>
References: <1421813807-9178-1-git-send-email-sumit.semwal@linaro.org>
 <1421813807-9178-3-git-send-email-sumit.semwal@linaro.org> <20150121173128.GV26493@n2100.arm.linux.org.uk>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Tue, 27 Jan 2015 12:34:13 +0530
Message-ID: <CAO_48GE4XQm+Fd9JUGzyw9fsFDSo6+fRY79vwS=Yjcw5GLZAJg@mail.gmail.com>
Subject: Re: [RFCv2 2/2] dma-buf: add helpers for sharing attacher constraints
 with dma-parms
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
	Rob Clark <robdclark@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell!

On 21 January 2015 at 23:01, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Jan 21, 2015 at 09:46:47AM +0530, Sumit Semwal wrote:
>> +static int calc_constraints(struct device *dev,
>> +                         struct dma_buf_constraints *calc_cons)
>> +{
>> +     struct dma_buf_constraints cons = *calc_cons;
>> +
>> +     cons.dma_mask &= dma_get_mask(dev);
>
> I don't think this makes much sense when you consider that the DMA
> infrastructure supports buses with offsets.  The DMA mask is th
> upper limit of the _bus_ specific address, it is not a mask per-se.
>
> What this means is that &= is not the right operation.  Moreover,
> simply comparing masks which could be from devices on unrelated
> buses doesn't make sense either.
>
> However, that said, I don't have an answer for what you want to
> achieve here.

Thanks for your comments! I suppose in that case, I will leave out the
*dma_masks from this constraints information for now; we can re-visit
it when a specific use case really needs information about the
dma-masks of the attached devices.

I will post an updated patch-set soon.
>
> --
> FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
> according to speedtest.net.



-- 
Thanks and regards,

Sumit Semwal
Kernel Team Lead - Linaro Mobile Group
Linaro.org │ Open source software for ARM SoCs
