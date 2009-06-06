Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1044 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbZFFNBC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2009 09:01:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-i2c@vger.kernel.org, linux-media@vger.kernel.org
Subject: RFC: proposal for new i2c.h macro to initialize i2c address lists on the fly
Date: Sat, 6 Jun 2009 15:00:48 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906061500.49338.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

For video4linux we sometimes need to probe for a single i2c address. 
Normally you would do it like this:

static const unsigned short addrs[] = {
	addr, I2C_CLIENT_END
};

client = i2c_new_probed_device(adapter, &info, addrs);

This is a bit awkward and I came up with this macro:

#define V4L2_I2C_ADDRS(addr, addrs...) \
        ((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END })

This can construct a list of one or more i2c addresses on the fly. But this 
is something that really belongs in i2c.h, renamed to I2C_ADDRS.

With this macro we can just do:

client = i2c_new_probed_device(adapter, &info, I2C_ADDRS(addr));

Comments?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
