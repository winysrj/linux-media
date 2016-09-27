Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:35118 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755277AbcI0Ldz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Sep 2016 07:33:55 -0400
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
        <m3ponri5ky.fsf@t19.piap.pl> <20160926091831.cp6qkv77oo5tinn5@zver>
        <m337kldi92.fsf@t19.piap.pl> <20160927074009.3kcvruynnapj6y3q@zver>
Date: Tue, 27 Sep 2016 13:33:49 +0200
In-Reply-To: <20160927074009.3kcvruynnapj6y3q@zver> (Andrey Utkin's message of
        "Tue, 27 Sep 2016 10:40:09 +0300")
Message-ID: <m3y42dbmqq.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrey Utkin <andrey_utkin@fastmail.com> writes:

>> Can you share some details about the machine you are experiencing the
>> problems on? CPU, chipset? I'd try to see if I can recreate the problem.
>
> See solo.txt.gz attached.

Thanks. I can see you have quite a set of video devices there.
I will see what I can do with this.

BTW does the lookup occur on SOLO6010, 6110, or both?
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
