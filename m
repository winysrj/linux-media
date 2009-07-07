Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:38205 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbZGGLbB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jul 2009 07:31:01 -0400
Received: by bwz25 with SMTP id 25so1970133bwz.37
        for <linux-media@vger.kernel.org>; Tue, 07 Jul 2009 04:31:03 -0700 (PDT)
From: Raik Bieniek <raik.bieniek@googlemail.com>
To: linux-media@vger.kernel.org
Subject: Support for Twinhan Starbox 1
Date: Tue, 7 Jul 2009 13:30:57 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071330.57797.raik.bieniek@googlemail.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a Twinhan Starbox 1 and it doesn't work with the courent driver. I've 
read somewhere that the only difference between the Starbox 2, which should 
work with the dvb-usb-vp702x module, and the Starbox 1 is that the hardware 
pid filter can't be turned of for the Starbox 1. So i looked at the code and i 
saw that there is allready code for the pid filter and i only needed to enable 
it with the patch i attached to get  it work. I've tested it with kaffeine and 
it works good for me.
I don't know how to differentiate between Version 1 and 2. afaik even the usb 
product id is the same. So maybe the best would be to implement the pid filter 
but don't add "DVB_USB_ADAP_NEED_PID_FILTERING" to caps. So nothing changes 
for Starbox 2 owners and people who have a Starbox 1 can get it working by 
setting the option "force_pid_filter_usage=1" for the dvb-usb module.
I've attached the output from lsusb so maybe someone knows how to differentiate 
betewwn the Versions

diff -u -r v4l-dvb-493ed02d8330.orig/linux/drivers/media/dvb/dvb-usb/vp702x.c 
v4l-dvb-493ed02d8330/linux/drivers/media/dvb/dvb-usb/vp702x.c
--- v4l-dvb-493ed02d8330.orig/linux/drivers/media/dvb/dvb-usb/vp702x.c	
2009-07-04 13:15:11.000000000 +0200
+++ v4l-dvb-493ed02d8330/linux/drivers/media/dvb/dvb-usb/vp702x.c	2009-07-06 
12:08:28.307330278 +0200
@@ -144,15 +144,15 @@
 	return 0;
 }
 
-#if 0
-static int vp702x_pid_filter_ctrl(struct dvb_usb_device *adap, int onoff)
+static int vp702x_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
 //	u8 b;
 //	return vp702x_usb_in_op(d,0xe0, ((!onoff) << 8) | 0x0e, 0, &b, 1);
+	vp702x_set_pld_mode(adap, onoff);
 	return 0;
 }
 
-static int vp702x_pid_filter(struct dvb_usb_device *adap, int index, u16 pid, 
int onoff)
+static int vp702x_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid, 
int onoff)
 {
 #if 0
 	struct vp702x_state *st = adap->priv;
@@ -173,9 +173,9 @@
 
 	vp702x_check_pid_filter(d);
 #endif
+	vp702x_set_pid(adap, pid, index, onoff);
 	return 0;
 }
-#endif
 
 static int vp702x_init_pid_filter(struct dvb_usb_adapter *adap)
 {
@@ -309,7 +309,12 @@
 	.num_adapters = 1,
 	.adapter = {
 		{
-			.caps             = DVB_USB_ADAP_RECEIVES_204_BYTE_TS,
+			.caps             = DVB_USB_ADAP_RECEIVES_204_BYTE_TS | 
+			DVB_USB_ADAP_HAS_PID_FILTER, //| DVB_USB_ADAP_NEED_PID_FILTERING,
+
+			.pid_filter_count = 8,
+			.pid_filter_ctrl  = vp702x_pid_filter_ctrl,
+			.pid_filter       = vp702x_pid_filter,
 
 			.streaming_ctrl   = vp702x_streaming_ctrl,
 			.frontend_attach  = vp702x_frontend_attach,


root@laptop:/# lsusb -d 13d3:3207 -v  

Bus 001 Device 005: ID 13d3:3207 IMC Networks DTV-DVB UDST7020BDA DVB-S 
Box(DVBS for MCE2005)
Device Descriptor:                                                                           
  bLength                18                                                                  
  bDescriptorType         1                                                                  
  bcdUSB               2.00                                                                  
  bDeviceClass            0 (Defined at Interface level)                                     
  bDeviceSubClass         0                                                                  
  bDeviceProtocol         0                                                                  
  bMaxPacketSize0        64                                                                  
  idVendor           0x13d3 IMC Networks                                                     
  idProduct          0x3207 DTV-DVB UDST7020BDA DVB-S Box(DVBS for MCE2005)                  
  bcdDevice            2.09                                                                  
  iManufacturer           1                                                                  
  iProduct                2                                                                  
  iSerial                 3                                                                  
  bNumConfigurations      1                                                                  
  Configuration Descriptor:                                                                  
    bLength                 9                                                                
    bDescriptorType         2                                                                
    wTotalLength           32                                                                
    bNumInterfaces          1                                                                
    bConfigurationValue     1                                                                
    iConfiguration          0                                                                
    bmAttributes         0xc0                                                                
      Self Powered                                                                           
    MaxPower              100mA                                                              
    Interface Descriptor:                                                                    
      bLength                 9                                                              
      bDescriptorType         4                                                              
      bInterfaceNumber        0                                                              
      bAlternateSetting       0                                                              
      bNumEndpoints           2                                                              
      bInterfaceClass       255 Vendor Specific Class                                        
      bInterfaceSubClass      0                                                              
      bInterfaceProtocol      0                                                              
      iInterface              0                                                              
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval             100
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
Device Status:     0x0001
  Self Powered
