Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59774 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2FMWa0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 18:30:26 -0400
Received: by wibhm6 with SMTP id hm6so5857670wib.1
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2012 15:30:25 -0700 (PDT)
Message-ID: <4FD9147E.6010202@gmail.com>
Date: Thu, 14 Jun 2012 00:30:22 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 3/4] v4l: Unify selection targets across V4L2 and V4L2
 subdev interfaces
References: <4FD4F6B6.1070605@iki.fi> <1339356878-2179-3-git-send-email-sakari.ailus@iki.fi> <4FD720AC.8000906@gmail.com> <4FD90217.2060403@iki.fi> <4FD908AD.3010202@gmail.com> <4FD90AE4.9010306@iki.fi>
In-Reply-To: <4FD90AE4.9010306@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2012 11:49 PM, Sakari Ailus wrote:
>>
>> In case you wanted to compile test those changes, I've attached
>> kernel config file for exynos4.
>
> Compile testing? What is that? :-)

I don't practise it myself, but it's still better than making
random changes in the kernel and not checking if possibly affected
parts are still building :D

> I'll check that before sending the pull req.

OK, it just might be useful in future when you decide to make
any further API changes.

--
Regards,
Sylwester
