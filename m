Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:34416 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751699AbcI1FVu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 01:21:50 -0400
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
References: <9cbb2079-f705-5312-d295-34bc3c8dadb9@xs4all.nl>
        <m3k2e5wfxy.fsf@t19.piap.pl> <20160921134554.s3tdolyej6r2w5wh@zver>
        <m360powc4m.fsf@t19.piap.pl> <20160922152356.nhgacxprxtvutb67@zver>
        <m3ponri5ky.fsf@t19.piap.pl> <20160926091831.cp6qkv77oo5tinn5@zver>
        <m337kldi92.fsf@t19.piap.pl> <20160927074009.3kcvruynnapj6y3q@zver>
        <m3y42dbmqq.fsf@t19.piap.pl> <20160927142244.rocwg36f2bsfl3n6@zver>
Date: Wed, 28 Sep 2016 07:21:44 +0200
In-Reply-To: <20160927142244.rocwg36f2bsfl3n6@zver> (Andrey Utkin's message of
        "Tue, 27 Sep 2016 17:22:44 +0300")
Message-ID: <m3ponobnvb.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrey Utkin <andrey_utkin@fastmail.com> writes:

> Lockup happens only on 6010. In provided log you can see that 6110
> passes just fine right before 6010. Also if 6010 PCI ID is removed from
> solo6x10 driver's devices list, the freeze doesn't happen.

Probably explains why I don't see lockups :-)

I will have a look.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
