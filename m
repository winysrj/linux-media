Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36365 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1LaG5c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 01:57:32 -0500
Received: by vbbfc26 with SMTP id fc26so11148542vbb.19
        for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 22:57:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111230213301.GA3677@valkosipuli.localdomain>
References: <CAHG8p1Ao8UDuCytunFjvGZ1Ugd_xVU9cf_iXv6YjcRD41aMYtw@mail.gmail.com>
	<20111230213301.GA3677@valkosipuli.localdomain>
Date: Sat, 31 Dec 2011 14:57:31 +0800
Message-ID: <CAHG8p1ACi7CGFEBVaSr5G1cUMqtH8wX2mRY6n1yKF8TqgJ0oYw@mail.gmail.com>
Subject: Re: v4l: how to get blanking clock count?
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/12/31 Sakari Ailus <sakari.ailus@iki.fi>:
> Hi Scott,
>
> On Fri, Dec 30, 2011 at 03:20:43PM +0800, Scott Jiang wrote:
>> Hi Hans and Guennadi,
>>
>> Our bridge driver needs to know line clock count including active
>> lines and blanking area.
>> I can compute active clock count according to pixel format, but how
>> can I get this in blanking area in current framework?
>
> Such information is not available currently over the V4L2 subdev interface.
> Please see this patchset:
>
> <URL:http://www.spinics.net/lists/linux-media/msg41765.html>
>
> Patches 7 and 8 are probably the most interesting for you. This is an RFC
> patchset so the final implementation could well still change.
>
Hi Sakari,

Thanks for your reply. Your patch added VBLANK and HBLANK control, but
my case isn't a user control.
That is to say, you can't specify a blanking control value for sensor.
And you added pixel clock rate in mbus format, I think if I add two
more parametres such as VBLANK lines and HBLANK clocks I can solve
this problem. In fact, active lines and blanking lines are essential
params to define an image.

Regards,
Scott
