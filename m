Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:49967 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3AVVmI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 16:42:08 -0500
Received: by mail-ee0-f54.google.com with SMTP id c41so3776824eek.41
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2013 13:42:07 -0800 (PST)
Message-ID: <50FF07AD.5060506@gmail.com>
Date: Tue, 22 Jan 2013 22:42:05 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/3] [media] Add header file defining standard image sizes
References: <1358630842-12689-1-git-send-email-sylvester.nawrocki@gmail.com> <1358630842-12689-2-git-send-email-sylvester.nawrocki@gmail.com> <201301211001.55354.hverkuil@xs4all.nl>
In-Reply-To: <201301211001.55354.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/21/2013 10:01 AM, Hans Verkuil wrote:
> On Sat January 19 2013 22:27:20 Sylwester Nawrocki wrote:
>> Add common header file defining standard image sizes, so we can
>> avoid redefining those in each driver.
>>
>> Signed-off-by: Sylwester Nawrocki<sylvester.nawrocki@gmail.com>
>> ---
>>   include/media/image-sizes.h |   34 ++++++++++++++++++++++++++++++++++
>
> Since this is a v4l2 core header it should be renamed with a 'v4l2-' prefix.

OK, I'll rename it. I just thought these definitions could be used outside
v4l2 and didn't prefix it with v4l2- originally.

--

Regards,
Sylwester
