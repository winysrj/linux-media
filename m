Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:32815 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbaEDWjT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 May 2014 18:39:19 -0400
Received: by mail-ve0-f181.google.com with SMTP id pa12so6946983veb.12
        for <linux-media@vger.kernel.org>; Sun, 04 May 2014 15:39:19 -0700 (PDT)
Received: from [192.168.25.238] (179.186.152.67.dynamic.adsl.gvt.net.br. [179.186.152.67])
        by mx.google.com with ESMTPSA id xr10sm8994086vec.2.2014.05.04.15.39.16
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 04 May 2014 15:39:18 -0700 (PDT)
From: Roberto Alcantara <roberto@eletronica.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Subject: Siano SMS2270 @ kernel 3.4.75 - Problem after DVB3_EVENT_UNC_OK 
Message-Id: <5FEF438E-E79C-4A6D-9494-C376A6CA99AF@eletronica.org>
Date: Sun, 4 May 2014 19:39:14 -0300
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

I’m still trying to make my ISDB-T tuner run in my development board with A20 soc. I'm trying to backport media-tree siano drivers to kernel 3.4.75. With a few changes in Makefiles to fit new directory structure and disabling IR I could compile and load the modules. No errors reported on loading or compiling.

But as I don’t know enough DVB structure, something still wrong. When I scan without antenna, no problems. But when I plug my antenna and scan starts on frequency with signal presence, I have

DVB3_EVENT_FE_LOCK and DVB3_EVENT_UNC_OK  messages and a lot of MSG_SMS_DVBT_BDA_DATA messages. These messages stops only when I remove usb tuner.

Can you guys give any tip or documentation to clarify this DVB section? I’m trying read DVB docs for now.

Thank you !

Best regards,
 - Roberto

root@awsom:~# dvbv5-scan freq.conf 
<7>sms_board_dvb3_event: DVB3_EVENT_INIT
<7>smsdvb_get_tune_settings: 
<6>smsdvb_isdbt_set_frontend: smsdvb_isdbt_set_frontend: freq 473142857 segwidth 0 segindex 0
<7>smsusb_sendrequest: sending MSG_SMS_ISDBT_TUNE_REQ(776) size: 24
INFO     Scanning frequency<7>smsusb_onresponse: received MSG_SMS_ISDBT_TUNE_RES(777) size: 12
<7>smscore_onresponse: data rate 40 bytes/secs
 #1 473142857
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
<7>sms_board_dvb3_event: DVB3_EVENT_FE_UNLOCK
       (0x00) Signal= 100.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 100.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_onresponse: received MSG_SMS_NO_SIGNAL_IND(828) size: 8
<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0

...(cut repeated msg)

       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsdvb_get_tune_settings: 
<6>smsdvb_isdbt_set_frontend: smsdvb_isdbt_set_frontend: freq 479142857 segwidth 0 segindex 0
INFO     Scanning frequ<7>smsusb_sendrequest: sending MSG_SMS_ISDBT_TUNE_REQ(776) size: 24
ency #2 479142857
<7>smsusb_onresponse: received MSG_SMS_ISDBT_TUNE_RES(777) size: 12
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_onresponse: received MSG_SMS_INTERFACE_LOCK_IND(805) size: 8
<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
<7>smsusb_onresponse: received MSG_SMS_INTERFACE_UNLOCK_IND(806) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
<7>smsusb_onresponse: received MSG_SMS_NO_SIGNAL_IND(828) size: 8
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0

...(cut repeated msg)

       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsdvb_get_tune_settings: 
<6>smsdvb_isdbt_set_frontend: smsdvb_isdbt_set_frontend: freq 485142857 segwidth 0 segindex 0
INFO     Scanning frequ<7>smsusb_sendrequest: sending MSG_SMS_ISDBT_TUNE_REQ(776) size: 24
ency #3 485142857
<7>smsusb_onresponse: received MSG_SMS_ISDBT_TUNE_RES(777) size: 12
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_onresponse: received MSG_SMS_NO_SIGNAL_IND(828) size: 8
       (0x00) Signal= 0.00%<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0

...(cut repeated msg)

       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsdvb_get_tune_settings: 
<6>smsdvb_isdbt_set_frontend: smsdvb_isdbt_set_frontend: freq 491142857 segwidth 0 segindex 0
INFO     Scanning frequ<7>smsusb_sendrequest: sending MSG_SMS_ISDBT_TUNE_REQ(776) size: 24
ency #4 491142857
<7>smsusb_onresponse: received MSG_SMS_ISDBT_TUNE_RES(777) size: 12
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_onresponse: received MSG_SMS_INTERFACE_LOCK_IND(805) size: 8
<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_onresponse: received MSG_SMS_NO_SIGNAL_IND(828) size: 8
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsdvb_get_tune_settings: 
<6>smsdvb_isdbt_set_frontend: smsdvb_isdbt_set_frontend: freq 497142857 segwidth 0 segindex 0
INFO     Scanning frequ<7>smsusb_sendrequest: sending MSG_SMS_ISDBT_TUNE_REQ(776) size: 24
ency #5 497142857
<7>smsusb_onresponse: received MSG_SMS_ISDBT_TUNE_RES(777) size: 12
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00%<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
 C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
       (0x00) Signal= 0.00% C/N= 0.00% UCB= 0 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.40% UCB= 260 postBER= 0
       (0x00) Signal= 0.00% C/N= 0.40% UCB= 260 postBER= 0
       (0x00) Signal= 0.00% C/N= 0.43% UCB= 280 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.37% UCB= 240 postBER= 0
       (0x00) Signal= 0.00% C/N= 0.37% UCB= 240 postBER= 0
<7>smsusb_onresponse: received MSG_SMS_GET_STATISTICS_EX_RES(654) size: 296
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.37% UCB= 240 postBER= 0
<7>smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_EX_REQ(653) size: 8
       (0x00) Signal= 0.00% C/N= 0.37% UCB= 240 postBER= 0
<7>smsusb_onresponse: received MSG_SMS_SIGNAL_DETECTED_IND(827) size: 8
<7>sms_board_dvb3_event: DVB3_EVENT_FE_LOCK
<7>sms_board_dvb3_event: DVB3_EVENT_UNC_OK
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768
<7>smsusb_onresponse: received MSG_SMS_DVBT_BDA_DATA(693) size: 3768

