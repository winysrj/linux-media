Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43963 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751308AbcIONVy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 09:21:54 -0400
Date: Thu, 15 Sep 2016 16:19:52 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>
Subject: Re: solo6010 modprobe lockup since e1ceb25a (v4.3 regression)
Message-ID: <20160915131952.rqiy55dqex4ggtnm@acer>
References: <20160915130441.ji3f3jiiebsnsbct@acer>
 <9cbb2079-f705-5312-d295-34bc3c8dadb9@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cbb2079-f705-5312-d295-34bc3c8dadb9@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 15, 2016 at 03:15:53PM +0200, Hans Verkuil wrote:
> It could be related to the fact that a PCI write may be delayed unless
> it is followed by a read (see also the comments in drivers/media/pci/ivtv/ivtv-driver.h).

Thanks for explanation!

> That was probably the reason for the pci_read_config_word in the reg_write
> code. Try putting that back (and just that).

In this case reg_write becomes not atomic, thus spinlock would be
required again here, right?
