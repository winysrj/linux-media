Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:55593 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbbAMUQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 15:16:18 -0500
Received: by mail-wg0-f49.google.com with SMTP id n12so5126490wgh.8
        for <linux-media@vger.kernel.org>; Tue, 13 Jan 2015 12:16:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEt6MX=rmPAb798TysHDWHAQxpVxzKiaDNv4P9ZtUNPz2YEwpA@mail.gmail.com>
References: <CAPx3zdRnHcQOasSjnYZkuE+Hk-L6PVaPVAzBbCMnGdM3ZysxFw@mail.gmail.com>
	<CAEt6MX=f-kkemgmAUNsEdZQzH2tRgtPDacbCn4hwH27uY-upDA@mail.gmail.com>
	<CAPx3zdSLb8gzcGTUcWrktc9icJBCCJ0FbPecxeUJRot3ztHwSA@mail.gmail.com>
	<CAEt6MX=rmPAb798TysHDWHAQxpVxzKiaDNv4P9ZtUNPz2YEwpA@mail.gmail.com>
Date: Tue, 13 Jan 2015 21:16:15 +0100
Message-ID: <CAPx3zdR0tnf54iPQh+Z6VbE_Yqh4K+io=q0z+GqMeWk=dmi-3A@mail.gmail.com>
Subject: Re: Driver/module in kernel fault. Anyone expert to help me? Siano ID 187f:0600
From: Francesco Other <francesco.other@gmail.com>
To: =?UTF-8?Q?Roberto_Alc=C3=A2ntara?= <roberto@eletronica.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, this is the system log, this part when I connected the device:

Jan 13 21:10:53 Linux kernel: [  457.464060] usb 1-1: new high-speed
USB device number 7 using ehci-pci
Jan 13 21:10:53 Linux kernel: [  457.596722] usb 1-1: New USB device
found, idVendor=187f, idProduct=0600
Jan 13 21:10:53 Linux kernel: [  457.596729] usb 1-1: New USB device
strings: Mfr=1, Product=2, SerialNumber=0
Jan 13 21:10:53 Linux kernel: [  457.596734] usb 1-1: Product: MDTV Receiver
Jan 13 21:10:53 Linux kernel: [  457.596738] usb 1-1: Manufacturer:
MDTV Receiver
Jan 13 21:10:53 Linux kernel: [  457.597181] smsusb_probe: board
id=18, interface number 0
Jan 13 21:10:53 Linux kernel: [  457.597186] smsusb_probe: smsusb_probe 0
Jan 13 21:10:53 Linux kernel: [  457.597190] smsusb_probe: endpoint 0 81 02 512
Jan 13 21:10:53 Linux kernel: [  457.597484] smsusb_probe: endpoint 1 02 02 512
Jan 13 21:10:53 Linux kernel: [  457.597599] smsusb_init_device: in_ep
= 81, out_ep = 02
Jan 13 21:10:53 Linux kernel: [  457.597778] smscore_register_device:
allocated 50 buffers
Jan 13 21:10:53 Linux kernel: [  457.597783] smscore_register_device:
device ffff8800571d5000 created
Jan 13 21:10:53 Linux kernel: [  457.597786] smsusb_init_device:
smsusb_start_streaming(...).
Jan 13 21:10:53 Linux kernel: [  457.597801] smscore_set_device_mode:
set device mode to 0
Jan 13 21:10:53 Linux kernel: [  457.597807] smsusb_sendrequest:
sending MSG_SMS_GET_VERSION_EX_REQ(668) size: 8
Jan 13 21:10:53 Linux kernel: [  457.597964] smsusb_onresponse:
received MSG_SMS_GET_VERSION_EX_RES(669) size: 100
Jan 13 21:10:53 Linux kernel: [  457.597969] smscore_onresponse: data
rate 316 bytes/secs
Jan 13 21:10:53 Linux kernel: [  457.597973] smscore_onresponse:
Firmware id 255 prots 0x0 ver 8.1
Jan 13 21:10:53 Linux kernel: [  457.597986] smscore_get_fw_filename:
trying to get fw name from sms_boards board_id 18 mode 0
Jan 13 21:10:53 Linux kernel: [  457.597990] smscore_get_fw_filename:
cannot find fw name in sms_boards, getting from lookup table mode 0
type 7
Jan 13 21:10:53 Linux kernel: [  457.597993]
smscore_load_firmware_from_file: Firmware name: dvb_rio.inp
Jan 13 21:10:53 Linux kernel: [  457.598109]
smscore_load_firmware_from_file: read fw dvb_rio.inp, buffer
size=0x145dc
Jan 13 21:10:53 Linux kernel: [  457.598142]
smscore_load_firmware_family2: loading FW to addr 0x40260 size 83408
Jan 13 21:10:53 Linux kernel: [  457.598177] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.598340] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.598354] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.598467] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.598477] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.598591] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.598600] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.598716] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.598725] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.598841] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.598849] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.598966] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.598975] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.599091] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.599099] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.599216] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.599224] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.599341] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.599349] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.599466] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.599474] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.599591] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.599599] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.599717] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.599726] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.599841] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.599849] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.599966] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.599975] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.600092] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.600105] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.600342] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.600549] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.600715] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.600727] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.600844] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.600853] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.600969] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.600979] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.601215] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.601234] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.601466] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.601483] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.601716] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.601733] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.601966] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.601983] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.602216] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.602233] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.602467] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.602483] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.602716] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.602733] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.602967] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.602984] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.603217] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.603234] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.603467] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.603483] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.603717] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.603733] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.603967] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.603984] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.604218] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.604234] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.604467] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.604484] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.604717] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.604734] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.604967] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.604984] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.605218] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.605234] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.605468] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.605485] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.605718] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.605734] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.605968] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.605985] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.606218] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.606235] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.606469] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.606485] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.606718] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.606735] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.606968] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.606985] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.607218] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.607231] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.607345] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.607354] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.607474] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.607483] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.607595] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.607603] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.607720] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.607729] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.607845] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.607853] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.607970] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.607979] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.608098] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.608109] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.608221] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.608230] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.608348] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.608358] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.608470] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.608478] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.608596] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.608605] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.608721] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.608729] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.608845] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.608854] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.608971] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.608979] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.609095] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.609104] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.609220] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.609229] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.609346] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.609355] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.609470] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.609478] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.609596] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.609604] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.609721] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.609729] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.609846] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.609854] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.609971] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.609979] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.610096] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.610106] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.610223] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.610231] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.610347] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.610355] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.610471] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.610479] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.610597] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.610605] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.610721] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.610729] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.610846] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.610855] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.610974] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.610982] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.611096] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.611105] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.611222] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.611230] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.611346] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.611355] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.611471] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.611480] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.611597] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.611606] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.611721] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.611730] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.611847] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.611856] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.611972] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.611980] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.612099] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.612114] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.612345] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.612617] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.612846] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.612857] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.612973] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.612983] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.613100] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.613111] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.613224] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.613233] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.613350] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.613359] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.613473] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.613481] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.613599] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.613607] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.613723] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.613731] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.613848] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.613857] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.613973] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.613981] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.614098] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.614107] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.614223] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.614232] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.614348] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.614357] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.614473] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.614481] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.614598] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.614607] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.614723] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.614731] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.614849] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.614857] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.614973] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.614981] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.615099] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.615108] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.615223] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.615231] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.615349] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.615358] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.615474] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.615482] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.615599] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.615608] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.615725] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.615736] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.615851] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.615860] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.615977] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.615986] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.616223] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.616431] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.616598] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.616609] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.616727] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.616736] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.616851] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.616861] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.616977] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.616988] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.617105] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.617113] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.617227] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.617236] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.617352] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.617363] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.617477] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.617487] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.617602] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.617612] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.617728] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.617737] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.617850] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.617859] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.617976] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.617984] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.618100] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.618108] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.618225] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.618235] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.618350] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.618359] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.618475] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.618484] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.618600] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.618608] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.618726] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.618734] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.618850] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.618858] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.618976] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.618984] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.619100] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.619108] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.619226] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.619235] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.619351] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.619359] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.619475] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.619484] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.619601] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.619609] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.619725] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.619734] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.619851] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.619861] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.619976] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.619985] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.620102] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.620108] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.620228] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.620549] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.620726] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.620738] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.620853] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.620863] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.620980] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.620991] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.621103] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.621111] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.621229] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.621238] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.621352] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.621360] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.621477] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.621486] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.621602] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.621610] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.621727] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.621736] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.621852] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.621860] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.621977] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.621985] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.622102] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.622111] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.622228] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.622236] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.622352] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.622360] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.622477] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.622486] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.622602] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.622610] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.622727] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.622736] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.622852] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.622861] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.622977] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.622986] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.623103] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.623111] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.623228] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.623237] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.623352] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.623361] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.623478] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.623487] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.623602] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.623611] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.623728] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.623737] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.623853] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.623861] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.623978] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.623986] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.624105] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.624117] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.624352] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.624524] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.624727] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.624738] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.624855] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.624865] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.624980] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.624990] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.625106] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.625116] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.625230] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.625238] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.625355] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.625364] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.625479] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.625487] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.625604] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.625613] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.625729] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.625737] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.625854] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.625863] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.625979] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.625987] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.626227] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.626236] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.626354] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.626363] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.626479] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.626487] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.626604] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.626613] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.626730] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.626738] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.626854] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.626863] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.626980] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.626988] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.627104] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.627113] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.627229] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.627238] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.627355] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.627364] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.627480] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.627489] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.627605] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.627614] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.627730] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.627738] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.627855] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.627864] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.627980] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.627988] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.628105] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.628185] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.628354] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.628365] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.628480] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.628488] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.628609] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.628618] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.628730] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.628738] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.628856] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.628864] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.628981] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.628989] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.629105] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.629114] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.629230] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.629239] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.629355] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.629363] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.629481] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.629489] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.629606] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.629614] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.629731] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.629739] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.629856] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.629864] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.629983] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.629992] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.630106] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.630114] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.630231] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.630240] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.630359] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.630368] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.630481] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.630490] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.630607] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.630615] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.630734] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.630743] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.630856] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.630865] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.630981] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.630990] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.631106] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.631115] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.631232] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.631241] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.631356] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.631365] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.631482] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.631491] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.631606] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.631615] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.631732] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.631740] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.631857] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.631865] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.631982] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.631990] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.632109] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.632114] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.632233] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.632557] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.632731] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.632743] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.632858] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.632868] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.632985] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.632995] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.633108] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.633117] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.633234] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.633244] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.633358] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.633366] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.633483] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.633492] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.633608] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.633616] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.633733] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.633742] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.633857] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.633866] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.633983] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.633991] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.634108] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.634116] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.634233] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.634242] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.634358] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.634366] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.634484] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.634493] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.634608] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.634616] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.634734] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.634742] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.634858] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.634866] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.634983] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.634992] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.635109] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.635117] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.635234] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.635242] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.635359] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.635367] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.635483] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.635492] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.635609] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.635617] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.635734] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.635743] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.635859] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.635867] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.635984] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.635993] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.636112] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.636185] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.636358] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.636385] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.636607] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.636617] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.636738] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.636748] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.636862] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.636873] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.636986] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.636995] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.637112] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.637121] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.637235] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.637243] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.637364] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.637373] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.637485] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.637493] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.637610] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.637619] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.637734] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.637743] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.637860] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.637869] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.637985] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.637993] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.638110] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.638118] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.638235] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.638243] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.638360] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.638369] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.638485] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.638493] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.638611] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.638619] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.638735] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.638743] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.638861] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.638869] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.638986] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.638994] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.639110] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.639119] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.639236] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.639244] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.639361] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.639369] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.639486] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.639494] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.639611] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.639620] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.639736] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.639744] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.639861] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.639870] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.639985] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.639994] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.640112] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.640129] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.640238] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.640263] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.640485] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.640526] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.640736] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.640750] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.640862] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.640872] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.640990] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.640999] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.641112] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.641120] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.641238] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.641246] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.641362] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.641370] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.641487] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.641496] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.641612] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.641620] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.641737] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.641746] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.641862] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.641870] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.641987] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.641996] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.642112] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.642120] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.642237] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.642245] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.642362] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.642370] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.642487] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.642496] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.642612] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.642620] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.642737] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.642746] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.642862] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.642871] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.642987] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.642996] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.643113] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.643121] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.643237] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.643246] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.643363] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.643371] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.643488] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.643497] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.643614] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.643622] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.643738] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.643747] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.643863] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.643871] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.643988] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.643997] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.644116] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.644502] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.644617] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.644627] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.644741] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.644751] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.644865] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.644875] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.644991] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.645002] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.645114] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.645123] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.645240] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.645249] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.645364] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.645373] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.645489] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.645497] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.645614] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.645622] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.645739] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.645748] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.645864] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.645872] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.645989] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.645997] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.646237] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.646246] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.646364] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.646373] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.646490] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.646498] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.646615] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.646624] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.646739] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.646747] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.646864] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.646873] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.646990] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.646998] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.647114] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.647123] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.647239] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.647248] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.647364] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.647373] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.647489] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.647498] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.647615] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.647624] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.647739] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.647747] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.647865] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.647874] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.647990] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.647998] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.648239] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.648253] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.648366] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.648375] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
Jan 13 21:10:53 Linux kernel: [  457.648494] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.648503] smsusb_sendrequest:
sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 152
Jan 13 21:10:53 Linux kernel: [  457.648616] smsusb_onresponse:
received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
Jan 13 21:10:53 Linux kernel: [  457.648624]
smscore_load_firmware_family2: sending MSG_SMS_DATA_VALIDITY_REQ
expecting 0x4fe67a2a
Jan 13 21:10:53 Linux kernel: [  457.648628] smsusb_sendrequest:
sending MSG_SMS_DATA_VALIDITY_REQ(662) size: 20
Jan 13 21:10:53 Linux kernel: [  457.650489] smsusb_onresponse:
received MSG_SMS_DATA_VALIDITY_RES(663) size: 12
Jan 13 21:10:53 Linux kernel: [  457.650493] smscore_onresponse:
MSG_SMS_DATA_VALIDITY_RES, checksum = 0x4fe67a2a
Jan 13 21:10:53 Linux kernel: [  457.650501]
smscore_load_firmware_family2: sending MSG_SMS_SWDOWNLOAD_TRIGGER_REQ
Jan 13 21:10:53 Linux kernel: [  457.650505] smsusb_sendrequest:
sending MSG_SMS_SWDOWNLOAD_TRIGGER_REQ(664) size: 28
Jan 13 21:10:53 Linux kernel: [  457.652616] smsusb_onresponse:
received MSG_SMS_SWDOWNLOAD_TRIGGER_RES(665) size: 12
Jan 13 21:10:53 Linux kernel: [  458.056068] smscore_load_firmware_family2: rc=0
Jan 13 21:10:53 Linux kernel: [  458.056088] smscore_set_device_mode:
firmware download success
Jan 13 21:10:53 Linux kernel: [  458.056092] smsusb_sendrequest:
sending MSG_SMS_INIT_DEVICE_REQ(578) size: 12
Jan 13 21:10:53 Linux kernel: [  458.056319] smsusb_onresponse:
received MSG_SMS_INIT_DEVICE_RES(579) size: 12
Jan 13 21:10:53 Linux kernel: [  458.056331] smsusb_sendrequest:
sending MSG_SMS_INIT_DEVICE_REQ(578) size: 12
Jan 13 21:10:53 Linux kernel: [  458.056446] smsusb_onresponse:
received MSG_SMS_INIT_DEVICE_RES(579) size: 12
Jan 13 21:10:53 Linux kernel: [  458.056455] smscore_set_device_mode:
Success setting device mode.
Jan 13 21:10:53 Linux kernel: [  458.056462] DVB: registering new
adapter (Siano Rio Digital Receiver)
Jan 13 21:10:53 Linux kernel: [  458.056765] usb 1-1: DVB: registering
adapter 0 frontend 0 (Siano Mobile Digital MDTV Receiver)...
Jan 13 21:10:53 Linux kernel: [  458.056832] smscore_register_client:
ffff880079de6000 693 1
Jan 13 21:10:53 Linux kernel: [  458.056836] smscore_init_ir: IR port
has not been detected
Jan 13 21:10:53 Linux kernel: [  458.056840] smscore_start_device:
device ffff8800571d5000 started, rc 0
Jan 13 21:10:53 Linux kernel: [  458.056844] smsusb_init_device:
device 0xffff880079de7000 created
Jan 13 21:10:53 Linux kernel: [  458.056847] smsusb_probe: Device
initialized with return code 0
Jan 13 21:10:53 Linux mtp-probe: checking bus 1, device 7:
"/sys/devices/pci0000:00/0000:00:1d.7/usb1/1-1"
Jan 13 21:10:53 Linux mtp-probe: bus: 1, device: 7 was not an MTP device

and this part when I tried to scan a ferquency for channel:

Jan 13 21:14:00 Linux kernel: [  644.431456] smsusb_sendrequest:
sending MSG_SMS_RF_TUNE_REQ(561) size: 20
Jan 13 21:14:00 Linux kernel: [  644.431673] smsusb_onresponse:
received MSG_SMS_INTERFACE_LOCK_IND(805) size: 8
Jan 13 21:14:00 Linux kernel: [  644.431679] smscore_onresponse: data
rate 23 bytes/secs
Jan 13 21:14:00 Linux kernel: [  644.454431] smsusb_onresponse:
received MSG_SMS_INTERFACE_UNLOCK_IND(806) size: 8
Jan 13 21:14:00 Linux kernel: [  644.486557] smsusb_onresponse:
received MSG_SMS_TRANSMISSION_IND(782) size: 56
Jan 13 21:14:00 Linux kernel: [  644.486566] smscore_onresponse:
message MSG_SMS_TRANSMISSION_IND(782) not handled.
Jan 13 21:14:00 Linux kernel: [  644.486667] smsusb_onresponse:
received MSG_SMS_RF_TUNE_RES(562) size: 12
Jan 13 21:14:00 Linux kernel: [  644.597431] smsusb_onresponse:
received MSG_SMS_HO_INBAND_POWER_IND(631) size: 16
Jan 13 21:14:00 Linux kernel: [  644.597441] smscore_onresponse:
message MSG_SMS_HO_INBAND_POWER_IND(631) not handled.
Jan 13 21:14:00 Linux kernel: [  644.631525] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:00 Linux kernel: [  644.631678] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:00 Linux kernel: [  644.792179] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:00 Linux kernel: [  644.792188] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:00 Linux kernel: [  644.815548] smsusb_onresponse:
received MSG_SMS_SIGNAL_DETECTED_IND(827) size: 8
Jan 13 21:14:00 Linux kernel: [  644.815671] smsusb_onresponse:
received MSG_SMS_TRANSMISSION_IND(782) size: 56
Jan 13 21:14:00 Linux kernel: [  644.815677] smscore_onresponse:
message MSG_SMS_TRANSMISSION_IND(782) not handled.
Jan 13 21:14:00 Linux kernel: [  644.815794] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:00 Linux kernel: [  644.815799] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:00 Linux kernel: [  644.816668] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:00 Linux kernel: [  644.816673] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:00 Linux kernel: [  644.831763] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:00 Linux kernel: [  644.831925] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:00 Linux kernel: [  644.831999] smsusb_sendrequest:
sending MSG_SMS_ADD_PID_FILTER_REQ(601) size: 12
Jan 13 21:14:00 Linux kernel: [  644.832085] smsusb_sendrequest:
sending MSG_SMS_ADD_PID_FILTER_REQ(601) size: 12
Jan 13 21:14:00 Linux kernel: [  644.832170] smsusb_onresponse:
received MSG_SMS_ADD_PID_FILTER_RES(602) size: 12
Jan 13 21:14:00 Linux kernel: [  644.832299] smsusb_onresponse:
received MSG_SMS_ADD_PID_FILTER_RES(602) size: 12
Jan 13 21:14:00 Linux kernel: [  644.832328] smsusb_sendrequest:
sending MSG_SMS_ADD_PID_FILTER_REQ(601) size: 12
Jan 13 21:14:00 Linux kernel: [  644.832544] smsusb_onresponse:
received MSG_SMS_ADD_PID_FILTER_RES(602) size: 12
Jan 13 21:14:00 Linux kernel: [  644.890926] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:00 Linux kernel: [  644.890933] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:00 Linux kernel: [  644.990802] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:00 Linux kernel: [  644.990810] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:00 Linux kernel: [  645.090681] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:00 Linux kernel: [  645.090690] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:00 Linux kernel: [  645.099673] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:00 Linux kernel: [  645.099679] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:00 Linux kernel: [  645.191679] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:00 Linux kernel: [  645.191686] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:00 Linux kernel: [  645.291548] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:00 Linux kernel: [  645.291554] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:01 Linux kernel: [  645.391433] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:01 Linux kernel: [  645.391441] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:01 Linux kernel: [  645.492309] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:01 Linux kernel: [  645.492319] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:01 Linux kernel: [  645.592306] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:01 Linux kernel: [  645.592315] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:01 Linux kernel: [  645.692182] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:01 Linux kernel: [  645.692191] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:01 Linux kernel: [  645.792054] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:01 Linux kernel: [  645.792062] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:01 Linux kernel: [  645.800025] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:01 Linux kernel: [  645.800176] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:01 Linux kernel: [  645.813923] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:01 Linux kernel: [  645.813930] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:01 Linux kernel: [  645.891927] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:01 Linux kernel: [  645.891934] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:01 Linux kernel: [  645.948686] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:01 Linux kernel: [  645.948695] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:01 Linux kernel: [  645.991806] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:01 Linux kernel: [  645.991814] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:01 Linux kernel: [  646.092806] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:01 Linux kernel: [  646.092814] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:01 Linux kernel: [  646.192682] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:01 Linux kernel: [  646.192690] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:01 Linux kernel: [  646.292558] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:01 Linux kernel: [  646.292567] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:02 Linux kernel: [  646.392432] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:02 Linux kernel: [  646.392441] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:02 Linux kernel: [  646.432036] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:02 Linux kernel: [  646.432181] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:02 Linux kernel: [  646.493307] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:02 Linux kernel: [  646.493315] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:02 Linux kernel: [  646.594308] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:02 Linux kernel: [  646.594317] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:02 Linux kernel: [  646.694180] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:02 Linux kernel: [  646.694188] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:02 Linux kernel: [  646.715173] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:02 Linux kernel: [  646.715179] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:02 Linux kernel: [  646.820932] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:02 Linux kernel: [  646.820940] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:02 Linux kernel: [  646.908031] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:02 Linux kernel: [  646.908183] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:02 Linux kernel: [  646.919922] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:02 Linux kernel: [  646.919928] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:02 Linux kernel: [  647.019806] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:02 Linux kernel: [  647.019814] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:02 Linux kernel: [  647.080804] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:02 Linux kernel: [  647.080812] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:02 Linux kernel: [  647.119676] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:02 Linux kernel: [  647.119682] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:02 Linux kernel: [  647.219681] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:02 Linux kernel: [  647.219687] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:03 Linux kernel: [  647.316028] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:03 Linux kernel: [  647.316187] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:03 Linux kernel: [  647.319555] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:03 Linux kernel: [  647.319562] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:03 Linux kernel: [  647.420433] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:03 Linux kernel: [  647.420442] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:03 Linux kernel: [  647.520308] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:03 Linux kernel: [  647.520317] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:03 Linux kernel: [  647.620309] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:03 Linux kernel: [  647.620318] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:03 Linux kernel: [  647.716032] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:03 Linux kernel: [  647.721172] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:03 Linux kernel: [  647.721178] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:03 Linux kernel: [  647.723547] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:03 Linux kernel: [  647.821057] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:03 Linux kernel: [  647.821066] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:03 Linux kernel: [  647.921934] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:03 Linux kernel: [  647.921943] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:03 Linux kernel: [  648.021812] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:03 Linux kernel: [  648.021821] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:03 Linux kernel: [  648.121809] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:03 Linux kernel: [  648.121818] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:03 Linux kernel: [  648.152044] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:03 Linux kernel: [  648.152180] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:03 Linux kernel: [  648.213926] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:03 Linux kernel: [  648.213932] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:03 Linux kernel: [  648.221672] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:03 Linux kernel: [  648.221677] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:04 Linux kernel: [  648.322550] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:04 Linux kernel: [  648.322556] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:04 Linux kernel: [  648.422430] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 21:14:04 Linux kernel: [  648.422437] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:04 Linux kernel: [  648.523311] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:04 Linux kernel: [  648.523321] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:04 Linux kernel: [  648.624309] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:04 Linux kernel: [  648.624317] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:04 Linux kernel: [  648.632025] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:04 Linux kernel: [  648.632178] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:04 Linux kernel: [  648.666067] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:04 Linux kernel: [  648.666077] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:04 Linux kernel: [  648.765185] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:04 Linux kernel: [  648.765194] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:04 Linux kernel: [  648.866056] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:04 Linux kernel: [  648.866063] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:04 Linux kernel: [  648.965934] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:04 Linux kernel: [  648.965943] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:04 Linux kernel: [  649.065804] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:04 Linux kernel: [  649.065811] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:04 Linux kernel: [  649.165682] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:04 Linux kernel: [  649.165690] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:04 Linux kernel: [  649.176027] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:04 Linux kernel: [  649.176177] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:04 Linux kernel: [  649.266687] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:04 Linux kernel: [  649.266697] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:05 Linux kernel: [  649.345928] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:05 Linux kernel: [  649.345935] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:05 Linux kernel: [  649.370178] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:05 Linux kernel: [  649.370185] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:05 Linux kernel: [  649.469433] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 21:14:05 Linux kernel: [  649.469441] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:05 Linux kernel: [  649.569308] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:05 Linux kernel: [  649.569317] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:05 Linux kernel: [  649.670183] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:05 Linux kernel: [  649.670192] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:05 Linux kernel: [  649.771184] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:05 Linux kernel: [  649.771193] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:05 Linux kernel: [  649.792026] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:05 Linux kernel: [  649.792179] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:05 Linux kernel: [  649.872061] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:05 Linux kernel: [  649.872070] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:05 Linux kernel: [  649.972930] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:05 Linux kernel: [  649.972937] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:05 Linux kernel: [  650.072811] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:05 Linux kernel: [  650.072821] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:05 Linux kernel: [  650.173807] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:05 Linux kernel: [  650.173816] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:05 Linux kernel: [  650.273685] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:05 Linux kernel: [  650.273695] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:06 Linux kernel: [  650.374560] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:06 Linux kernel: [  650.374570] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:06 Linux kernel: [  650.474436] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:06 Linux kernel: [  650.474445] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:06 Linux kernel: [  650.480028] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:06 Linux kernel: [  650.480047] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:06 Linux kernel: [  650.480052] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:06 Linux kernel: [  650.480178] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:06 Linux kernel: [  650.574309] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:06 Linux kernel: [  650.574318] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:06 Linux kernel: [  650.601304] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:06 Linux kernel: [  650.601312] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:06 Linux kernel: [  650.701181] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:06 Linux kernel: [  650.701189] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:06 Linux kernel: [  650.802181] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:06 Linux kernel: [  650.802189] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:06 Linux kernel: [  650.838604] smsusb_sendrequest:
sending MSG_SMS_REMOVE_PID_FILTER_REQ(603) size: 12
Jan 13 21:14:06 Linux kernel: [  650.838798] smsusb_onresponse:
received MSG_SMS_REMOVE_PID_FILTER_RES(604) size: 12
Jan 13 21:14:06 Linux kernel: [  650.903059] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:06 Linux kernel: [  650.903069] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:06 Linux kernel: [  651.003932] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:06 Linux kernel: [  651.003941] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:06 Linux kernel: [  651.103809] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:06 Linux kernel: [  651.103818] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:06 Linux kernel: [  651.203682] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:06 Linux kernel: [  651.203690] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:06 Linux kernel: [  651.240026] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:06 Linux kernel: [  651.240178] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:07 Linux kernel: [  651.303678] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:07 Linux kernel: [  651.303684] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:07 Linux kernel: [  651.403559] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:07 Linux kernel: [  651.403566] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:07 Linux kernel: [  651.504430] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:07 Linux kernel: [  651.504436] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:07 Linux kernel: [  651.605311] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:07 Linux kernel: [  651.605320] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:07 Linux kernel: [  651.612057] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:07 Linux kernel: [  651.612064] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:07 Linux kernel: [  651.705184] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:07 Linux kernel: [  651.705194] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:07 Linux kernel: [  651.805183] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:07 Linux kernel: [  651.805192] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:07 Linux kernel: [  651.839764] smsusb_sendrequest:
sending MSG_SMS_REMOVE_PID_FILTER_REQ(603) size: 12
Jan 13 21:14:07 Linux kernel: [  651.839932] smsusb_onresponse:
received MSG_SMS_REMOVE_PID_FILTER_RES(604) size: 12
Jan 13 21:14:07 Linux kernel: [  651.905060] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:07 Linux kernel: [  651.905068] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:07 Linux kernel: [  652.005934] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:07 Linux kernel: [  652.005942] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:07 Linux kernel: [  652.068052] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:07 Linux kernel: [  652.068299] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:07 Linux kernel: [  652.105807] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:07 Linux kernel: [  652.105815] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:07 Linux kernel: [  652.205685] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:07 Linux kernel: [  652.205695] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:08 Linux kernel: [  652.306684] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:08 Linux kernel: [  652.306693] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:08 Linux kernel: [  652.407557] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:08 Linux kernel: [  652.407565] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:08 Linux kernel: [  652.507434] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:08 Linux kernel: [  652.507442] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:08 Linux kernel: [  652.608312] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:08 Linux kernel: [  652.608322] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:08 Linux kernel: [  652.708310] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:08 Linux kernel: [  652.708319] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:08 Linux kernel: [  652.745183] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:08 Linux kernel: [  652.745190] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:08 Linux kernel: [  652.809183] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:08 Linux kernel: [  652.809192] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:08 Linux kernel: [  652.890061] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:08 Linux kernel: [  652.890070] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:08 Linux kernel: [  652.960034] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:08 Linux kernel: [  652.960184] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:08 Linux kernel: [  652.988933] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:08 Linux kernel: [  652.988941] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:08 Linux kernel: [  653.088810] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:08 Linux kernel: [  653.088818] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:08 Linux kernel: [  653.189810] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:08 Linux kernel: [  653.189818] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:08 Linux kernel: [  653.289681] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:08 Linux kernel: [  653.289688] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:09 Linux kernel: [  653.389559] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:09 Linux kernel: [  653.389567] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:09 Linux kernel: [  653.490438] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:09 Linux kernel: [  653.490445] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:09 Linux kernel: [  653.591436] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:09 Linux kernel: [  653.591445] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:09 Linux kernel: [  653.691311] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:09 Linux kernel: [  653.691320] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:09 Linux kernel: [  653.791187] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:09 Linux kernel: [  653.791197] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:09 Linux kernel: [  653.879314] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:09 Linux kernel: [  653.879324] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:09 Linux kernel: [  653.892052] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:09 Linux kernel: [  653.892057] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:09 Linux kernel: [  653.908025] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:09 Linux kernel: [  653.908180] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:09 Linux kernel: [  653.991930] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:09 Linux kernel: [  653.991936] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:09 Linux kernel: [  654.091810] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:09 Linux kernel: [  654.091820] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:09 Linux kernel: [  654.192810] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:09 Linux kernel: [  654.192818] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:09 Linux kernel: [  654.292687] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:09 Linux kernel: [  654.292695] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:10 Linux kernel: [  654.392563] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:10 Linux kernel: [  654.392573] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:10 Linux kernel: [  654.492436] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:10 Linux kernel: [  654.492444] smscore_onresponse: data
rate 8151 bytes/secs
Jan 13 21:14:10 Linux kernel: [  654.492448] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:10 Linux kernel: [  654.593436] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:10 Linux kernel: [  654.593445] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:10 Linux kernel: [  654.693311] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:10 Linux kernel: [  654.693320] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:10 Linux kernel: [  654.794186] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:10 Linux kernel: [  654.794195] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:10 Linux kernel: [  654.894062] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:10 Linux kernel: [  654.894071] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:10 Linux kernel: [  654.904037] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:10 Linux kernel: [  654.904188] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:10 Linux kernel: [  654.993936] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:10 Linux kernel: [  654.993945] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:10 Linux kernel: [  655.012438] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:10 Linux kernel: [  655.012447] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:10 Linux kernel: [  655.094936] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:10 Linux kernel: [  655.094945] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:10 Linux kernel: [  655.194811] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:10 Linux kernel: [  655.194820] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:10 Linux kernel: [  655.294684] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:10 Linux kernel: [  655.294693] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:11 Linux kernel: [  655.380437] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:11 Linux kernel: [  655.380446] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:11 Linux kernel: [  655.480562] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:11 Linux kernel: [  655.480570] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:11 Linux kernel: [  655.580438] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:11 Linux kernel: [  655.580447] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:11 Linux kernel: [  655.681312] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:11 Linux kernel: [  655.681321] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:11 Linux kernel: [  655.781186] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:11 Linux kernel: [  655.781194] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:11 Linux kernel: [  655.885687] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:11 Linux kernel: [  655.885697] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:11 Linux kernel: [  655.948029] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:11 Linux kernel: [  655.948184] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:11 Linux kernel: [  655.985055] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:11 Linux kernel: [  655.985063] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:11 Linux kernel: [  656.085939] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:11 Linux kernel: [  656.085948] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:11 Linux kernel: [  656.145558] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:11 Linux kernel: [  656.145565] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:11 Linux kernel: [  656.185805] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:11 Linux kernel: [  656.185811] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:11 Linux kernel: [  656.285683] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:11 Linux kernel: [  656.285690] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:12 Linux kernel: [  656.386682] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:12 Linux kernel: [  656.386689] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:12 Linux kernel: [  656.487559] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:12 Linux kernel: [  656.487567] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:12 Linux kernel: [  656.587439] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:12 Linux kernel: [  656.587449] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:12 Linux kernel: [  656.687310] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:12 Linux kernel: [  656.687318] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:12 Linux kernel: [  656.788184] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:12 Linux kernel: [  656.788191] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:12 Linux kernel: [  656.889188] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:12 Linux kernel: [  656.889197] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:12 Linux kernel: [  656.989058] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:12 Linux kernel: [  656.989065] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:12 Linux kernel: [  657.032032] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:12 Linux kernel: [  657.032183] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:12 Linux kernel: [  657.088933] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:12 Linux kernel: [  657.088940] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:12 Linux kernel: [  657.188810] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:12 Linux kernel: [  657.188818] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:12 Linux kernel: [  657.277557] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:12 Linux kernel: [  657.277564] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:12 Linux kernel: [  657.288679] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:12 Linux kernel: [  657.288684] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:13 Linux kernel: [  657.389687] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:13 Linux kernel: [  657.389695] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:13 Linux kernel: [  657.489561] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:13 Linux kernel: [  657.489569] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:13 Linux kernel: [  657.590439] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:13 Linux kernel: [  657.590448] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:13 Linux kernel: [  657.690312] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:13 Linux kernel: [  657.690320] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:13 Linux kernel: [  657.790186] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:13 Linux kernel: [  657.790194] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:13 Linux kernel: [  657.858059] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:13 Linux kernel: [  657.858067] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:13 Linux kernel: [  657.958063] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:13 Linux kernel: [  657.958072] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:13 Linux kernel: [  658.058936] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:13 Linux kernel: [  658.058945] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:13 Linux kernel: [  658.156027] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:13 Linux kernel: [  658.156185] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:13 Linux kernel: [  658.158802] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:13 Linux kernel: [  658.158807] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:13 Linux kernel: [  658.259811] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:13 Linux kernel: [  658.259819] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:14 Linux kernel: [  658.359684] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:14 Linux kernel: [  658.359692] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:14 Linux kernel: [  658.410689] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:14 Linux kernel: [  658.410698] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:14 Linux kernel: [  658.459562] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:14 Linux kernel: [  658.459570] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:14 Linux kernel: [  658.559437] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:14 Linux kernel: [  658.559446] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:14 Linux kernel: [  658.659438] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:14 Linux kernel: [  658.659447] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:14 Linux kernel: [  658.759312] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:14 Linux kernel: [  658.759320] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:14 Linux kernel: [  658.859188] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:14 Linux kernel: [  658.859197] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:14 Linux kernel: [  658.959063] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:14 Linux kernel: [  658.959071] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:14 Linux kernel: [  659.058937] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:14 Linux kernel: [  659.058946] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:14 Linux kernel: [  659.158938] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:14 Linux kernel: [  659.158947] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:14 Linux kernel: [  659.259813] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:14 Linux kernel: [  659.259822] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:15 Linux kernel: [  659.308027] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:15 Linux kernel: [  659.318302] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:15 Linux kernel: [  659.359681] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:15 Linux kernel: [  659.359687] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:15 Linux kernel: [  659.459561] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:15 Linux kernel: [  659.459569] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:15 Linux kernel: [  659.542689] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:15 Linux kernel: [  659.542697] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:15 Linux kernel: [  659.565433] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:15 Linux kernel: [  659.565439] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:15 Linux kernel: [  659.665437] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:15 Linux kernel: [  659.665446] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:15 Linux kernel: [  659.765313] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:15 Linux kernel: [  659.765322] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:15 Linux kernel: [  659.866188] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:15 Linux kernel: [  659.866197] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:15 Linux kernel: [  659.966063] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:15 Linux kernel: [  659.966070] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:15 Linux kernel: [  660.066065] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:15 Linux kernel: [  660.066074] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:15 Linux kernel: [  660.165939] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:15 Linux kernel: [  660.165946] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:15 Linux kernel: [  660.265812] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:15 Linux kernel: [  660.265820] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:16 Linux kernel: [  660.335309] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:16 Linux kernel: [  660.335316] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:16 Linux kernel: [  660.433689] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:16 Linux kernel: [  660.433698] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:16 Linux kernel: [  660.492029] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:16 Linux kernel: [  660.492186] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:16 Linux kernel: [  660.534560] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:16 Linux kernel: [  660.534567] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:16 Linux kernel: [  660.634440] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:16 Linux kernel: [  660.634450] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:16 Linux kernel: [  660.676935] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:16 Linux kernel: [  660.676942] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:16 Linux kernel: [  660.735306] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:16 Linux kernel: [  660.735313] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:16 Linux kernel: [  660.835309] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:16 Linux kernel: [  660.835317] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:16 Linux kernel: [  660.849154] smsusb_sendrequest:
sending MSG_SMS_REMOVE_PID_FILTER_REQ(603) size: 12
Jan 13 21:14:16 Linux kernel: [  660.849309] smsusb_onresponse:
received MSG_SMS_REMOVE_PID_FILTER_RES(604) size: 12
Jan 13 21:14:16 Linux kernel: [  660.849394] smsusb_sendrequest:
sending MSG_SMS_RF_TUNE_REQ(561) size: 20
Jan 13 21:14:16 Linux kernel: [  660.849552] smsusb_onresponse:
received MSG_SMS_INTERFACE_LOCK_IND(805) size: 8
Jan 13 21:14:16 Linux kernel: [  660.867312] smsusb_onresponse:
received MSG_SMS_INTERFACE_UNLOCK_IND(806) size: 8
Jan 13 21:14:16 Linux kernel: [  660.899440] smsusb_onresponse:
received MSG_SMS_TRANSMISSION_IND(782) size: 56
Jan 13 21:14:16 Linux kernel: [  660.899450] smscore_onresponse:
message MSG_SMS_TRANSMISSION_IND(782) not handled.
Jan 13 21:14:16 Linux kernel: [  660.899554] smsusb_onresponse:
received MSG_SMS_RF_TUNE_RES(562) size: 12
Jan 13 21:14:16 Linux kernel: [  661.001940] smsusb_onresponse:
received MSG_SMS_HO_INBAND_POWER_IND(631) size: 16
Jan 13 21:14:16 Linux kernel: [  661.001949] smscore_onresponse:
message MSG_SMS_HO_INBAND_POWER_IND(631) not handled.
Jan 13 21:14:16 Linux kernel: [  661.049469] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:16 Linux kernel: [  661.049679] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:16 Linux kernel: [  661.249772] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:16 Linux kernel: [  661.249940] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:16 Linux kernel: [  661.258178] smsusb_onresponse:
received MSG_SMS_SIGNAL_DETECTED_IND(827) size: 8
Jan 13 21:14:16 Linux kernel: [  661.258304] smsusb_onresponse:
received MSG_SMS_TRANSMISSION_IND(782) size: 56
Jan 13 21:14:16 Linux kernel: [  661.258310] smscore_onresponse:
message MSG_SMS_TRANSMISSION_IND(782) not handled.
Jan 13 21:14:16 Linux kernel: [  661.258321] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:16 Linux kernel: [  661.258325] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:16 Linux kernel: [  661.259303] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:16 Linux kernel: [  661.259308] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:17 Linux kernel: [  661.302061] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:17 Linux kernel: [  661.302068] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:17 Linux kernel: [  661.450032] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:17 Linux kernel: [  661.450189] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:17 Linux kernel: [  661.450263] smsusb_sendrequest:
sending MSG_SMS_ADD_PID_FILTER_REQ(601) size: 12
Jan 13 21:14:17 Linux kernel: [  661.450327] smsusb_sendrequest:
sending MSG_SMS_ADD_PID_FILTER_REQ(601) size: 12
Jan 13 21:14:17 Linux kernel: [  661.450428] smsusb_onresponse:
received MSG_SMS_ADD_PID_FILTER_RES(602) size: 12
Jan 13 21:14:17 Linux kernel: [  661.450559] smsusb_onresponse:
received MSG_SMS_ADD_PID_FILTER_RES(602) size: 12
Jan 13 21:14:17 Linux kernel: [  661.450575] smsusb_sendrequest:
sending MSG_SMS_ADD_PID_FILTER_REQ(601) size: 12
Jan 13 21:14:17 Linux kernel: [  661.450680] smsusb_onresponse:
received MSG_SMS_ADD_PID_FILTER_RES(602) size: 12
Jan 13 21:14:17 Linux kernel: [  661.502939] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 21:14:17 Linux kernel: [  661.502948] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:17 Linux kernel: [  661.558438] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:17 Linux kernel: [  661.558447] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:17 Linux kernel: [  661.603817] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:17 Linux kernel: [  661.603827] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:17 Linux kernel: [  661.696035] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:17 Linux kernel: [  661.696187] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:17 Linux kernel: [  661.703680] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 21:14:17 Linux kernel: [  661.703686] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:17 Linux kernel: [  661.803563] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 21:14:17 Linux kernel: [  661.803570] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:17 Linux kernel: [  661.903439] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:17 Linux kernel: [  661.903448] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:17 Linux kernel: [  662.003320] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:17 Linux kernel: [  662.003329] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:17 Linux kernel: [  662.103316] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:17 Linux kernel: [  662.103325] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:17 Linux kernel: [  662.204191] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:17 Linux kernel: [  662.204199] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:17 Linux kernel: [  662.257061] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:17 Linux kernel: [  662.257068] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:18 Linux kernel: [  662.404941] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:18 Linux kernel: [  662.404950] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:18 Linux kernel: [  662.455562] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:18 Linux kernel: [  662.455569] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:18 Linux kernel: [  662.504941] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1888
Jan 13 21:14:18 Linux kernel: [  662.504950] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:18 Linux kernel: [  662.604817] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:18 Linux kernel: [  662.604826] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:18 Linux kernel: [  662.658067] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:18 Linux kernel: [  662.658076] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:18 Linux kernel: [  662.756691] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:18 Linux kernel: [  662.756700] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:18 Linux kernel: [  662.857567] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:18 Linux kernel: [  662.857575] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:18 Linux kernel: [  662.916035] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:18 Linux kernel: [  662.916186] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:18 Linux kernel: [  662.957432] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:18 Linux kernel: [  662.957439] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:18 Linux kernel: [  663.057316] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:18 Linux kernel: [  663.057324] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:18 Linux kernel: [  663.158314] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 21:14:18 Linux kernel: [  663.158321] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:18 Linux kernel: [  663.259187] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2264
Jan 13 21:14:18 Linux kernel: [  663.259194] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:19 Linux kernel: [  663.359061] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3204
Jan 13 21:14:19 Linux kernel: [  663.359068] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:19 Linux kernel: [  663.458940] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:19 Linux kernel: [  663.458947] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:19 Linux kernel: [  663.652818] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:19 Linux kernel: [  663.652828] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:19 Linux kernel: [  663.659807] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:19 Linux kernel: [  663.659814] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:19 Linux kernel: [  663.759686] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:19 Linux kernel: [  663.759693] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:19 Linux kernel: [  663.859568] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:19 Linux kernel: [  663.859577] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:19 Linux kernel: [  663.959440] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:19 Linux kernel: [  663.959449] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:19 Linux kernel: [  664.059317] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:19 Linux kernel: [  664.059327] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:19 Linux kernel: [  664.148031] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:19 Linux kernel: [  664.148190] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:19 Linux kernel: [  664.160306] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1888
Jan 13 21:14:19 Linux kernel: [  664.160313] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:19 Linux kernel: [  664.261187] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 21:14:19 Linux kernel: [  664.261195] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:20 Linux kernel: [  664.362067] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:20 Linux kernel: [  664.362077] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:20 Linux kernel: [  664.451690] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:20 Linux kernel: [  664.451698] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:20 Linux kernel: [  664.549936] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:20 Linux kernel: [  664.549943] smscore_onresponse: data
rate 7709 bytes/secs
Jan 13 21:14:20 Linux kernel: [  664.549947] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:20 Linux kernel: [  664.649817] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:20 Linux kernel: [  664.649826] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:20 Linux kernel: [  664.749693] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:20 Linux kernel: [  664.749702] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:20 Linux kernel: [  664.849565] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2076
Jan 13 21:14:20 Linux kernel: [  664.849575] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:20 Linux kernel: [  664.853431] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:20 Linux kernel: [  664.853437] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:20 Linux kernel: [  664.949563] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3768
Jan 13 21:14:20 Linux kernel: [  664.949570] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:20 Linux kernel: [  665.050315] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:20 Linux kernel: [  665.050323] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:20 Linux kernel: [  665.251191] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:20 Linux kernel: [  665.251201] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:21 Linux kernel: [  665.352063] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:21 Linux kernel: [  665.352071] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:21 Linux kernel: [  665.396028] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:21 Linux kernel: [  665.396186] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:21 Linux kernel: [  665.451939] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:21 Linux kernel: [  665.451948] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:21 Linux kernel: [  665.653819] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:21 Linux kernel: [  665.653828] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:21 Linux kernel: [  665.754687] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1700
Jan 13 21:14:21 Linux kernel: [  665.754694] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:21 Linux kernel: [  665.855566] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:21 Linux kernel: [  665.855575] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:21 Linux kernel: [  665.955562] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 21:14:21 Linux kernel: [  665.955569] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:21 Linux kernel: [  666.049689] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:21 Linux kernel: [  666.049697] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:21 Linux kernel: [  666.056433] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:21 Linux kernel: [  666.056439] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:21 Linux kernel: [  666.156318] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:21 Linux kernel: [  666.156327] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:21 Linux kernel: [  666.256189] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:21 Linux kernel: [  666.256197] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:21 Linux kernel: [  666.262682] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:21 Linux kernel: [  666.262689] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:22 Linux kernel: [  666.362187] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:22 Linux kernel: [  666.362194] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:22 Linux kernel: [  666.462065] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2264
Jan 13 21:14:22 Linux kernel: [  666.462072] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:22 Linux kernel: [  666.561937] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3204
Jan 13 21:14:22 Linux kernel: [  666.561944] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:22 Linux kernel: [  666.660050] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:22 Linux kernel: [  666.660193] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:22 Linux kernel: [  666.662807] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:22 Linux kernel: [  666.662814] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:22 Linux kernel: [  666.862562] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:22 Linux kernel: [  666.862570] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:22 Linux kernel: [  666.963562] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:22 Linux kernel: [  666.963569] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:22 Linux kernel: [  667.064446] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:22 Linux kernel: [  667.064456] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:22 Linux kernel: [  667.164319] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:22 Linux kernel: [  667.164328] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:22 Linux kernel: [  667.245817] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:22 Linux kernel: [  667.245825] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:22 Linux kernel: [  667.269820] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:22 Linux kernel: [  667.269829] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:23 Linux kernel: [  667.369068] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1700
Jan 13 21:14:23 Linux kernel: [  667.369077] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:23 Linux kernel: [  667.456215] smsusb_sendrequest:
sending MSG_SMS_REMOVE_PID_FILTER_REQ(603) size: 12
Jan 13 21:14:23 Linux kernel: [  667.456433] smsusb_onresponse:
received MSG_SMS_REMOVE_PID_FILTER_RES(604) size: 12
Jan 13 21:14:23 Linux kernel: [  667.469067] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 21:14:23 Linux kernel: [  667.469076] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:23 Linux kernel: [  667.569068] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:23 Linux kernel: [  667.569077] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:23 Linux kernel: [  667.669819] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:23 Linux kernel: [  667.669828] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:23 Linux kernel: [  667.770688] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:23 Linux kernel: [  667.770696] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:23 Linux kernel: [  667.870691] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 21:14:23 Linux kernel: [  667.870700] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:23 Linux kernel: [  667.936030] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:23 Linux kernel: [  667.936188] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:23 Linux kernel: [  667.970434] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:23 Linux kernel: [  667.970441] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:23 Linux kernel: [  668.043818] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:23 Linux kernel: [  668.043827] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:23 Linux kernel: [  668.143313] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2452
Jan 13 21:14:23 Linux kernel: [  668.143321] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:23 Linux kernel: [  668.243318] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1700
Jan 13 21:14:23 Linux kernel: [  668.243327] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:24 Linux kernel: [  668.441943] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:24 Linux kernel: [  668.441952] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:24 Linux kernel: [  668.445060] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:24 Linux kernel: [  668.445066] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:24 Linux kernel: [  668.457389] smsusb_sendrequest:
sending MSG_SMS_REMOVE_PID_FILTER_REQ(603) size: 12
Jan 13 21:14:24 Linux kernel: [  668.457557] smsusb_onresponse:
received MSG_SMS_REMOVE_PID_FILTER_RES(604) size: 12
Jan 13 21:14:24 Linux kernel: [  668.544944] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:24 Linux kernel: [  668.544953] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:24 Linux kernel: [  668.644817] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:24 Linux kernel: [  668.644823] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:24 Linux kernel: [  668.845693] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:24 Linux kernel: [  668.845702] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:24 Linux kernel: [  668.945570] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2640
Jan 13 21:14:24 Linux kernel: [  668.945579] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:24 Linux kernel: [  669.045444] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:24 Linux kernel: [  669.045453] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:24 Linux kernel: [  669.145442] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1700
Jan 13 21:14:24 Linux kernel: [  669.145450] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:24 Linux kernel: [  669.228027] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:24 Linux kernel: [  669.228191] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:24 Linux kernel: [  669.246184] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:24 Linux kernel: [  669.246191] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:25 Linux kernel: [  669.346193] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:25 Linux kernel: [  669.346202] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:25 Linux kernel: [  669.446066] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:25 Linux kernel: [  669.446073] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:25 Linux kernel: [  669.545945] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:25 Linux kernel: [  669.545953] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:25 Linux kernel: [  669.638187] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:25 Linux kernel: [  669.638194] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:25 Linux kernel: [  669.645939] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 21:14:25 Linux kernel: [  669.645946] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:25 Linux kernel: [  669.693195] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2452
Jan 13 21:14:25 Linux kernel: [  669.693204] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:25 Linux kernel: [  669.793694] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:25 Linux kernel: [  669.793703] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:25 Linux kernel: [  669.893569] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:25 Linux kernel: [  669.893578] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:25 Linux kernel: [  669.994565] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:25 Linux kernel: [  669.994572] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:25 Linux kernel: [  670.095439] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:25 Linux kernel: [  670.095446] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:25 Linux kernel: [  670.196313] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:25 Linux kernel: [  670.196319] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:25 Linux kernel: [  670.297195] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:25 Linux kernel: [  670.297205] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:26 Linux kernel: [  670.498069] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1888
Jan 13 21:14:26 Linux kernel: [  670.498078] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:26 Linux kernel: [  670.520030] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:26 Linux kernel: [  670.520191] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:26 Linux kernel: [  670.598939] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:26 Linux kernel: [  670.598947] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:26 Linux kernel: [  670.698819] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 21:14:26 Linux kernel: [  670.698828] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:26 Linux kernel: [  670.799687] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:26 Linux kernel: [  670.799694] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:26 Linux kernel: [  670.837686] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:26 Linux kernel: [  670.837692] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:26 Linux kernel: [  670.899686] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:26 Linux kernel: [  670.899692] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:26 Linux kernel: [  671.100443] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1512
Jan 13 21:14:26 Linux kernel: [  671.100452] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:26 Linux kernel: [  671.200320] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:26 Linux kernel: [  671.200330] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:27 Linux kernel: [  671.300316] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3768
Jan 13 21:14:27 Linux kernel: [  671.300324] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:27 Linux kernel: [  671.400187] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:27 Linux kernel: [  671.400193] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:27 Linux kernel: [  671.500066] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:27 Linux kernel: [  671.500074] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:27 Linux kernel: [  671.599945] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:27 Linux kernel: [  671.599954] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:27 Linux kernel: [  671.699820] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:27 Linux kernel: [  671.699829] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:27 Linux kernel: [  671.812033] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:27 Linux kernel: [  671.815684] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:27 Linux kernel: [  671.900563] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:27 Linux kernel: [  671.900569] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:27 Linux kernel: [  672.002945] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:27 Linux kernel: [  672.002953] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:27 Linux kernel: [  672.037196] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:27 Linux kernel: [  672.037205] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:27 Linux kernel: [  672.103445] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1700
Jan 13 21:14:27 Linux kernel: [  672.103454] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:27 Linux kernel: [  672.203317] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:27 Linux kernel: [  672.203324] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:28 Linux kernel: [  672.303317] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:28 Linux kernel: [  672.303324] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:28 Linux kernel: [  672.404190] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:28 Linux kernel: [  672.404196] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:28 Linux kernel: [  672.505068] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:28 Linux kernel: [  672.505076] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:28 Linux kernel: [  672.604949] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:28 Linux kernel: [  672.604958] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:28 Linux kernel: [  672.705820] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 21:14:28 Linux kernel: [  672.705830] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:28 Linux kernel: [  672.806693] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:28 Linux kernel: [  672.806701] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:28 Linux kernel: [  672.906693] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 21:14:28 Linux kernel: [  672.906701] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:28 Linux kernel: [  673.006570] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:28 Linux kernel: [  673.006579] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:28 Linux kernel: [  673.104034] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:28 Linux kernel: [  673.104195] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:28 Linux kernel: [  673.206316] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:28 Linux kernel: [  673.206324] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:28 Linux kernel: [  673.234563] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:28 Linux kernel: [  673.234570] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:29 Linux kernel: [  673.306317] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:29 Linux kernel: [  673.306326] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:29 Linux kernel: [  673.406188] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:29 Linux kernel: [  673.406195] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:29 Linux kernel: [  673.606944] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:29 Linux kernel: [  673.606953] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:29 Linux kernel: [  673.706947] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1700
Jan 13 21:14:29 Linux kernel: [  673.706956] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:29 Linux kernel: [  673.806815] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:29 Linux kernel: [  673.806821] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:29 Linux kernel: [  673.857691] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:29 Linux kernel: [  673.857698] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:29 Linux kernel: [  673.958696] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 21:14:29 Linux kernel: [  673.958705] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:29 Linux kernel: [  674.058567] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:29 Linux kernel: [  674.058575] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:29 Linux kernel: [  674.158442] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:29 Linux kernel: [  674.158450] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:29 Linux kernel: [  674.258317] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:29 Linux kernel: [  674.258324] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:30 Linux kernel: [  674.358193] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1136
Jan 13 21:14:30 Linux kernel: [  674.358201] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:30 Linux kernel: [  674.396029] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:30 Linux kernel: [  674.396191] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:30 Linux kernel: [  674.431817] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:30 Linux kernel: [  674.431824] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:30 Linux kernel: [  674.458188] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2076
Jan 13 21:14:30 Linux kernel: [  674.458194] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:30 Linux kernel: [  674.558068] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2640
Jan 13 21:14:30 Linux kernel: [  674.558075] smscore_onresponse: data
rate 9199 bytes/secs
Jan 13 21:14:30 Linux kernel: [  674.558079] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:30 Linux kernel: [  674.657946] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:30 Linux kernel: [  674.657954] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:30 Linux kernel: [  674.858696] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:30 Linux kernel: [  674.858706] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:30 Linux kernel: [  674.958693] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:30 Linux kernel: [  674.958701] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:30 Linux kernel: [  675.058565] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:30 Linux kernel: [  675.058571] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:30 Linux kernel: [  675.158444] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:30 Linux kernel: [  675.158452] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:30 Linux kernel: [  675.259317] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:30 Linux kernel: [  675.259324] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:31 Linux kernel: [  675.359319] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1700
Jan 13 21:14:31 Linux kernel: [  675.359327] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:31 Linux kernel: [  675.460192] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:31 Linux kernel: [  675.460199] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:31 Linux kernel: [  675.561071] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:31 Linux kernel: [  675.561079] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:31 Linux kernel: [  675.627945] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:31 Linux kernel: [  675.627954] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:31 Linux kernel: [  675.660946] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:31 Linux kernel: [  675.660954] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:31 Linux kernel: [  675.688051] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:31 Linux kernel: [  675.688692] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:31 Linux kernel: [  675.760823] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:31 Linux kernel: [  675.760832] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:31 Linux kernel: [  675.861817] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:31 Linux kernel: [  675.861823] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:31 Linux kernel: [  675.863062] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:31 Linux kernel: [  675.863068] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:31 Linux kernel: [  675.961695] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:31 Linux kernel: [  675.961703] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:31 Linux kernel: [  676.062574] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:31 Linux kernel: [  676.062583] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:31 Linux kernel: [  676.162569] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 3956
Jan 13 21:14:31 Linux kernel: [  676.162576] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:31 Linux kernel: [  676.262320] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:31 Linux kernel: [  676.262328] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:32 Linux kernel: [  676.462195] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:32 Linux kernel: [  676.462203] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:32 Linux kernel: [  676.562075] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:32 Linux kernel: [  676.562084] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:32 Linux kernel: [  676.661950] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:32 Linux kernel: [  676.661959] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:32 Linux kernel: [  676.824197] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:32 Linux kernel: [  676.824207] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:32 Linux kernel: [  676.861816] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:32 Linux kernel: [  676.861823] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:32 Linux kernel: [  676.961695] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2076
Jan 13 21:14:32 Linux kernel: [  676.961703] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:32 Linux kernel: [  676.980019] smsusb_sendrequest:
sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Jan 13 21:14:32 Linux kernel: [  676.980186] smsusb_onresponse:
received MSG_SMS_GET_STATISTICS_RES(616) size: 224
Jan 13 21:14:32 Linux kernel: [  677.061570] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 1324
Jan 13 21:14:32 Linux kernel: [  677.061577] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:32 Linux kernel: [  677.161444] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:32 Linux kernel: [  677.161451] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:32 Linux kernel: [  677.261319] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:32 Linux kernel: [  677.261325] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:33 Linux kernel: [  677.361325] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:33 Linux kernel: [  677.361334] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:33 Linux kernel: [  677.461197] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 572
Jan 13 21:14:33 Linux kernel: [  677.461206] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:33 Linux kernel: [  677.466651] smsusb_sendrequest:
sending MSG_SMS_REMOVE_PID_FILTER_REQ(603) size: 12
Jan 13 21:14:33 Linux kernel: [  677.482951] smsusb_onresponse:
received MSG_SMS_REMOVE_PID_FILTER_RES(604) size: 12
Jan 13 21:14:33 Linux kernel: [  677.562074] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 948
Jan 13 21:14:33 Linux kernel: [  677.562084] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:33 Linux kernel: [  677.662065] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2076
Jan 13 21:14:33 Linux kernel: [  677.662073] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:33 Linux kernel: [  677.684070] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:33 Linux kernel: [  677.684076] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:33 Linux kernel: [  677.783948] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 2452
Jan 13 21:14:33 Linux kernel: [  677.783958] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:33 Linux kernel: [  677.883696] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:33 Linux kernel: [  677.883705] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:33 Linux kernel: [  677.983695] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 384
Jan 13 21:14:33 Linux kernel: [  677.983702] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:33 Linux kernel: [  678.020323] smsusb_onresponse:
received MSG_SMS_HO_PER_SLICES_IND(630) size: 108
Jan 13 21:14:33 Linux kernel: [  678.020332] smscore_onresponse:
message MSG_SMS_HO_PER_SLICES_IND(630) not handled.
Jan 13 21:14:33 Linux kernel: [  678.084574] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 760
Jan 13 21:14:33 Linux kernel: [  678.084582] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:33 Linux kernel: [  678.184448] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:33 Linux kernel: [  678.184457] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
Jan 13 21:14:33 Linux kernel: [  678.284323] smsusb_onresponse:
received MSG_SMS_DAB_CHANNEL(607) size: 196
Jan 13 21:14:33 Linux kernel: [  678.284331] smscore_onresponse:
message MSG_SMS_DAB_CHANNEL(607) not handled.
...
...

Any idea?

Regards

Francesco


2015-01-13 17:13 GMT+01:00 Roberto Alcântara <roberto@eletronica.org>:
> Good to know about DVB on this chip. This is sms2270 id :-)
>
> I think you can get more  information from module debug messages.
>
> Try
>         options smsusb debug=3
> on /etc/modprobe.d.
>
> Then reload it and try to tzap one of channels found by scan to look
> for some lock.  You will have more debug messages now.
>
> Cheers,
>  - Roberto
>
>
>
>
>  - Roberto
>
>
> On Tue, Jan 13, 2015 at 12:35 PM, Francesco Other
> <francesco.other@gmail.com> wrote:
>> Hi Roberto, thanks for your fast reply.
>>
>> I'm from Italy, a DVB-T region. With Windows the device works fine, it
>> receives all the channels from multiplexes.
>> I don't know if my device has the SMS2270 chip, I know the ID,
>> 187f:0600, and the link on the Terratec site:
>> http://www.terratec.net/details.php?artnr=145258#.VLU5Z2SG9LY
>>
>> In that site there are the software and the Windows driver, if you
>> install those driver you can obtain the dvb_rio.inp driver from
>> system32 folder.
>> I forced the DVB-T mode because without it in dmesg output I see that
>> system ask for isdbt_rio.inp, but with DVB-T forced mode the system
>> ask for dvb_rio.inp.
>>
>> I can't understand why I can't receive any channels from multiplexes,
>> the signal is ok, I can see this from many software (Kaffeine, w_scan,
>> scan, TvHeadend).
>>
>> Can you help me please?
>>
>> Best Regards
>>
>> Francesco
>>
>>
>> 2015-01-13 16:21 GMT+01:00 Roberto Alcântara <roberto@eletronica.org>:
>>> Hi Francesco,
>>>
>>> You are using Siano SMS2270, am I right?
>>>
>>> My guess you're using ISDB-T firmware to program your ic, but are you in
>>> ISDB-T region? I use same firmware name here and works fine (Brazil) and it
>>> seems loaded ok on your log.
>>>
>>> I never saw an DVB firmware available to sms2270. Your tuner is working fine
>>> under Windows with provided software ?
>>>
>>> Cheers,
>>>   - Roberto
>>>
>>>
>>>
>>>
>>>
>>>
>>>  - Roberto
>>>
>>> On Tue, Jan 13, 2015 at 11:50 AM, Francesco Other
>>> <francesco.other@gmail.com> wrote:
>>>>
>>>> Is there a gentleman that can help me with my problem? On linuxtv.org
>>>> they said that someone here sure will help me.
>>>>
>>>> I submitted the problem here:
>>>> http://www.spinics.net/lists/linux-media/msg85432.html
>>>>
>>>> Regards
>>>>
>>>> Francesco
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
