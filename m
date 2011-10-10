Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59387 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab1JJTXM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Oct 2011 15:23:12 -0400
Message-ID: <4E93461D.2020804@iki.fi>
Date: Mon, 10 Oct 2011 22:23:09 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Johannes Stezenbach <js@linuxtv.org>
CC: linux-media@vger.kernel.org
Subject: Re: Cypress EZ-USB FX2 firmware development
References: <4E8B61FF.8000505@iki.fi> <20111004212901.GA20648@linuxtv.org> <20111006124717.GA9110@linuxtv.org> <4E8DA8CC.5080903@iki.fi>
In-Reply-To: <4E8DA8CC.5080903@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/06/2011 04:10 PM, Antti Palosaari wrote:
> On 10/06/2011 03:47 PM, Johannes Stezenbach wrote:
>> On Tue, Oct 04, 2011 at 11:29:01PM +0200, Johannes Stezenbach wrote:
>>> On Tue, Oct 04, 2011 at 10:43:59PM +0300, Antti Palosaari wrote:
>>>> I would like to made own firmware for Cypress FX2 based DVB device.
>>>> Is there any sample to look example?
>>>
>>> http://linuxtv.org/cgi-bin/viewvc.cgi/dvb-hw/dvbusb-fx2/termini/
>>
>> PS: If you haven't found it already, there is also fx2lib:
>> https://github.com/mulicheng/fx2lib
>> http://sourceforge.net/projects/fx2lib/
>>
>> Johannes
>
> Thank you! I already looked those termini project files and it was kinda
> jackpot. Much more than I ever imagined. I will try to compile it next
> weekend and upload to my FX2 device to see if I can get at least control
> for I2C-bus.

After very long hack sessions during weekend I got it working. I2C was 
easy stuff, streaming video was more challenging.

Antti
-- 
http://palosaari.fi/
