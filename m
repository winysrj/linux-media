Return-path: <linux-media-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35441 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933214AbcI0OWx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Sep 2016 10:22:53 -0400
Date: Tue, 27 Sep 2016 17:22:44 +0300
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
Message-ID: <20160927142244.rocwg36f2bsfl3n6@zver>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3y42dbmqq.fsf@t19.piap.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 27, 2016 at 01:33:49PM +0200, Krzysztof Hałasa wrote:
> Thanks. I can see you have quite a set of video devices there.
> I will see what I can do with this.

Yeah, I have got also 4-chip tw5864 board here :)
Bluecherry decided to switch to it because they are available for retail
purchase, unlike solo* which must be ordered in large batch. It was huge
reverse-engineering effort to make it work, though, and there are still
issues with H.264 encoding functionality, and audio functionality is not
done yet.

> BTW does the lookup occur on SOLO6010, 6110, or both?

Lockup happens only on 6010. In provided log you can see that 6110
passes just fine right before 6010. Also if 6010 PCI ID is removed from
solo6x10 driver's devices list, the freeze doesn't happen.
