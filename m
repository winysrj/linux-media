Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46389 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761292Ab2FVGI0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 02:08:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Shx2V-0006iy-JW
	for linux-media@vger.kernel.org; Fri, 22 Jun 2012 08:08:15 +0200
Received: from aant209.neoplus.adsl.tpnet.pl ([83.5.101.209])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 08:08:15 +0200
Received: from acc.for.news by aant209.neoplus.adsl.tpnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 08:08:15 +0200
To: linux-media@vger.kernel.org
From: Marx <acc.for.news@gmail.com>
Subject: Re: How to make bug report
Date: Fri, 22 Jun 2012 07:08:57 +0200
Message-ID: <98bdb9-h78.ln1@wuwek.kopernik.gliwice.pl>
References: <p4v2b9-nd7.ln1@wuwek.kopernik.gliwice.pl> <4FE1FD7B.4050108@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <4FE1FD7B.4050108@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 2012-06-20 18:42, Antti Palosaari pisze:
> As author of the AF9015 I would like to see some of those errors. And
> your driver version. Use latest v4l-dvb if possible as I have changed it
> very much recently.
I forgot to mention: I use Debian testing with experimental kernel:
Linux wuwek 3.4-trunk-686-pae #1 SMP Wed Jun 6 15:11:31 UTC 2012 i686 
GNU/Linux
As drivers I use media_build from 12.06.2012
While I have inserted Prof Revolution 8000, it isn't used (VDR is run 
with only this one adapter), so my USB tuner is the only one I use.

uwek:~/media_build/media_build# lsusb -v

Bus 002 Device 002: ID 15a4:9016 Afatech Technologies, Inc. AF9015 DVB-T 
USB2.0 stick
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x15a4 Afatech Technologies, Inc.
   idProduct          0x9016 AF9015 DVB-T USB2.0 stick
   bcdDevice            2.00
   iManufacturer           1 Afatech
   iProduct                2 DVB-T 2
   iSerial                 3 010101010600001
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           71
     bNumInterfaces          2
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower              500mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           4
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
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x84  EP 4 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x85  EP 5 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        1
       bAlternateSetting       0
       bNumEndpoints           1
       bInterfaceClass         3 Human Interface Device
       bInterfaceSubClass      0 No Subclass
       bInterfaceProtocol      1 Keyboard
       iInterface              0
         HID Device Descriptor:
           bLength                 9
           bDescriptorType        33
           bcdHID               1.01
           bCountryCode            0 Not supported
           bNumDescriptors         1
           bDescriptorType        34 Report
           wDescriptorLength      65
          Report Descriptors:
            ** UNAVAILABLE **
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x83  EP 3 IN
         bmAttributes            3
           Transfer Type            Interrupt
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0040  1x 64 bytes
         bInterval              10
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0000
   (Bus Powered)


wuwek:~/media_build/media_build# lsmod | grep dvb
dvb_usb_af9015         21114  7
dvb_usb                22062  1 dvb_usb_af9015
videobuf_dvb           12682  1 cx23885
dvb_core               68023  3 cx23885,dvb_usb,videobuf_dvb
videobuf_core          17561  3 videobuf_dma_sg,cx23885,videobuf_dvb
rc_core                17953  11 
cx23885,ir_lirc_codec,ir_rc5_decoder,dvb_usb,ir_nec_decoder,ir_sony_decoder,ir_mce_kbd_decoder,ir_jvc_decoder,ir_rc6_decoder,dvb_usb_af9015
i2c_core               19116  10 
cx23885,i2c_piix4,dvb_usb,af9013,stb6100,stv0900,v4l2_common,tveeprom,tda18218,videodev
usbcore               104647  6 
dvb_usb,ohci_hcd,ehci_hcd,usbhid,dvb_usb_af9015


wuwek:~/media_build/media_build# lsmod | grep 90
af9013                 17185  1
dvb_usb_af9015         21114  7
dvb_usb                22062  1 dvb_usb_af9015
xt_TCPMSS              12590  0
nfnetlink_queue        12905  0
x_tables               18090  68 
xt_physdev,xt_pkttype,ip6table_filter,xt_devgroup,xt_statistic,xt_RATEEST,xt_DSCP,xt_dccp,xt_dscp,xt_iprange,xt_mark,xt_sctp,xt_time,xt_HL,xt_hl,ip6t_ipv6header,ip6table_mangle,ip6t_rpfilter,xt_length,xt_comment,xt_rateest,ipt_ULOG,xt_policy,xt_CHECKSUM,xt_recent,xt_IDLETIMER,ip_tables,xt_SECMARK,xt_tcpmss,xt_tcpudp,xt_string,ip6t_frag,xt_TCPOPTSTRIP,ip6t_hbh,ipt_ah,xt_AUDIT,xt_NFQUEUE,xt_NFLOG,xt_TRACE,xt_limit,xt_owner,xt_realm,xt_quota,ipt_rpfilter,xt_LED,xt_LOG,xt_cpu,xt_ecn,xt_esp,xt_mac,xt_u32,xt_osf,xt_set,ip6t_eui64,xt_hashlimit,xt_multiport,iptable_filter,xt_CLASSIFY,xt_TCPMSS,ip6t_ah,ip6t_mh,ip6t_rt,ipt_REJECT,iptable_mangle,ipt_ECN,ip6_tables,xt_addrtype,ip6t_REJECT
ipx                    22590  0
stv0900                51276  1
rc_core                17953  11 
cx23885,ir_lirc_codec,ir_rc5_decoder,dvb_usb,ir_nec_decoder,ir_sony_decoder,ir_mce_kbd_decoder,ir_jvc_decoder,ir_rc6_decoder,dvb_usb_af9015
i2c_core               19116  10 
cx23885,i2c_piix4,dvb_usb,af9013,stb6100,stv0900,v4l2_common,tveeprom,tda18218,videodev
soundcore              12890  1 snd
usbcore               104647  6 
dvb_usb,ohci_hcd,ehci_hcd,usbhid,dvb_usb_af9015



Marx

