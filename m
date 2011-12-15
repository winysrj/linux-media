Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:65309 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1LOKGL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 05:06:11 -0500
Received: by vcbfk14 with SMTP id fk14so1360007vcb.19
        for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 02:06:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201112151054.29905.hverkuil@xs4all.nl>
References: <CAHG8p1A93tTu9Nz1s9ngDrMCRC98A3RVecYFSsrEHsU-zr_b2A@mail.gmail.com>
	<201112151054.29905.hverkuil@xs4all.nl>
Date: Thu, 15 Dec 2011 18:06:10 +0800
Message-ID: <CAHG8p1DoC5VdxmXCZTfLVouvay51=QSN2UpppCEEr9B7BY8+tA@mail.gmail.com>
Subject: Re: v4l: How bridge driver get subdev std?
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/12/15 Hans Verkuil <hverkuil@xs4all.nl>:
> On Thursday, December 15, 2011 10:48:39 Scott Jiang wrote:
>> Hi Hans and Guennadi,
>>
>> I'm wondering how does bridge driver get subdev std (not query)?
>> My case is that bridge needs to get subdev default std.
>
> It can just call the core g_std op. Note that g_std was added only recently
> (September 9th according to the git log), so if you work with an older kernel,
> then it may not be there yet.
>
Thanks. I found it in latest kernel.

Scott
