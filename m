Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:58708 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752313AbcIZFiK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Sep 2016 01:38:10 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>
Subject: Re: solo6010 modprobe lockup since e1ceb25a (v4.3 regression)
References: <20160915130441.ji3f3jiiebsnsbct@acer>
        <9cbb2079-f705-5312-d295-34bc3c8dadb9@xs4all.nl>
        <m3k2e5wfxy.fsf@t19.piap.pl> <20160921134554.s3tdolyej6r2w5wh@zver>
        <m360powc4m.fsf@t19.piap.pl> <20160922152356.nhgacxprxtvutb67@zver>
Date: Mon, 26 Sep 2016 07:38:05 +0200
In-Reply-To: <20160922152356.nhgacxprxtvutb67@zver> (Andrey Utkin's message of
        "Thu, 22 Sep 2016 18:23:56 +0300")
Message-ID: <m3ponri5ky.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrey Utkin <andrey_utkin@fastmail.com> writes:

> On Thu, Sep 22, 2016 at 10:51:37AM +0200, Krzysztof Hałasa wrote:
>> I wonder if the following fixes the problem (completely untested).
>
> I have given this a run, and it still hangs.

Does (only) adding the

	pci_read_config_word(solo_dev->pdev, PCI_STATUS, &val);

in solo_reg_write() help?
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
