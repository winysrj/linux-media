Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f52.google.com ([209.85.167.52]:44343 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbeIURG5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 13:06:57 -0400
Received: by mail-lf1-f52.google.com with SMTP id g24-v6so11108820lfb.11
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 04:18:31 -0700 (PDT)
MIME-Version: 1.0
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 21 Sep 2018 13:18:13 +0200
Message-ID: <CAPybu_1TqPwP__rSONnUgLUXS23RFf1syEYvX93mCQ_fvu4e7w@mail.gmail.com>
Subject: Power Management and lens-focus
To: linux-media <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I have started using the lens-focus property:

ad5820: dac@0c {
compatible = "adi,ad5820";
reg = <0x0c>;
VANA-supply = <&pm8994_l23>;
enable-gpios = <&msmgpio 26 GPIO_ACTIVE_HIGH>;
};

camera_rear@60 {
lens-focus = <&ad5820>;
};

I was testing my device using the following setup: qv4l2 grabbing
images and yavta changing the focus controls.

Unfortunately, this does not work (or does not work as I expected):
The ad5820 is powered off until it is open() (even during streamon),
so when yavta finished setting the control and closed the device the
focus was back to its original position :S.

Apparently, this has not been an issue before because usually there is
a close loop program constantly setting up the focus and not closing
the device.

Shouldn't we poweron the focus when the pipeline is running?

Regards!



-- 
Ricardo Ribalda
