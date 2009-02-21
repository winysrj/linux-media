Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37126 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbZBUQjF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 11:39:05 -0500
Message-ID: <49A02E23.9020807@iki.fi>
Date: Sat, 21 Feb 2009 18:38:59 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Laurent Haond <lhaond@bearstech.com>
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Can I use AVerTV Volar Black HD (A850) with Linux
 ?
References: <499F5452.6050205@bearstech.com> <7a3c9e3d0902210108w77e440e2u6d688f3614ccf972@mail.gmail.com> <499FEF0A.2070001@bearstech.com>
In-Reply-To: <499FEF0A.2070001@bearstech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello and thank you for information,

According to your previous post, you are correct. I did one of the most 
typical mistake when adding new usb-id:s :) (didn't increase 
.num_device_descs).

Laurent Haond wrote:
> af9015_usb_probe: interface:0
> af9015_read_config: IR mode:0

Is there remote at all?

> af9015_read_config: TS mode:1
> af9015_read_config: [0] xtal:2 set adc_clock:28000
> af9015_read_config: [0] IF1:36125

hmmm, typical IF for many DVB-T tuners but very strange for MXL5003S. 
Maxlinear uses normally / default 4570kHz. I think thats why it does not 
work. Could you change .if_freq to IF_FREQ_36125000HZ and test? 
AVerMedia seems to use many times very weird configurations that are not 
reference nor default ones.

> af9015_read_config: [0] MT2060 IF1:0
> af9015_read_config: [0] tuner id:13
> af9015_read_config: [1] xtal:2 set adc_clock:28000
> af9015_read_config: [1] IF1:36125
> af9015_read_config: [1] MT2060 IF1:1220
> af9015_read_config: [1] tuner id:130
> af9015_identify_state: reply:01

> af9015_copy_firmware:
> af9015: command failed:2
> af9015: firmware copy to 2nd frontend failed, will disable it
> dvb-usb: no frontend was attached by 'AVerMedia A850'
> dvb-usb: AVerMedia A850 successfully initialized and connected.

No knowledge why it fails. I suspect wrong GPIO, again this is AverMedia 
device... You should take usb-sniff and look correct GPIO from there.

> af9015_init:
> af9015_init_endpoint: USB speed:3
> af9015_download_ir_table:
> 
> 
> dvbscan fails with this error : Unable to query frontend status
> and sometimes (not everytimes) dmesg shows :
> af9015: recv bulk message failed:-110
> af9013: I2C read failed reg:d417

regards
Antti
-- 
http://palosaari.fi/
