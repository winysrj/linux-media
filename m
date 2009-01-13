Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36170 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbZAMQN2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2009 11:13:28 -0500
Message-ID: <496CBDA3.6070305@iki.fi>
Date: Tue, 13 Jan 2009 18:13:23 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Lindsay Mathieson <lindsay.mathieson@gmail.com>
CC: linux-dvb@linuxtv.org, linux-media@vger.kernel.org,
	Mark Spieth <mark@digivation.com.au>
Subject: Re: [linux-dvb] af9015
References: <200901122023.43128.lindsay.mathieson@gmail.com> <496B8DE7.2070500@iki.fi>
In-Reply-To: <496B8DE7.2070500@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari wrote:
> Lindsay Mathieson wrote:
>> I see the trunk now supports the DigitalNow TinyTwin (af9015), but 
>> only for one tuner. Is it possible to enable the second tuner or are 
>> there still issues with that?
> 
> Yes it is possible to enable second tuner by module param, modprobe 
> dvb-usb-af9015 dual_mode=1. But I just tested and looks like no picture 
> at all from 2nd tuner. I have no idea when it was gone totally broken... 
> Anyhow, on single mode it should work 100% well.

Bug found and fixed. There was MPEG2 TS buffer size zero bytes for 2nd 
FE defined always... For my short test dual tuner mode works now quite 
nicely. I think it is possible to enable second tuner also by default if 
no problems occurs.

Please test:
http://linuxtv.org/hg/~anttip/af9015/

regards
Antti
-- 
http://palosaari.fi/
