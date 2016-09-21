Return-path: <linux-media-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:53103 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756336AbcIUNqG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 09:46:06 -0400
Date: Wed, 21 Sep 2016 16:45:54 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>
Subject: Re: solo6010 modprobe lockup since e1ceb25a (v4.3 regression)
Message-ID: <20160921134554.s3tdolyej6r2w5wh@zver>
References: <20160915130441.ji3f3jiiebsnsbct@acer>
 <9cbb2079-f705-5312-d295-34bc3c8dadb9@xs4all.nl>
 <m3k2e5wfxy.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3k2e5wfxy.fsf@t19.piap.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 21, 2016 at 03:16:57PM +0200, Krzysztof Hałasa wrote:
> Hans Verkuil <hverkuil@xs4all.nl> writes:
> 
> > That was probably the reason for the pci_read_config_word in the reg_write
> > code. Try putting that back (and just that).
> 
> Yes. I guess a single pci_read_config_word() would suffice.
> 
> Though it would obviously be much better to identify the place in the
> driver which needs to have the write buffers flushed, and add a read()
> just there.
> 
> The interrupt handler maybe (e.g. just before the return IRQ_HANDLED)?
> 
> OTOH this may be some sort of timing problem, I mean the faster code may
> put too much stress on the SOLO chip.
> 
> Doesn't happen here so I can't test the cure.

It happens in solo_disp_init at uploading default motion thresholds
array.

I've got a prints trace with solo6010-fix-lockup branch
https://github.com/bluecherrydvr/linux/tree/solo6010-fix-lockup/drivers/media/pci/solo6x10
the trace itself in jpg:
https://decent.im:5281/upload/3793f393-e285-4514-83dd-bf08d1c8b4a2/e7ad898b-515b-4522-86a9-553daaeb0860.jpg

Indeed, targeted fixing would be more reasonable than making register
r/w routines follow blocking fashion. But the driver is already complete
and was known to be working, and I seems all places in code assume the
blocking fashion of reg r/w, and changing that assumption may lead to
covert bugs anywhere else, not just at probing, which may be hard to
nail down.

For now, I'll try setting pci_read_config_word() back instead of full
revert. Does it need to be just in reg_write? No need for it in
reg_read, right?
