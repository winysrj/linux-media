Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34740 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978AbZCJQMV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 12:12:21 -0400
Message-ID: <49B6915A.6050108@iki.fi>
Date: Tue, 10 Mar 2009 18:12:10 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Christopher Pascoe <c.pascoe@itee.uq.edu.au>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] Fix I2C bridge error in zl10353
References: <E1LHmrf-0004LH-VV@www.linuxtv.org>	<49A03A94.9030008@iki.fi>	<49B63C6C.8070709@iki.fi>	<20090310094019.16ab55d7@pedra.chehab.org> <20090310220819.1790cc44@glory.loctelecom.ru> <49B667A7.8090407@iki.fi>
In-Reply-To: <49B667A7.8090407@iki.fi>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari wrote:
> Dmitri Belimov wrote:
>>> Could one of you please do such patchset?
>>
>> I haven't a lot expirience with kernel programming. If Antti can it is 
>> good. I'll check it
>> on our board.
> 
> OK, I will do. For the first phase and as a bug fix I will do that 
> (disable i2c-gate) like dtv5100 driver does. After that I will add new 
> configuration switch for i2c-gate disable and also change .no_tuner name 
> to better one.

Here it is, please review and test. I kept changes as small as possible 
to prevent errors. Lets fix more later.

http://linuxtv.org/hg/~anttip/zl10353/

regards
Antti
-- 
http://palosaari.fi/
