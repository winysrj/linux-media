Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:45341 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbbATI7M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 03:59:12 -0500
Received: by mail-wg0-f49.google.com with SMTP id l18so10317878wgh.8
        for <linux-media@vger.kernel.org>; Tue, 20 Jan 2015 00:59:10 -0800 (PST)
Message-ID: <54BE18DE.2050206@gmail.com>
Date: Tue, 20 Jan 2015 09:59:10 +0100
From: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [media_build] commit 26052b8e1 (SMIAPP needs kernel 3.20 or up.)
References: <54BD3C56.4070600@xs4all.nl> <54BD55C3.6080201@gmail.com> <54BE052F.6060205@xs4all.nl>
In-Reply-To: <54BE052F.6060205@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested again, works now.
Thanks!
Op 20-01-15 om 08:35 schreef Hans Verkuil:
> On 01/19/2015 08:06 PM, Tycho Lürsen wrote:
>> Hi Hans,
>>
>> tested this update in media_build against a Debian 3.16 kernel.
>> It still tries to build SMIAPP. So sadly it still gives the same error.
> Try again. I missed a duplicate VIDEO_SMIAPP entry in versions.txt that is
> now deleted. I just tried it and it now builds fine for me.
>
> Regards,
>
> 	Hans

