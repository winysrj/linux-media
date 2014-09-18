Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:62000 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbaIRPvm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 11:51:42 -0400
Received: by mail-wi0-f173.google.com with SMTP id em10so3385064wid.12
        for <linux-media@vger.kernel.org>; Thu, 18 Sep 2014 08:51:41 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 18 Sep 2014 17:51:41 +0200
Message-ID: <CAL9G6WXe27sk-aM-+SDQYdrtywXBw11dd9V-vvpvNYGBK8SEBw@mail.gmail.com>
Subject: smsusb_onresponse error
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

I have Hauppauge WinTV-MiniStick in a Debian Wheezy (3.2 kernel), I
notice that I have lots of firmware errors in dmesg:

# dmesg | grep smsusb
[    6.717599] usbcore: registered new interface driver smsusb
[63792.528700] smsusb_onresponse: line: 118: error, urb status -75, 0 bytes
[63792.528949] smsusb_onresponse: line: 118: error, urb status -75, 0 bytes
[63792.529197] smsusb_onresponse: line: 118: error, urb status -75, 0 bytes
[63792.529446] smsusb_onresponse: line: 118: error, urb status -75, 0 bytes
[63792.529707] smsusb_onresponse: line: 118: error, urb status -75, 0 bytes
[63792.529947] smsusb_onresponse: line: 118: error, urb status -75, 0 bytes

I am using this firmware:

# md5sum /lib/firmware/sms1xxx-hcw-55xxx-dvbt-02.fw
b44807098ba26e52cbedeadc052ba58f  /lib/firmware/sms1xxx-hcw-55xxx-dvbt-02.fw

Is something wrong with the firmware? Is this normal?

Thanks and best regards.

-- 
Josu Lazkano
