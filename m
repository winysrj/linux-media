Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34077 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab2CIPzZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 10:55:25 -0500
Received: by yhmm54 with SMTP id m54so908943yhm.19
        for <linux-media@vger.kernel.org>; Fri, 09 Mar 2012 07:55:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2243690.V1TtfkZKP0@avalon>
References: <CAGGh5h0dVOsT-PCoCBtjj=+rLzViwnM2e9hG+sbWQk5iS-ThEQ@mail.gmail.com>
	<2747531.0sXdUv33Rd@avalon>
	<CAGGh5h13mOVtWPLGowvtvZM1Ufx2PST3DCokJzspGFcsUo=FiA@mail.gmail.com>
	<2243690.V1TtfkZKP0@avalon>
Date: Fri, 9 Mar 2012 16:55:24 +0100
Message-ID: <CAGGh5h1TB-=YqM0m-xbC7q7Y-AtzxYAhm+wUGSqTeO51PA25aA@mail.gmail.com>
Subject: Re: Lockup on second streamon with omap3-isp
From: jean-philippe francois <jp.francois@cynove.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Thank you, I will try this and keep you posted.
>> With this sensor it is possible, but that is not the case for every
>> sensor out there.
>> Is this an ISP bug ?
>
> From my experience, the ISP doesn't handle free-running sensors very well.
> There are other things it doesn't handle well, such as sensors stopping in the
> middle of the frame. I would consider this as limitations.
>
> This shouldn't cause any interrupt storm though, but I'd like you to check
> just in case. Floating HS/VS signals that would happen to oscillate near the
> logic threshold voltage is my main guess for your problem.

Unless there is a soldering problem, this is not the case. Oscilloscope
traces look fine. And I would not get images out of the driver if
Hsync / Vsync was
garbage. Anyway, stopping / restarting the sensor removes the bug symptom,
thanks a lot for this hint.

>
>> It never happens on first start, ie before ccdc_configure is called
>> for the first time.
>> Is there a way to eventually handle this in the driver ?
>
> Let's first find out where the problam comes from exactly.
>
If it's an interrupt storm, I should be able to printk debug it,
I will keep you posted.

Jean-Philippe François
