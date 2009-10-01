Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.216.179]:51286 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbZJAHNL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2009 03:13:11 -0400
Received: by pxi9 with SMTP id 9so7250007pxi.5
        for <linux-media@vger.kernel.org>; Thu, 01 Oct 2009 00:13:15 -0700 (PDT)
Message-ID: <4AC454E1.9070104@gmail.com>
Date: Thu, 01 Oct 2009 15:06:09 +0800
From: "David T. L. Wong" <davidtlwong@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: BUG: cx23885_video_register() uninitialized value passed to v4l2_subdev_call()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

   A potential bug is found in cx23885_video_register().

   A tuner_setup struct is passed to v4l2_subdev_call(),
but that struct is not fully initialized, especially for tuner_callback 
member, and eventually tuner_s_type_addr() copy that wrong pointer.
It would particularly cause seg. fault for xc5000 tuner for analog 
frontend when it calls fe->callback at xc5000_TunerReset().


Regards,
David T.L. Wong
