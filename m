Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34164 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdEQTAh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 15:00:37 -0400
Received: by mail-oi0-f48.google.com with SMTP id b204so27307542oii.1
        for <linux-media@vger.kernel.org>; Wed, 17 May 2017 12:00:36 -0700 (PDT)
MIME-Version: 1.0
From: Patrick Doyle <wpdster@gmail.com>
Date: Wed, 17 May 2017 14:51:47 -0400
Message-ID: <CAF_dkJB_0dF9Pg0dgDQ_Oc9SbNPtWf4fH56Rojm8TewxhFNNqg@mail.gmail.com>
Subject: Adding a cropping capability to the atmel-isc driver
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From reading the discussion of the comparison of the selection API
with the cropping API, (at
https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/selection-api-005.html)
it seems that the cropping API has been deprecated in favor of the
selection API, so if I want to add a cropping capability to the
atmel-isc, I should look at adding support for vidio_g_selection and
vidio_s_selction to the driver.

How do I manage the fact that the video frame size (from which I
should derive TGT_CROP_BOUNDS, TGT_CROP_DEFAULT, and perhaps even
TGT_NATIVE_SIZE) must be specified by atmel-isc's sub device?  Should
I v4l2subdev_call the get_selection function of the underlying sensor?

Is that what is typically done?  Or is there a better way to do this?

--wpd
