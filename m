Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37582 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750738AbdGLJKY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 05:10:24 -0400
To: "linux-media@vger.kernel.org; david@hardeman.nu; sean"@mess.org
From: "Sharma, Jitendra" <shajit@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org
Subject: Query: IR remote over android
Message-ID: <1d5d2467-05ca-3245-7843-95a4087aeb55@codeaurora.org>
Date: Wed, 12 Jul 2017 14:40:20 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am working on a android project. Here, I want to enable Remote control 
support on one of our custom msm chipset based board.

The idea is, once board boot up, then via HDMI over HDMI monitor we will 
see android UI, and we want to browse through that UI using any standard 
protocol(like RC6 or nec) based remote

For enabling remote control support, I followed below steps:

1) Enabled RC support for driver compilation in our defconfig file like:

+CONFIG_MEDIA_RC_SUPPORT=y
+CONFIG_RC_DEVICES=y
+CONFIG_IR_GPIO_CIR=y

2) We have one RC6 philips remote. So, we created keycode file using 
scancodes and used that keycode file for device node mentioned below.

3) As IR receiver is connected via gpio over our custom board, so we add 
a device tree entry like:

+       ir: ir-receiver {
+               compatible = "gpio-ir-receiver";
+               gpios = <&tlmm 120 1>;
+               linux,rc-map-name = "rc-rc6-philips"; /*rc-rc6-philips 
is the keycode file for one RC6 protocol based file*/
+       };
4) Finally create boot.img and flash it onto board

Now our observation with above created boot.img is as follows:

1) We boot up without HDMI connected (For our case till we not connect 
HDMI, android userspace won't come up).

2) Via getevent tool, we could see remote events coming up proper . This 
is Good case

3) Now we connect HDMI (after connecting HDMI, android userspace gets 
up). We observed that via getevent tool, no event is coming up even 
after multiple remote key presses. This is bad case

I enabled IR_dprintk and for this bad case, I observed that for each key 
press, below logs appear continously:

[  128.208417] sample: (00000us space)
[  128.211341] sample: (00000us space)
[  128.211683] sample: (00000us space)
[  128.212180] sample: (00000us space)

And then eventually RC6 decoder function fails in very early stage.

4) After more debugging, I observed that, if I apply below change in 
rc-main.c file and create and flash new boot.img in our board and boot it

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 3f0f71a..1acdd09 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1347,7 +1349,6 @@ int rc_register_device(struct rc_dev *dev)
                 return -EINVAL;

         set_bit(EV_KEY, dev->input_dev->evbit);
-       set_bit(EV_REP, dev->input_dev->evbit);
         set_bit(EV_MSC, dev->input_dev->evbit);
         set_bit(MSC_SCAN, dev->input_dev->mscbit);
         if (dev->open)

then, after connecting HDMI, I could see remote working over android .


So, my query is, does EV_REP in rc-main.c causing remote decoder 
function to fail. Is it some kind of bug. Or am i missing something.


Thanks,

Jitendra
