Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40297 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbZIUOTh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 10:19:37 -0400
Message-ID: <4AB78B79.3030203@iki.fi>
Date: Mon, 21 Sep 2009 17:19:37 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Roman <lists@hasnoname.de>
CC: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: MSI Digivox mini III Remote Control
References: <200909202026.27086.lists@hasnoname.de> <200909211555.11747.lists@hasnoname.de> <4AB7870D.3030300@iki.fi> <200909211610.52856.lists@hasnoname.de>
In-Reply-To: <200909211610.52856.lists@hasnoname.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Roman wrote:
> Am Monday 21 September 2009 16:00:45 schrieb Antti Palosaari:
>> For reason or the other there is no any mention about remote polling.
>> Could you enable debug=3 to see what eeprom value is set to remote?
>> rmmod dvb-usb-af9015; modprobe dvb-usb-af9015 debug=3;
>>
>> Antti
> 
> Here is the output of dmesg after reloading the module:
> #--
> af9015_usb_probe: interface:0
> af9015_read_config: IR mode:4

IR mode 4 disables it. I have strong feeling it should mean "polling"...
Could you change af9015.c around line 720:
from: if (val == AF9015_IR_MODE_DISABLED || val == 0x04) {
to: if (val == AF9015_IR_MODE_DISABLED) {

and test again.
Antti
-- 
http://palosaari.fi/
