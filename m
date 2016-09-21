Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:59596 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932964AbcIUN0O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 09:26:14 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        andrey_utkin@fastmail.com
Subject: Re: solo6010 modprobe lockup since e1ceb25a (v4.3 regression)
References: <20160915130441.ji3f3jiiebsnsbct@acer>
        <9cbb2079-f705-5312-d295-34bc3c8dadb9@xs4all.nl>
Date: Wed, 21 Sep 2016 15:16:57 +0200
In-Reply-To: <9cbb2079-f705-5312-d295-34bc3c8dadb9@xs4all.nl> (Hans Verkuil's
        message of "Thu, 15 Sep 2016 15:15:53 +0200")
Message-ID: <m3k2e5wfxy.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> That was probably the reason for the pci_read_config_word in the reg_write
> code. Try putting that back (and just that).

Yes. I guess a single pci_read_config_word() would suffice.

Though it would obviously be much better to identify the place in the
driver which needs to have the write buffers flushed, and add a read()
just there.

The interrupt handler maybe (e.g. just before the return IRQ_HANDLED)?

OTOH this may be some sort of timing problem, I mean the faster code may
put too much stress on the SOLO chip.

Doesn't happen here so I can't test the cure.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
