Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.177])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0=STUH=ZZ=nikocity.de=mueller_michael@srs.kundenserver.de>)
	id 1Kf8BP-0001al-I9
	for linux-dvb@linuxtv.org; Mon, 15 Sep 2008 09:07:40 +0200
In-Reply-To: <alpine.LRH.1.10.0809150049000.7121@pub5.ifh.de>
References: <20080914082131.GA12258@mueller_michael.de>
	<alpine.LRH.1.10.0809150049000.7121@pub5.ifh.de>
Mime-Version: 1.0 (Apple Message framework v753.1)
Message-Id: <05763FBF-CEC8-4C6D-9DD0-42880ABB317A@nikocity.de>
From: =?ISO-8859-1?Q?Michael_M=FCller?= <mueller_michael@nikocity.de>
Date: Mon, 15 Sep 2008 09:08:33 +0200
To: Patrick Boettcher <patrick.boettcher@desy.de>
Cc: pboettcher@dibcom.fr, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Elgato EyeTV Diversity patch
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Patrick!

Am 15.09.2008 um 00:55 schrieb Patrick Boettcher:

> Hi Michael,
>
> On Sun, 14 Sep 2008, Michael M=FCller wrote:
>> Simply adding a new entry beside the Hauppauge Nova-T stick using the
>> new ids didn't work. Using trail and error I was able to find the
>> right combination. I also was able to activate the remote
>> control. Since the other devices that use stk7070pd_frontend_attach0
>> and stk7070pd_frontend_attach1 as frontends doesn't activate the RC I
>> needed to start a section for my stick. If it doesn't hurt the other
>> devices to have a RC defined perhaps you should combine them.
>
> Yes, please do that.

I'll do that.

> And send the patch again with your Signed-off-by-line and both file- =

> changes created with hg diff of the v4l-dvb repository.

It will be the first time for me. ;-)

>
>> Although it is stated that the diversity mode is currentl not
>> supported it seems to be necessary that both antenna plugs are
>> connected. I have an active antenna and I thought that without
>> diversity it would be the best to connect the antenna directly to the
>> adapter that I want to use. But in this combination 'scan' only
>> creates 'WARNING: >>> tuning failed!!!' messages. If I use the Y- =

>> cable
>> to connect the antenna to both adapters scan is able to find the TV
>> channels. Do you have an explanation for this behaviour?
>
> As you might have noticed, pluging the hardware results in having  =

> two /dev/dvb/adapters. Diversity is in fact disabled, but dual-mode  =

> (sometimes referred as PVR) is activated by default.

Yes, but scan uses adapter0 frontend0 by default. So why does it  =

makes failing to scan adapter0 if the antenna is not connected to  =

adapter1?

> Diversity actually is the combination of the signal resulting from  =

> two different antennas (and tuners and demodulators). This is not  =

> yet supported by LinuxTV-drivers.
>
>> Are there plans to add support for the diversity mode?
>
> Yes.

Any timeline?

Need help?

Regards

Michael
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
