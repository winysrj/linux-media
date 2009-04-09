Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37342 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936354AbZDIUbS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2009 16:31:18 -0400
Message-ID: <49DE5B0F.6080604@iki.fi>
Date: Thu, 09 Apr 2009 23:31:11 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: chrisneilbrown@gmail.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] AVerTV Volar DVB-T USB GPS 805
References: <91591f560904090409x15481f87ra1d7211ec35bc569@mail.gmail.com> <49DDD897.4000409@iki.fi>
In-Reply-To: <49DDD897.4000409@iki.fi>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari wrote:
> Chris Brown wrote:
>> This device doesnt seem to work
>> I've tried several different modules referenced in the dvb-t usb page on 
>> linuxtv
>> Any ideas?
>>
>> Bus 001 Device 003: ID 07ca:a805 AVerMedia Technologies, Inc.
>> Bus 001 Device 004: ID 0471:082d Philips
>> Bus 001 Device 002: ID 0409:005a NEC Corp. HighSpeed Hub
> 
> What does lsusb -vv -d 07ca:a805 says?

That was af9015 with MXL5003S (tuner ID 13). It is now working and patch 
is waiting for PULL to the master, will request that soon.
http://linuxtv.org/hg/~anttip/af9015

thanks
Antti
-- 
http://palosaari.fi/
