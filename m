Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:36470 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762AbaGYSYS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 14:24:18 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so4564116wgh.34
        for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 11:24:17 -0700 (PDT)
Message-ID: <53D2A115.5010209@googlemail.com>
Date: Fri, 25 Jul 2014 20:25:25 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: v4l2-ctrls: negative integer control values broken
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

sorry for bothering you with another issue on friday evening. :-/
But it seems that commit 958c7c7e65 ("[media] v4l2-ctrls: fix corner
case in round-to-range code") introduced a regression for controls which
are using a negative integer value range.
All negative values are mapped to the maximum (positive) value (check
em28xx brightness, red and blue balance bridge controls for example).
Reverting this commit makes them working again.
At a first glance I can't find a mistake...

Have a nice weekend,
Frank

