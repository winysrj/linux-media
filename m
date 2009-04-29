Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:37427 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761670AbZD2Wqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2009 18:46:48 -0400
Subject: Re: [PATCH 0/6] ir-kbd-i2c conversion to the new i2c binding model
	(v2)
From: hermann pitton <hermann-pitton@arcor.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: LMML <linux-media@vger.kernel.org>
In-Reply-To: <20090429142952.65d1c923@hyperion.delvare>
References: <20090417222927.7a966350@hyperion.delvare>
	 <20090429142952.65d1c923@hyperion.delvare>
Content-Type: text/plain
Date: Thu, 30 Apr 2009 00:40:19 +0200
Message-Id: <1241044819.3710.94.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean,

Am Mittwoch, den 29.04.2009, 14:29 +0200 schrieb Jean Delvare:
> On Fri, 17 Apr 2009 22:29:27 +0200, Jean Delvare wrote:
> > Here comes an update of my conversion of ir-kbd-i2c to the new i2c
> > binding model. I've split it into 6 pieces for easier review. (...)
> 
> Did anyone test these patches, please?

it took me about two years to fix the obviously wrong radio
configuration on the MSI TV@nywhere Plus, also some other input was
wrong and similar happened on other cards.

To get no reply unfortunately happens quite often and it is not meant as
an offense, but either you don't reach people with that hardware on the
list currently or they are simply ignorant for some even most simple
test. To have done most tricky things previously does not prevent them
from ignoring simple test requests.

I don't have anything using ir-kbd-i2c.

Also don't know anything about the subscribers count on linux-media
currently. On video4linux alone it have been almost 2500 in average.

Maybe a test repo on linuxtv.org might help, without the need to apply
patches manually and also mail to the old lists for testers?

Cheers,
Hermann


