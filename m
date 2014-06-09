Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:46990 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaFIIWY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jun 2014 04:22:24 -0400
Received: by mail-wi0-f173.google.com with SMTP id bs8so3783454wib.12
        for <linux-media@vger.kernel.org>; Mon, 09 Jun 2014 01:22:23 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 9 Jun 2014 13:52:22 +0530
Message-ID: <CAO-sSBvUGw56E15j9h_T+mBkF6Veu4GwFqTzPmA_qZAei3r90g@mail.gmail.com>
Subject: V4L2 endpoint parser doesn't support empty ports
From: Nikhil Devshatwar <niksdevice@gmail.com>
To: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	g.liakhovetski@gmx.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyboady,

When using V4l2 endpoint framework for parsing device tree nodes,

I don't find any API which can allow me to iterate over all the
endpoints in a specific port

Currectly we have v4l2_of_get_next_endpoint which can be used to
iterate over all the endpoints
under that device_node

Typically, SoCs have multiple video ports in a video IP
We want a way to iterate over only the endpoints which belong to a certain port
It isn't possible with this

Also, Ideally, all the port definitions are in DTSI file whereas the
endpoints would be defined
in a DTS file overriding the port nodes

So it is quite possible that we have some ports where nothing is connected,
v4l2_of_get_next_endpoint fails as soon as it gets the empty endpoint

2 questions
=> Should we modify the v4l2_of_get_next_endpoint function to ignore
empty endpoints?
=> Does it make sense to create a new function which can iterate over
a specific port?

Thanks,
Nikhil D
