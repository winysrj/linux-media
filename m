Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:34975 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946747AbbHHSQ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2015 14:16:28 -0400
Received: by igr7 with SMTP id 7so48540772igr.0
        for <linux-media@vger.kernel.org>; Sat, 08 Aug 2015 11:16:27 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 8 Aug 2015 11:16:27 -0700
Message-ID: <CAN-NoH1CBhEz6ur73NxkfBL0dAA=Xb2xbTW=FX8YtsB7n_qv9Q@mail.gmail.com>
Subject: sinks in device tree
From: Richard Cagley <rcagley@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm new to using the media controller and struggling to set up a sink
in my device tree for a Xilinx VDMA output. I have the below in my
device tree. The problem is the output of my VDMA is going to a
hardware element that doesn't have/need a driver. So, when I query the
link with media_entity_get_info it tells me there are 0 links on
"video_cap output 0".

is there a endpoint I can/should be using instead of the
hdmi-connector I'm currently using that will give me a valid link?
(BTW, if this is not an appropriate question for this list please
redirect me.)

                 axivdma@43000000 {
                        compatible = "xlnx,axi-vdma-1.00.a";
                        reg = < 0x43000000 0x10000 >;
                        xlnx,flush-fsync = <0x1>;
                        xlnx,num-fstores = <0x3>;
                        #dma-cells = <0x1>;
                        linux,phandle = <0xc>;
                        phandle = <0xc>;

                        dma-channel@43000000 {
                                compatible = "xlnx,axi-vdma-mm2s-channel";
                                interrupt-parent = <0x3>;
                                interrupts = <0 90 4>;
                                xlnx,datawidth = <0x10>;
                        };

                        dma-channel@43000030 {
                                compatible = "xlnx,axi-vdma-s2mm-channel";
                                interrupt-parent = <0x3>;
                                interrupts = <0 91 4>;
                                xlnx,datawidth = <0x10>;
                        };
                };

                video_cap {
                        compatible = "xlnx,video";
                        dmas = <0xc 0x1 0xc 0x0>;
                        dma-names = "port0", "port1";

                        ports {
                                #address-cells = <0x1>;
                                #size-cells = <0x0>;

                                port@0 {
                                        reg = <0x0>;
                                        direction = "input";

                                        endpoint {
                                                remote-endpoint = <0xd>;
                                                linux,phandle = <0xb>;
                                                phandle = <0xb>;
                                        };
                                };
                                port@1 {
                                        reg = <0x1>;
                                        direction = "output";

                                        endpoint {
                                                remote-endpoint = <0xe>;
                                                linux,phandle = <0xa>;
                                                phandle = <0xa>;
                                        };
                                };

                        };
                };
                connector@1 {
                        compatible = "hdmi-connector";
                        label = "hdmi";
                        type = "a";
                        port {
                                endpoint {
                                        remote-endpoint = <0xa>;
                                        linux,phandle = <0xe>;
                                        phandle = <0xe>;
                                };
                        };
                };
