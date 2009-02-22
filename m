Return-path: <linux-media-owner@vger.kernel.org>
Received: from rupert.bearstech.com ([193.84.18.54]:59912 "EHLO
	rupert.bearstech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbZBVNxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 08:53:23 -0500
Message-ID: <49A158D0.1030304@bearstech.com>
Date: Sun, 22 Feb 2009 14:53:20 +0100
From: Laurent Haond <lhaond@bearstech.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Can I use AVerTV Volar Black HD (A850) with Linux
 ?
References: <499F5452.6050205@bearstech.com> <7a3c9e3d0902210108w77e440e2u6d688f3614ccf972@mail.gmail.com> <499FEF0A.2070001@bearstech.com> <49A02E23.9020807@iki.fi>
In-Reply-To: <49A02E23.9020807@iki.fi>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, thanks for your support Antti !

> Hello and thank you for information,
> 
> According to your previous post, you are correct. I did one of the most
> typical mistake when adding new usb-id:s :) (didn't increase
> .num_device_descs).
> 
> Laurent Haond wrote:
>> af9015_usb_probe: interface:0
>> af9015_read_config: IR mode:0
> 
> Is there remote at all?
No there is not remote at all in the bundle.

> 
>> af9015_read_config: TS mode:1
>> af9015_read_config: [0] xtal:2 set adc_clock:28000
>> af9015_read_config: [0] IF1:36125
> 
> hmmm, typical IF for many DVB-T tuners but very strange for MXL5003S.
> Maxlinear uses normally / default 4570kHz. I think thats why it does not
> work. Could you change .if_freq to IF_FREQ_36125000HZ and test?

Tried, but same results...

> AVerMedia seems to use many times very weird configurations that are not
> reference nor default ones.
> 
>> af9015_read_config: [0] MT2060 IF1:0
>> af9015_read_config: [0] tuner id:13
>> af9015_read_config: [1] xtal:2 set adc_clock:28000
>> af9015_read_config: [1] IF1:36125
>> af9015_read_config: [1] MT2060 IF1:1220
>> af9015_read_config: [1] tuner id:130
>> af9015_identify_state: reply:01
> 
>> af9015_copy_firmware:
>> af9015: command failed:2
>> af9015: firmware copy to 2nd frontend failed, will disable it
>> dvb-usb: no frontend was attached by 'AVerMedia A850'
>> dvb-usb: AVerMedia A850 successfully initialized and connected.
> 
> No knowledge why it fails. I suspect wrong GPIO, again this is AverMedia
> device... You should take usb-sniff and look correct GPIO from there.

I trying to do that, but i'm not able  to find a recent and working
repository for usbreplay and parser.pl

Seems that http://mcentral.de/wiki/index.php5/Usbreplay is out of date,
and that http://mcentral.de/hg/~mrec/usbreplay is no more available.

Can you point me to a working repository where i can get them ?

Thanks

Laurent

