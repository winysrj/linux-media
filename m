Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f54.google.com ([209.85.128.54]:54112 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbeI1T1q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 15:27:46 -0400
Received: by mail-wm1-f54.google.com with SMTP id b19-v6so2148143wme.3
        for <linux-media@vger.kernel.org>; Fri, 28 Sep 2018 06:04:04 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linux-media@vger.kernel.org, hans.verkuil@cisco.com
Cc: Andrea Merello <andrea.merello@gmail.com>
Subject: Re: [RFC,1/3] cpia2: move to staging in preparation for removal
Date: Fri, 28 Sep 2018 15:03:58 +0200
Message-Id: <20180928130358.15470-1-andrea.merello@gmail.com>
In-Reply-To: <20180513110525.20062-2-hverkuil@xs4all.nl>
References: <20180513110525.20062-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I do often use this driver, and I'm interested in working on it for preventing it from being removed.

I can perform functional test with my HW (usb microscope) on a kernel from current media tree (anyway currently it works on my box with a pretty recent kernel).

How much effort is expected to be required to port it to vb2? I'm currently hacking on another (recent) v4l2 subdev driver, but my wknowledge of the v4l2/media framework is far from good.. If someone give me some directions then I can try to do that..
