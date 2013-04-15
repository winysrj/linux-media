Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55248 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab3DOOMP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Apr 2013 10:12:15 -0400
Message-ID: <516C0A95.1040101@iki.fi>
Date: Mon, 15 Apr 2013 17:11:33 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] em28xx: give up GPIO register tracking/caching
References: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com> <1365846521-3127-2-git-send-email-fschaefer.oss@googlemail.com> <20130413114144.097a21a1@redhat.com> <51697AC8.1050807@googlemail.com> <20130413140444.2fba3e88@redhat.com> <516999EC.6080605@googlemail.com> <20130413150823.6e962285@redhat.com> <516B12F9.4040609@googlemail.com> <20130415095130.78a5ecd9@redhat.com>
In-Reply-To: <20130415095130.78a5ecd9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/15/2013 03:51 PM, Mauro Carvalho Chehab wrote:
> Em Sun, 14 Apr 2013 22:35:05 +0200
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

>> I checked the em25xx datasheet (excerpt) and it talks about separate
>> registers for GPIO configuration (unfortunately without explaining their
>> function in detail).
>
> Interesting. There are several old designs (bttv, saa7134,...) that uses
> a separate register for defining the input and the output pins.

That's pretty usual way, likely most common, having separate GPIO 
configuration and GPIO value registers. If you has a port of GPIO values 
in one register, and you has configured those as 0-3 INPUT and 4-7 
OUTPUT, then writing to that register does not make any changes to bits 
that are mapped as IN (are just discarded as don't care).

In case a bit I/O (which is not not supported by Kernel) writing to 
input register could enable internal pull-up or pull-down resistor :) 
IIRC Atmel micro-controllers has such option.

regards
Antti

-- 
http://palosaari.fi/
