Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:35754 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750883AbdDQSoE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Apr 2017 14:44:04 -0400
MIME-Version: 1.0
In-Reply-To: <9d37686e-9095-2eaa-72f2-18295a28eb7d@googlemail.com>
References: <CAGncdOYtM3PkJWDcBdSdONY8VbP5gDccBO777=j+ARQFXQMJBw@mail.gmail.com>
 <9d37686e-9095-2eaa-72f2-18295a28eb7d@googlemail.com>
From: Anders Eriksson <aeriksson2@gmail.com>
Date: Mon, 17 Apr 2017 20:44:02 +0200
Message-ID: <CAGncdOYXDrsnTZjzSaj5F=03WFhjO5d5xeJSCPdjRiipQaFf-g@mail.gmail.com>
Subject: Re: em28xx i2c writing error
To: =?UTF-8?Q?Frank_Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        mchehab@kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Frank,


On Sun, Apr 16, 2017 at 7:59 PM, Frank Sch=C3=A4fer
<fschaefer.oss@googlemail.com> wrote:
>
> Am 15.04.2017 um 20:28 schrieb Anders Eriksson:
>> Hi Mauro,
>>
>> I've two devices using this driver, and whenever I have them both in
>> use I eventually (between 10K and 100K secs uptime) i2c write errors
>> such as in the log below. If only have one of the devices in use, the
>> machine is stable.
>>
>> The machine never recovers from the error.
>>
>> All help apreciated.
>> -Anders
>>
>>
>>
<snip>
>> [   45.616358] br0: port 6(vb-work) entered forwarding state
>> [   45.634769] br0: port 6(vb-work) entered forwarding state
>> [   54.045274] br0: port 5(vb-revproxy) entered forwarding state
>> [   60.645283] br0: port 6(vb-work) entered forwarding state
> Did you skip any lines here ? Any usb related messages ?
>
Nope. It ran without any messages up to 93093

>> [93038.637557] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93038.737581] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
> -5 is -EIO, which means the errors occure at usb level (line 176 in
> em28xx-core.c)
> However, the actual error returned by usb_control_msg() might be
> different, because it is passed through usb_translate_errors().
>
> Hth,
> Frank
>

I add linux-usb@ and see who might knwo something. Do you know whom I
should contact wrt usb?

Br,
Anders

>> [93038.746399] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93039.247560] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93039.447579] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93039.647559] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93039.847564] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93040.047567] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93040.157570] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93040.165915] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93041.047583] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93041.167571] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93041.175973] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93042.047587] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93042.177582] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93042.185886] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93043.047590] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93043.187592] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93043.195868] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93044.047593] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93044.197589] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93044.205925] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93045.047597] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93045.207593] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93045.215996] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93046.117605] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93046.217617] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93046.226038] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93047.127686] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93048.127607] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93049.127649] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93050.127623] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93051.127653] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93052.127661] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93053.127629] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93054.127676] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93055.127642] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93055.567657] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93055.627642] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93055.635697] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93055.737670] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93055.745838] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93055.767696] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93055.937644] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93055.945765] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93056.357654] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93056.365873] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93056.557660] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93056.565881] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93056.767668] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93056.957643] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93056.965832] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93057.167651] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93057.175940] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93057.367717] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93057.376095] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93057.777671] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93057.877684] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93057.886233] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93057.987666] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93057.996402] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93058.187711] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93058.196628] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93058.787667] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93058.797684] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93058.806676] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93059.007688] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93059.016688] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93059.117682] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93059.126734] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93059.617670] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93059.626716] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93059.787721] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93059.827708] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93059.836680] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93060.027687] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93060.036769] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93060.437671] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93060.446730] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93060.637691] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93060.646762] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93060.787678] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93061.247687] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93061.256728] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93061.457707] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93061.466757] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93061.787676] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93062.067704] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93062.076679] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93062.277708] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93062.286757] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93062.787684] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93062.887741] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93062.896722] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93063.097697] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93063.106681] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93063.707702] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93063.716684] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93063.787713] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93063.917702] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93063.926670] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93064.527694] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93064.536728] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93064.727715] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93064.736761] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93064.787702] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93065.337687] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93065.346584] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93065.547711] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93065.556702] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93065.787716] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93066.157718] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93066.166619] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93066.367727] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93066.376707] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93066.787692] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93066.977718] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93066.986601] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93067.187761] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93067.196740] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93067.787706] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93067.797724] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93067.806628] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93068.007766] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93068.016675] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93068.617717] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93068.626697] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93068.787718] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93068.827782] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93068.836721] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93069.437700] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93069.437758] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93069.537875] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93069.547209] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93069.787818] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93070.137740] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93070.146672] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93070.337717] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93070.346726] i2c i2c-4: cxd2820r: i2c rd failed=3D-5 reg=3D10 len=3D1
>> [93070.567756] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93070.576794] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93070.587886] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93070.767728] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93070.776740] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D00 len=3D1
>> [93070.787804] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93070.967719] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93070.976604] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D00 len=3D1
>> [93071.377727] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93071.386766] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93071.577712] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93071.586734] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D00 len=3D1
>> [93071.797738] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>> [93071.977728] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93071.986610] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D00 len=3D1
>> [93072.187722] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93072.196762] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D85 len=3D1
>> [93072.387752] em28174 #0: writing to i2c device at 0xd8 failed (error=
=3D-5)
>> [93072.396784] i2c i2c-4: cxd2820r: i2c wr failed=3D-5 reg=3D00 len=3D1
>> [93072.807813] em28178 #1: writing to i2c device at 0xc8 failed (error=
=3D-5)
>
