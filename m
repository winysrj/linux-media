Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52912 "EHLO
        lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757748AbcION7W (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 09:59:22 -0400
Date: Thu, 15 Sep 2016 14:58:57 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Krzysztof =?UTF-8?B?SGHFgmFzYQ==?= <khalasa@piap.pl>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>
Subject: Re: solo6010 modprobe lockup since e1ceb25a (v4.3 regression)
Message-ID: <20160915145857.5827a7a3@lxorguk.ukuu.org.uk>
In-Reply-To: <20160915131952.rqiy55dqex4ggtnm@acer>
References: <20160915130441.ji3f3jiiebsnsbct@acer>
        <9cbb2079-f705-5312-d295-34bc3c8dadb9@xs4all.nl>
        <20160915131952.rqiy55dqex4ggtnm@acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 15 Sep 2016 16:19:52 +0300
Andrey Utkin <andrey_utkin@fastmail.com> wrote:

> On Thu, Sep 15, 2016 at 03:15:53PM +0200, Hans Verkuil wrote:
> > It could be related to the fact that a PCI write may be delayed unless
> > it is followed by a read (see also the comments in drivers/media/pci/ivtv/ivtv-driver.h).  
> 
> Thanks for explanation!
> 
> > That was probably the reason for the pci_read_config_word in the reg_write
> > code. Try putting that back (and just that).  
> 
> In this case reg_write becomes not atomic, thus spinlock would be
> required again here, right?

No - PCI writes are ordered but may not complete until the next read or
config access. That ordering isn't affected by things like spin locking
as it is a property of the bus.

Usually this only matters in obscure cases - timing is one of them, and
the other is when freeing memory because writes are posted both ways so
you need to write to stop the transfer, read to ensure the transfer has
completed and then free the target memory.

Alan
