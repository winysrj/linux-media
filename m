Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43331 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaBTVVD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 16:21:03 -0500
Received: by mail-ee0-f46.google.com with SMTP id c13so1207077eek.19
        for <linux-media@vger.kernel.org>; Thu, 20 Feb 2014 13:21:01 -0800 (PST)
Message-ID: <530671BB.107@gmail.com>
Date: Thu, 20 Feb 2014 22:20:59 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	k.debski@samsung.com
Subject: Re: [PATCH v5.1 3/7] v4l: Add timestamp source flags, mask and document
 them
References: <20140217232931.GW15635@valkosipuli.retiisi.org.uk> <1392925276-20412-1-git-send-email-sakari.ailus@iki.fi> <53066763.3070000@xs4all.nl> <53066F5E.7020202@gmail.com>
In-Reply-To: <53066F5E.7020202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/20/2014 10:10 PM, Sylwester Nawrocki wrote:
>> I would actually be inclined to drop it altogether for this particular
>> timestamp source. But it's up to Laurent.
>
> Yup, the "a small amount of time" concept seems a bit vague here.
> It's not clear how long period it could be and the tolerance would like
> very across the hardware.

Sorry, I meant "would likely vary".
