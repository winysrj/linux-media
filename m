Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36742 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756614Ab2KHUSw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Nov 2012 15:18:52 -0500
Message-ID: <509C138F.1000402@iki.fi>
Date: Thu, 08 Nov 2012 22:18:23 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: it913x driver with USB1.1
References: <509AF219.6030907@iki.fi> <1352396904.3036.0.camel@Route3278>
In-Reply-To: <1352396904.3036.0.camel@Route3278>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/08/2012 07:48 PM, Malcolm Priestley wrote:
>
> On 07/11/12 23:43, Antti Palosaari wrote:
>> Malcolm,
>> Have you newer tested it with USB1.1 port? Stream is totally broken.
>>
> Hi Antti
>
> Hmm, yes it is a bit choppy on dvb-usb-v2.
>
> I will have a look at it.

Fedora's stock 3.6.5-1.fc17.x86_64 is even more worse - no picture at 
all when using vlc. Clearly visible difference is pid filter count. 
dvb-usb says 5 filters whilst dvb-usb-v2 says 32 pid filters.

dvb_usb_v2: will use the device's hardware PID filter (table count: 32)
dvb-usb: will use the device's hardware PID filter (table count: 5).


regards
Antti

-- 
http://palosaari.fi/
