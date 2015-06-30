Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:33764 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbbF3He3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2015 03:34:29 -0400
Received: by laar3 with SMTP id r3so2299624laa.0
        for <linux-media@vger.kernel.org>; Tue, 30 Jun 2015 00:34:27 -0700 (PDT)
MIME-Version: 1.0
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 30 Jun 2015 09:34:08 +0200
Message-ID: <CAPybu_2dTaf_RF2NR1mSqzW5=Hw0m+Ngm=UxE5T-VNKfCeHcrg@mail.gmail.com>
Subject: subdev: fps enum_frame_interval
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I have a subdevice that can produce images at a programmable interval,
i.e. at different fps.

I was using the callback enum_frameintervals to "negotiate" the frame
rate, but since 4.1 it is gone in favor of enum_frame_interval.


enum_frame_interval, seems to only return one value for fps. How can I
make the bridge driver aware of the possible fps?

Regards!!!

-- 
Ricardo Ribalda
