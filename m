Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:35511
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754740AbcJXTcl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Oct 2016 15:32:41 -0400
Date: Mon, 24 Oct 2016 17:32:33 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: khalasa@piap.pl (Krzysztof =?UTF-8?B?SGHFgmFzYQ==?=)
Cc: Andrey Utkin <andrey_utkin@fastmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>
Subject: Re: solo6010 modprobe lockup since e1ceb25a (v4.3 regression)
Message-ID: <20161024173233.5daabac4@vento.lan>
In-Reply-To: <m3ponobnvb.fsf@t19.piap.pl>
References: <9cbb2079-f705-5312-d295-34bc3c8dadb9@xs4all.nl>
        <m3k2e5wfxy.fsf@t19.piap.pl>
        <20160921134554.s3tdolyej6r2w5wh@zver>
        <m360powc4m.fsf@t19.piap.pl>
        <20160922152356.nhgacxprxtvutb67@zver>
        <m3ponri5ky.fsf@t19.piap.pl>
        <20160926091831.cp6qkv77oo5tinn5@zver>
        <m337kldi92.fsf@t19.piap.pl>
        <20160927074009.3kcvruynnapj6y3q@zver>
        <m3y42dbmqq.fsf@t19.piap.pl>
        <20160927142244.rocwg36f2bsfl3n6@zver>
        <m3ponobnvb.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 28 Sep 2016 07:21:44 +0200
khalasa@piap.pl (Krzysztof Hałasa) escreveu:

> Andrey Utkin <andrey_utkin@fastmail.com> writes:
> 
> > Lockup happens only on 6010. In provided log you can see that 6110
> > passes just fine right before 6010. Also if 6010 PCI ID is removed from
> > solo6x10 driver's devices list, the freeze doesn't happen.  
> 
> Probably explains why I don't see lockups :-)
> 
> I will have a look.

Any news on this? Should the patch be applied or not? If not, are there
any other patch to fix this regression?

Thanks,
Mauro
