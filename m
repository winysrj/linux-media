Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54784 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756325AbdGXPRH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 11:17:07 -0400
Received: from [10.10.0.58] ([213.191.34.238]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MfF6I-1dFO823xxy-00OsOY for
 <linux-media@vger.kernel.org>; Mon, 24 Jul 2017 17:17:05 +0200
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Stephan Bauroth <der_steffi@gmx.de>
Subject: [Question] adv7180 and media-imx
Message-ID: <beaf01a7-ea18-b407-3542-3034f5cb2d89@gmx.de>
Date: Mon, 24 Jul 2017 17:17:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear linux-media,

I'm having troubles setting up a video input on a custom board using the 
staging imx-media driver and an i2c-connected video codec. The codec is 
a tw9990, but I use the driver for the adv7180 which is quite compatible 
and there is not much to configure within the codec anyway up until now. 
Also the driver detects my two codecs and does not complain about anything:

# dmesg | grep adv
[    2.912422] adv7180 2-0044: chip found @ 0x44 (21a8000.i2c)
[    2.938790] adv7180 2-0045: chip found @ 0x45 (21a8000.i2c)

The media-imx driver works fine regarding finding and probing all parts 
of the IPUs:

[    3.072253] imx-media: Registered subdev ipu2_csi1_mux
[    3.077409] imx-media: Registered subdev ipu1_csi0_mux
[    3.082780] imx-media: Registered subdev ipu1_vdic
[    3.087664] imx-media: Registered subdev ipu2_vdic
[    3.092670] imx-media: Registered subdev ipu1_ic_prp
[    3.097730] imx-media: Registered subdev ipu1_ic_prpenc
[    3.103187] ipu1_ic_prpenc: Registered ipu1_ic_prpenc capture as 
/dev/video0
[    3.110372] imx-media: Registered subdev ipu1_ic_prpvf
[    3.117725] ipu1_ic_prpvf: Registered ipu1_ic_prpvf capture as 
/dev/video1
[    3.127718] imx-media: Registered subdev ipu2_ic_prp
[    3.132877] imx-media: Registered subdev ipu2_ic_prpenc
[    3.138339] ipu2_ic_prpenc: Registered ipu2_ic_prpenc capture as 
/dev/video2
[    3.145494] imx-media: Registered subdev ipu2_ic_prpvf
[    3.150869] ipu2_ic_prpvf: Registered ipu2_ic_prpvf capture as 
/dev/video3
[    3.158027] imx-media: Registered subdev ipu1_csi0
[    3.163035] ipu1_csi0: Registered ipu1_csi0 capture as /dev/video4
[    3.169327] imx-media: Registered subdev ipu1_csi1
[    3.174335] ipu1_csi1: Registered ipu1_csi1 capture as /dev/video5
[    3.180631] imx-media: Registered subdev ipu2_csi0
[    3.185649] ipu2_csi0: Registered ipu2_csi0 capture as /dev/video6
[    3.191944] imx-media: Registered subdev ipu2_csi1
[    3.203244] ipu2_csi1: Registered ipu2_csi1 capture as /dev/video7

So, at this point I have /dev/video[0-7] and have no idea how to 
interact with that.
v4l2grab fails:
# v4l2grab -d /dev/video5 -o temp.jpeg
[ 9966.884286] ipu1_csi1: pipeline start failed with -32
libv4l2: error turning on stream: Broken pipe
VIDIOC_STREAMON error 32, Broken pipe

media-ctl fails:
# media-ctl -p -d /dev/video5
Failed to enumerate /dev/video5 (-25)

I traced the dmesg error message from v4l2grab down in the kernel 
sources and found that in 
drivers/staging/media/imx/imx-media-csi.c:csi_s_stream, the check
     if (!priv->src_sd || !priv->sink) {
         ret = -EPIPE;
         goto out;
     }
fails because priv->src_sd is NULL. This 'looks' like the links between 
the subdevices are not set up, but I have no idea how to correct that.

Can anybody help me track this down/correctly set up the desired links? 
Thanks in advance!

For Reference: I'm using Linux 4.13-rc2 and my device tree snippets look 
like this:
The codec itself:
     video_codec_a: tw9990@44 {
         compatible = "adi,adv7180";
         reg = <0x44>;
         pinctrl-names = "default";
         pinctrl-0 = <&pinctrl_tw9990_a>;
         powerdown-gpios = <&gpio3 1 GPIO_ACTIVE_HIGH>;
         interrupt-parent = <&gpio6>;
         interrupts = <6 IRQ_TYPE_LEVEL_LOW>;
         ipu_id = <1>;
         csi_id = <1>;
         port {
             tw9990_to_ipu2_csi1_mux: endpoint {
                 remote-endpoint = <&ipu2_csi1_mux_from_parallel_sensor>;
                 bus-width = <8>;
             };
         };
     };

The remaining IPU nodes:
&ipu2_csi1_from_ipu2_csi1_mux {
     bus-width = <8>;
};

&ipu2_csi1_mux_from_parallel_sensor {
     remote-endpoint = <&tw9990_to_ipu2_csi1_mux>;
     bus-width = <8>;
};

&ipu2_csi1 {
     /* enable frame interval monitor on this port */
     fim {
         status = "okay";
     };
};
