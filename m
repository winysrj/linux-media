Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:34326 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390AbbAMIyy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 03:54:54 -0500
Message-ID: <54B4DD2D.7030303@xs4all.nl>
Date: Tue, 13 Jan 2015 09:54:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: smiapp-core.c error if !defined(CONFIG_OF)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

The daily build fails because of this error:

media_build/v4l/smiapp-core.c: In function 'smiapp_get_pdata':
media_build/v4l/smiapp-core.c:3061:3: error: implicit declaration of function 'of_read_number' [-Werror=implicit-function-declaration]
   pdata->op_sys_clock[i] = of_read_number(val + i * 2, 2);
   ^

Some digging showed that of_read_number is only available if CONFIG_OF
is defined. As far as I can see that is actually a bug in linux/of.h, as
I see no reason why it should be under CONFIG_OF.

Can you look at this?

Regards,

	Hans
