Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mycable.de ([46.4.59.52]:38418 "EHLO mail.mycable.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbeLCILm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 03:11:42 -0500
Received: from localhost (localhost [IPv6:::1])
        by mail.mycable.de (Postfix) with ESMTP id AACAE4C80732
        for <linux-media@vger.kernel.org>; Mon,  3 Dec 2018 09:02:21 +0100 (CET)
Received: from mail.mycable.de ([IPv6:::1])
        by localhost (mail.mycable.de [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id vG-aMHw2N1ca for <linux-media@vger.kernel.org>;
        Mon,  3 Dec 2018 09:02:21 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.mycable.de (Postfix) with ESMTP id 62E634C80747
        for <linux-media@vger.kernel.org>; Mon,  3 Dec 2018 09:02:21 +0100 (CET)
Received: from mail.mycable.de ([IPv6:::1])
        by localhost (mail.mycable.de [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id mde2SOzTWYJZ for <linux-media@vger.kernel.org>;
        Mon,  3 Dec 2018 09:02:21 +0100 (CET)
Received: from mail.mycable.de (mail.mycable.de [46.4.59.52])
        by mail.mycable.de (Postfix) with ESMTP id 4D2964C80732
        for <linux-media@vger.kernel.org>; Mon,  3 Dec 2018 09:02:21 +0100 (CET)
Date: Mon, 3 Dec 2018 09:02:21 +0100 (CET)
From: Sebastian =?utf-8?Q?S=C3=BCsens?= <su@mycable.de>
To: linux-media@vger.kernel.org
Message-ID: <927806392.2404.1543824141142.JavaMail.zimbra@mycable.de>
Subject: v4l controls API
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I don't know how to get access to the v4l controls on a I2C camera sensor.

My driver structure looks following:

bridge driver                            -> csi-driver                                  -> sensor driver (includes controls)
register-async-notifer for csi driver        register-async-notifer for sensor driver
register video device

The v4l2 API say:
When a sub-device is registered with a V4L2 driver by calling v4l2_device_register_subdev() and the ctrl_handler fields of both v4l2_subdev and v4l2_device are set, then the controls of the subdev will become automatically available in the V4L2 driver as well. If the subdev driver contains controls that already exist in the V4L2 driver, then those will be skipped (so a V4L2 driver can always override a subdev control).

But how can I get access to the controls by asynchronous registration, because the controls are not added to the video device automatically?

Normally I can use:

v4l2-ctl -l -d /dev/video0

I don't know if this forum is the right place for this question, so please answer with a private e-mail su@mycable.de

------------------------------------------------------------------------
   Sebastian Süsens               Tel.   +49 4321 559 56-27
   mycable GmbH                   Fax    +49 4321 559 56-10
   Gartenstrasse 10
   24534 Neumuenster, Germany     Email  su@mycable.de
------------------------------------------------------------------------
   mycable GmbH, Managing Director: Michael Carstens-Behrens
   USt-IdNr: DE 214 231 199, Amtsgericht Kiel, HRB 1797 NM
------------------------------------------------------------------------
   This e-mail and any files transmitted with it are confidential and
   intended solely for the use of the individual or entity to whom
   they are addressed. If you have received this e-mail in error,
   please notify the sender and delete all copies from your system.
------------------------------------------------------------------------
