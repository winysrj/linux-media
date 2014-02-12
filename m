Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:57495 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaBLR7B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 12:59:01 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so4430534eei.21
        for <linux-media@vger.kernel.org>; Wed, 12 Feb 2014 09:59:00 -0800 (PST)
Message-ID: <52FBB6BC.7030102@googlemail.com>
Date: Wed, 12 Feb 2014 19:00:28 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2] em28xx: Only deallocate struct em28xx after finishing
 all extensions
References: <1389567649-26838-4-git-send-email-m.chehab@samsung.com> <1389721013-20231-1-git-send-email-m.chehab@samsung.com> <52D6F9E8.1010702@googlemail.com> <52F7CBC5.4030207@googlemail.com> <20140210050920.45b4c0c7.m.chehab@samsung.com>
In-Reply-To: <20140210050920.45b4c0c7.m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 09.02.2014 21:09, schrieb Mauro Carvalho Chehab:
>> Ping !
>> > Are you going to continue working on this patch ?
>> > I've planned to come up with some follow-up changes... ;-)
> Yes, but I'm currently without time to do your proposal changes and
> test, as I'm in a 2-week business trip. I didn't bring any test machine.
Ok, good to know.

> If you want, I can commit this one as-is, and you can do your
> proposed changes on a separate patch.
No problem, I can wait.
The current version of the patch would reintroduce the sysfs group
warnings, so I think its safer to do the changes all at once.

Regards,
Frank
