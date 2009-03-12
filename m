Return-path: <linux-media-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:36024 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZCLJtT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 05:49:19 -0400
Received: by fk-out-0910.google.com with SMTP id f33so49302fkf.5
        for <linux-media@vger.kernel.org>; Thu, 12 Mar 2009 02:49:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50906.62.70.2.252.1236850101.squirrel@webmail.xs4all.nl>
References: <50906.62.70.2.252.1236850101.squirrel@webmail.xs4all.nl>
Date: Thu, 12 Mar 2009 10:49:16 +0100
Message-ID: <23be820f0903120249n70778ddbh28c04286099cfc5b@mail.gmail.com>
Subject: Re: disable v4l2-ctl logging --log-status in /var/log/messages
From: Gregor Fuis <gujs.lists@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 12, 2009 at 10:28 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> Hello,
>>
>> Is it possible to disable v4l2-ctl aplication logging into
>> /var/log/messages.
>> I am using it to control and monitor my PVR 150 cards and every time I
>> run v4l2-ctl -d /dev/video0 --log-status all output is logged into
>> /var/log/messages and some other linux log files.
>
> All --log-status does is to tell the driver to show it's status in the
> kernel log for debugging purposes. It cannot and should not be relied upon
> for monitoring/controlling a driver.
>
> What do you need it for anyway?

I am just monitoring if signal is present on tuner, and what signal
format is detected.
These two lines:
cx25840 1-0044: Video signal:              not present
cx25840 1-0044: Detected format:           PAL-Nc
I run this every minute and it is really annoying to have all this in
my system logs.
Is it possible to modify v4l2-ctl source to disable system logging?

Regards,
Gregor
