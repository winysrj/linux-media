Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50946 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1L3HUo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 02:20:44 -0500
Received: by vcbfk14 with SMTP id fk14so10531332vcb.19
        for <linux-media@vger.kernel.org>; Thu, 29 Dec 2011 23:20:43 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 30 Dec 2011 15:20:43 +0800
Message-ID: <CAHG8p1Ao8UDuCytunFjvGZ1Ugd_xVU9cf_iXv6YjcRD41aMYtw@mail.gmail.com>
Subject: v4l: how to get blanking clock count?
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Guennadi,

Our bridge driver needs to know line clock count including active
lines and blanking area.
I can compute active clock count according to pixel format, but how
can I get this in blanking area in current framework?

Thanks,
Scott
