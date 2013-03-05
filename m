Return-path: <linux-media-owner@vger.kernel.org>
Received: from amber.schedom-europe.net ([193.109.184.92]:44308 "HELO
	amber.schedom-europe.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750931Ab3CEVck convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 16:32:40 -0500
Message-ID: <20130305223233.m32q5iyo2zwo4g0o@webmail.dommel.be>
Date: Tue,  5 Mar 2013 22:32:33 +0100
From: jandegr1@dommel.be
To: Daniel =?iso-8859-1?b?R2z2Y2tuZXI=?= <daniel-gl@gmx.net>
Cc: linux-media@vger.kernel.org
Subject: Re: HAUPPAUGE HVR-930C analog tv feasible ??
References: <20130225120117.atcsi16l8jokos80@webmail.dommel.be>
	<20130225083345.2d83d554@redhat.com>
	<20130301212854.93kflfbg4jc0kksk@webmail.dommel.be>
	<20130303000134.GA21166@minime.bse>
In-Reply-To: <20130303000134.GA21166@minime.bse>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Citeren Daniel Glöckner <daniel-gl@gmx.net>:

> Hi,
>
> On Fri, Mar 01, 2013 at 09:28:54PM +0100, jandegr1@dommel.be wrote:
>> Citeren Mauro Carvalho Chehab <mchehab@redhat.com>:
>> >nor I succeeded
>> >to get any avf4910b datasheet or development kit.
>
> and now that Trident went bankrupt chances are slim that one of us ever
> will.
>
>> Any other suggestions/comments or anyone wanting to work with me on this ?
>
> I have an AF9035 based stick with that chip and once sniffed the
> communication from cold state until about the 40th frame. At that
> point what appears to be sound frames in the iso packets still just
> contains 0x00 bytes at about 192kB/s. VBI data is captured as well
> raw and sliced but I don't know if the slicing is done by the AF9035.
> I beat the old log into a shape similar to your log's and uploaded it:
> http://pastebin.com/mfN1TXrG
> AF9035 firmare and iso data have been omitted.
>
> As you can see, the driver uploads some kind of firmware to the upper
> address space of the AVF4910B. According to
> http://driveragent.com/c/archive/562634f6/image/2-1-0/Yuan-MC270B-TV-Tuner-Driver,-IdeaCentre-B310
> the chip contains a 8051 microcontroller.
>
> Devin Heitmueller once told me that he wrote a driver for the AVF4910A
> as part of their Osprey 240e/450e driver. He also said that it was
> completely different to the AVF4910B. I can no longer find it online,
> but my local copy tells me that the AVF4910A also uses demod register
> 0x50 for I2S configuration and register 0x20 for standard selection.
> Maybe they are not so different after all.
>
>  Daniel
>
Hi,
Thanks for your log.
Your local avf4910a copy probably offers not much more than the one 
over here ?
https://github.com/wurststulle/ngene_2400i/tree/2377b1fd99d91ff355a5e46881ef27ccc87cb376

I think I can get it working by replaying the registers, a little bit rude but
will do as starter.
Aduio demodulator is the only thing I could find, but very little has 
to be done
for ATV audio.

regards,

Jan De Graeve





