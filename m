Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2035 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZCLJ2Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 05:28:25 -0400
Message-ID: <50906.62.70.2.252.1236850101.squirrel@webmail.xs4all.nl>
Date: Thu, 12 Mar 2009 10:28:21 +0100 (CET)
Subject: Re: disable v4l2-ctl logging --log-status in /var/log/messages
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Gregor Fuis" <gujs.lists@gmail.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hello,
>
> Is it possible to disable v4l2-ctl aplication logging into
> /var/log/messages.
> I am using it to control and monitor my PVR 150 cards and every time I
> run v4l2-ctl -d /dev/video0 --log-status all output is logged into
> /var/log/messages and some other linux log files.

All --log-status does is to tell the driver to show it's status in the
kernel log for debugging purposes. It cannot and should not be relied upon
for monitoring/controlling a driver.

What do you need it for anyway?

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

