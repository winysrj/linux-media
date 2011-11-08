Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45335 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039Ab1KHXwl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Nov 2011 18:52:41 -0500
Message-ID: <4EB9C0C4.1090200@iki.fi>
Date: Wed, 09 Nov 2011 01:52:36 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Michael Krufky <mkrufky@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jean Delvare <khali@linux-fr.org>
Subject: [RFC 0/2] add generic helper function for I2C register write
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds helper function for most typical I2C register write. Main 
reason was the fact I2C messages are are needed to split smaller parts 
as I2C-adapters cannot send all long messages used.

Basically there is three different kind of I2C register access used:
* register write (I2C write)
* register read (I2C write + I2C read)
* register read (I2C read)

Register read is usually done using write+read combination (with 
REPEATED START) and almost all I2C-adapters we have can handle it. Some 
rare situations simple read is used. That means for example reading 
small amount of registers starting from register 0 and thus register 
write for setting desired register is not needed. Other used rarely used 
combination for register read is simple register write (for set desired 
reg) and then perform simple register read. It looks like write+read but 
there is no REPEATED START, both messages are own transactions. I hope 
this story gives better understanding :)

At that point, I just implemented simple register write as a example. It 
does not have even any configuration for "register map", like register 
address length nor register value length. It just assumes register is 
one byte wide for both address and value. Lets add those later when needed.

And here is the list of drivers I have been working and this kind of 
splitting have been one problematic issue;
* RTL2832U & RTL2832
* RTL2831U & RTL2830
* AF9015 & TDA18212
* AF9015 & TDA18271
* EM28xx & TDA10071
* Anysee & CX24116
* <demod driver not released yet>

So, as you can see, there is a lot of drivers need splitting!

Any comments?


Antti Palosaari (2):
   dvb-core: add generic helper function for I2C register write
   tda18218: use generic dvb_wr_regs()

  drivers/media/common/tuners/tda18218.c      |   69 
+++++---------------------
  drivers/media/common/tuners/tda18218_priv.h |    3 +
  drivers/media/dvb/dvb-core/Makefile         |    2 +-
  drivers/media/dvb/dvb-core/dvb_generic.c    |   48 ++++++++++++++++++
  drivers/media/dvb/dvb-core/dvb_generic.h    |   21 ++++++++
  5 files changed, 87 insertions(+), 56 deletions(-)
  create mode 100644 drivers/media/dvb/dvb-core/dvb_generic.c
  create mode 100644 drivers/media/dvb/dvb-core/dvb_generic.h

-- 
1.7.4.4
---


-- 
http://palosaari.fi/


