Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:40996 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932956AbdEXPoz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 May 2017 11:44:55 -0400
Received: from [192.168.10.79] (pd95c9a6f.dip0.t-ipconnect.de [217.92.154.111])
        by mail.bugwerft.de (Postfix) with ESMTPSA id 8417028040A
        for <linux-media@vger.kernel.org>; Wed, 24 May 2017 15:36:12 +0000 (UTC)
To: linux-media@vger.kernel.org
From: Daniel Mack <daniel@zonque.org>
Subject: Composite MIPI camera devices
Message-ID: <97392400-9a22-8e7b-95e2-f7e9f5163eaf@zonque.org>
Date: Wed, 24 May 2017 17:36:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

On an embedded board I'm working on, I need to interface a camera that
exposes three distinct I2C addresses: one for the imaging sensor
(OmniVision), one focus motor driver and one EEPROM. Usually such
cameras hide their complexity behind one common interface, but this one
just leaves that to the user.

I wonder what is the best way to support such a device under Linux. I'm
currently at the point where I have drivers for the imaging sensor and
for the focus motor, but I somehow need to link them, both in devicetree
and in the v4l userspace API. Is it possible to make a v4l2_subdev a
child of another v4l2_subdev or something? I guess an alternative would
be to offload certain functionality (V4L2_CID_FOCUS_ABSOLUTE) from the
image sensor driver to the motor driver, but I don't enough about the
v4l2 implementation details. Have similar devices been supported in the
past?

About the userspace side, is there any support for handling the focus
(setting focus to a certain point etc) in a convenient way?

I'd be grateful for any pointer.


Thank you,
Daniel
