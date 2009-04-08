Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp103.rog.mail.re2.yahoo.com ([206.190.36.81]:36528 "HELO
	smtp103.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751067AbZDHDJd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Apr 2009 23:09:33 -0400
Message-ID: <49DC13D3.4080201@rogers.com>
Date: Tue, 07 Apr 2009 23:02:43 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: hermann pitton <hermann-pitton@arcor.de>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
  model
References: <20090404142427.6e81f316@hyperion.delvare>	<Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>	<20090405010539.187e6268@hyperion.delvare>	<200904050746.47451.hverkuil@xs4all.nl>	<20090405143748.GC10556@aniel>	<1238953174.3337.12.camel@morgan.walls.org>	<20090405183154.GE10556@aniel>	<1238957897.3337.50.camel@morgan.walls.org>	<20090405222250.64ed67ae@hyperion.delvare>	<1238966523.6627.63.camel@pc07.localdom.local>	<20090406104045.58da67c7@hyperion.delvare>	<1239052236.4925.20.camel@pc07.localdom.local> <20090407112715.6caf2e89@hyperion.delvare>
In-Reply-To: <20090407112715.6caf2e89@hyperion.delvare>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean Delvare wrote:
> On Mon, 06 Apr 2009 23:10:36 +0200, hermann pitton wrote:
>   
>> Am Montag, den 06.04.2009, 10:40 +0200 schrieb Jean Delvare:
>>     
>>> Anyone out there with a MSI TV@nywhere Plus that could help with
>>> testing?
>>>       
>> Here is a link to one of the initial reports by Henry, others are close
>> to it.
>>
>> http://marc.info/?l=linux-video&m=113324147429459&w=2
>>
>> There are two different variants of that MSI card, but that undocumented
>> KS003 chip is the same on them.
>>     
>
> Great, thanks for the pointer. If I understand correctly, the KS003
> has a state machine flow which causes the chip to stop answering when
> an invalid address is used on the bus and start answering again when a
> valid address other than his own is used. As the old i2c model relied a
> lot on probing, I am not surprised that this was a problem in the past.
> But with the new model, probes should become infrequent, so I suspect
> that the workaround may no longer be needed... except when i2c_scan=1
> is used.
>
> I'd rather keep the workaround in place for the time being, and only
> once the ir-kbd-i2c changes have settled, try to remove it if someone
> really cares.

Regarding the KS003 (& KS007; the other "mystery" chip):

Upon further investigation of some info from a post from last year
(http://www.linuxtv.org/pipermail/linux-dvb/2008-January/022634.html),
it appears that these (assuming that they are the same IC across the
various MSI, Leadtek & KWorld cards; and I believe that to be true) are
the "AT8PS54/S56" chip from "Feeling Technology" ... the datasheet for
that part is available through a google search .... probing further (as
I had never heard of FT before and so I looked them up), it looks like
FT renamed and/or upgraded the chip to the "FM8PS54/S56" ... the near
identical datasheet for that second version is also available:
http://www.feeling-tech.com.tw/km-master/front/bin/ptdetail.phtml?Part=M1-05&Category=100018

