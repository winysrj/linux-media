Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:61291 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbaE3Mo0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 May 2014 08:44:26 -0400
Received: by mail-ig0-f172.google.com with SMTP id uy17so728770igb.17
        for <linux-media@vger.kernel.org>; Fri, 30 May 2014 05:44:26 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 30 May 2014 14:44:26 +0200
Message-ID: <CAHqFTYrnru=b9MhuzRHbY8hk8Y149N2nb3Oj2e8p3cc9NP9bJw@mail.gmail.com>
Subject: v4l2_device_register_subdev_nodes() clean_up code
From: Krzysztof Czarnowski <khczarnowski@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

In "clean_up:" section of v4l2_device_register_subdev_nodes() we have:

    if (!sd->devnode)
        break;

Maybe I miss something, but shouldn't it be rather "continue" instead
of "break"?

Regards,
Krzysztof
