Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:37112 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752165AbcIONZK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Sep 2016 09:25:10 -0400
Subject: Re: solo6010 modprobe lockup since e1ceb25a (v4.3 regression)
To: Andrey Utkin <andrey_utkin@fastmail.com>
References: <20160915130441.ji3f3jiiebsnsbct@acer>
 <9cbb2079-f705-5312-d295-34bc3c8dadb9@xs4all.nl>
 <20160915131952.rqiy55dqex4ggtnm@acer>
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <af508dbf-e516-fcf1-3992-5f214bdd03b1@xs4all.nl>
Date: Thu, 15 Sep 2016 15:25:03 +0200
MIME-Version: 1.0
In-Reply-To: <20160915131952.rqiy55dqex4ggtnm@acer>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/15/2016 03:19 PM, Andrey Utkin wrote:
> On Thu, Sep 15, 2016 at 03:15:53PM +0200, Hans Verkuil wrote:
>> It could be related to the fact that a PCI write may be delayed unless
>> it is followed by a read (see also the comments in drivers/media/pci/ivtv/ivtv-driver.h).
> 
> Thanks for explanation!
> 
>> That was probably the reason for the pci_read_config_word in the reg_write
>> code. Try putting that back (and just that).
> 
> In this case reg_write becomes not atomic, thus spinlock would be
> required again here, right?

That depends on whether you can have calls to this function in parallel.

But I get the feeling that it might be easier to just revert the patch.

Regards,

	Hans
