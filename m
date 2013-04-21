Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab3DUJad (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 05:30:33 -0400
Message-ID: <5173B1B4.2030500@redhat.com>
Date: Sun, 21 Apr 2013 06:30:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC v1] Add SDR at V4L2 API
References: <1366469499-31640-1-git-send-email-mchehab@redhat.com> <51730C2A.90005@schinagl.nl> <5173AE70.4050803@schinagl.nl>
In-Reply-To: <5173AE70.4050803@schinagl.nl>
Content-Type: text/plain; charset=true; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-04-2013 06:16, Oliver Schinagl escreveu:
> On 04/20/13 23:44, Oliver Schinagl wrote:
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Not sure what happened there, I know I typed a bit more then that :p

:)

> What I was wondering, how relevant the name will be with extensions like SDR.
>Maybe for V4l3 it could be renamed to M4L (Media for Linux)? Since Video would
>  imply only video, not even audio let alone radio. I know it's just a name so who cares right?

Since very early, radio support was part of V4L. Not sure why this was
not renamed on V4L on that time, but it is now too late to change it, as
it would require an entire renaming at the core and at userspace API
with no technical gain.

With regards to a V4L3, I prefer if we never do that... radical changes
like that mean a lot of hard work. We took ~10 years to finish the
transition from V4L1 to V4L2. It is easier to just extend it where
it needed than to rewrite it from scratch.

Regards,
Mauro

