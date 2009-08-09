Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:53207 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbZHITPw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Aug 2009 15:15:52 -0400
Date: Sun, 9 Aug 2009 21:16:55 +0200
From: Markus Dahms <mad@automagically.de>
To: linux-media@vger.kernel.org
Subject: MSI DigiVOX mini II 3.0 (rtl2831u)
Message-ID: <20090809211655.48b1ffbf@angua.madsworld.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

I got the mentioned DVB-T USB stick and now try to get it working with
Linux. What I found out so far (could not find much about this dongle):

* image of PCB: http://automagically.de/images/msi_digivox_mini2_v3_01.jpg
* RTL2832U DVB-T/USB chip
* FCI FC2580 tuner chip (Win driver indicates it _may_ be compatible to
  MT2266) - the default MXL5005 is most likely wrong
* remote control (with NEC coding according to Win driver)
* excerpt of kernel messages with USB VID/PID added to the
  rtl2831-r2 driver below (and debug enabled)

hopefully this helps to improve the driver...

Markus

PS: does anybody know why there are rtd2831u and haihua device lists in
    rtd2830u.c, I could not really find a difference...

Aug  9 13:01:22 angua kernel: [ 9186.169355] dvb-usb: found a 'MSI DigiVOX mini II 3.0' in warm state.
Aug  9 13:01:22 angua kernel: [ 9186.169373] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Aug  9 13:01:22 angua kernel: [ 9186.171681] DVB: registering new adapter (MSI DigiVOX mini II 3.0)
Aug  9 13:01:22 angua kernel: [ 9186.174120] +rtd2831u_fe_attach
Aug  9 13:01:22 angua kernel: [ 9186.174203] -rtd2831u_fe_attach
Aug  9 13:01:22 angua kernel: [ 9186.174212] DVB: registering adapter 1 frontend 0 (Realtek RTL2831 DVB-T)...
Aug  9 13:01:22 angua kernel: [ 9186.174453] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:12.2/usb1/1-6/input/input9
Aug  9 13:01:22 angua kernel: [ 9186.174524] dvb-usb: schedule remote query interval to 300 msecs.
Aug  9 13:01:22 angua kernel: [ 9186.174534] dvb-usb: MSI DigiVOX mini II 3.0 successfully initialized and connected.
Aug  9 13:01:22 angua kernel: [ 9186.174588] usbcore: registered new interface driver dvb_usb_rtd2831u
Aug  9 13:01:22 angua kernel: [ 9186.468036] Selected IR type 0x00
Aug  9 13:01:22 angua kernel: [ 9186.492447] Selected IR type 0x00
Aug  9 13:01:30 angua kernel: [ 9194.585514]  ########################## ver 0.5 rtd2830_init : init 
Aug  9 13:01:30 angua kernel: [ 9194.587150] #####################################################TD2831_RMAP_INDEX_USB_STAT=0x3
Aug  9 13:01:30 angua kernel: [ 9194.587156] HIGH SPEED
Aug  9 13:01:30 angua kernel: [ 9194.595511] #####################################################RTD2831_RMAP_INDEX_SYS_GPO=0x18
Aug  9 13:01:30 angua kernel: [ 9194.600389] #####################################################RTD2831_RMAP_INDEX_SYS_GPO=0x9
Aug  9 13:01:30 angua kernel: [ 9194.606884] #####################################################RTD2831_RMAP_INDEX_SYS_GPO=0xd
Aug  9 13:01:30 angua kernel: [ 9194.668393] rtd2831_tuner_register_read: ( offset , data ) = ( 0x0 , 0x0 ) size != -32 bytes 
Aug  9 13:01:30 angua kernel: [ 9194.668414] This device has the MXL5005 onboard.....(Default)
Aug  9 13:01:30 angua kernel: [ 9194.675514] rtd2831_tuner_register_write: ( offset , data ) = ( 0x9 , 0xb1 ) size != -32 bytes
Aug  9 13:01:30 angua kernel: [ 9194.676191] + rtd2830_set_parameters
Aug  9 13:01:30 angua kernel: [ 9194.776635] rtd2831_tuner_register_write: ( offset , data ) = ( 0x35 , 0x94 ) size != -32 bytes
Aug  9 13:01:30 angua kernel: [ 9194.883622]   rtd2830_read_status ******FSM = 9 , ber = 19616******
Aug  9 13:01:31 angua kernel: [ 9195.090595]   rtd2830_read_status ******FSM = 9 , ber = 19616******
Aug  9 13:01:31 angua kernel: [ 9195.297452]   rtd2830_read_status ******FSM = 2 , ber = 19616******
Aug  9 13:01:31 angua kernel: [ 9195.504428]   rtd2830_read_status ******FSM = 9 , ber = 19616******
Aug  9 13:01:31 angua kernel: [ 9195.711414]   rtd2830_read_status ******FSM = 3 , ber = 19616******
Aug  9 13:01:31 angua kernel: [ 9195.782901]   rtd2830_read_status ******FSM = 3 , ber = 19616******
Aug  9 13:01:31 angua kernel: [ 9195.782909] + rtd2830_set_parameters
