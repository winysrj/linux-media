Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tomlohave@gmail.com>) id 1Kl4iL-0004ib-TU
	for linux-dvb@linuxtv.org; Wed, 01 Oct 2008 18:38:16 +0200
Received: by nf-out-0910.google.com with SMTP id g13so283192nfb.11
	for <linux-dvb@linuxtv.org>; Wed, 01 Oct 2008 09:38:09 -0700 (PDT)
Message-ID: <48E3A767.2020706@gmail.com>
Date: Wed, 01 Oct 2008 18:37:59 +0200
From: "tomlohave@gmail.com" <tomlohave@gmail.com>
MIME-Version: 1.0
To: dabby bentam <db260179@hotmail.com>
References: <BLU116-W31A8ACFFBED560E0D80D5AC2420@phx.gbl>
In-Reply-To: <BLU116-W31A8ACFFBED560E0D80D5AC2420@phx.gbl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Adding remote support to Avermedia Super 007 - more
 info needed!
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

dabby bentam a =E9crit :
> -----Original Message-----
> From: darron@kewl.org [mailto:darron@kewl.org]
> Sent: 01 October 2008 02:08
> To: dabby bentam
> Subject: Re: [linux-dvb] Adding remote support to Avermedia Super 007 =

> - more info needed!
>
> In message <BLU116-W122752EF5297963897FDE5C2430@phx.gbl>, dabby bentam =

> wrote:
>
> hello david
>
> >I'm currently trying to get remote support added to the Avermedia Super
> >007=3D  card.
>
> I have one of these cards also but I have no good news for you =

> unfortunately.
>
> I am replying just to confirm that I too saw no activity in the =

> register logs in XP when pressing remote key presses. Nor, from what I =

> can see will any additions to the saa7134 code as is, aide you in =

> reaching remote control nirvana.
>
> It looks as if all remotes on the saa7134 linux driver thus far are =

> triggered via an interrupt and that no such interrupt is occuring when =

> you press a key on the remote for that board. This may require more =

> absolute confirmation though as I didn't spend a great deal of time =

> looking.
>
> >I've turned the ir_debug on and gpio tracking on and enabled i2c_scan.
> >I've=3D  added an entry in the saa7134-cards.c and saa7134-input.c -
> >copying the se=3D ttings from other avermedia cards.
> >
> >The polling setting makes the card print out loads of ir_builder
> >settings=3D =3D2C removing the setting no output! - from this i am assum=
ing
> >that this car=3D d has no gpio setting? - possible i2c?
> >
> >I've used regspy (from dscaler) to determine the GPIO STATUS and MASK
> >value=3D . Turning on/off the remote in windows has no value change? -
> >does it chang=3D e?
> >
> >Any guidance on how to determine the ir code? - without the manufacture
> >cod=3D e book.
>
> I took a photo but didn't identify all the ICs on the board and write =

> them down, it may be worthwhie doing so and also tracing from where =

> the IR detector comes into the card and where it actually ends up.
>
> If you are determined then you could explore the above but there is =

> still no guarantee of any eventual success of course as just knowing =

> about it more is only the first step in actually getting it to work.
>
> cya!
>
> Hello darron,
>
> Thanks for the reply. I've established the cards IR port is not GPIO =

> but I2C. Similar to the hvr-1110 card. The I2C readout gives me:-
>
> 0x10
> 0x96
>
> From the other I2C cards, these functions are used to enable/disable =

> the IR port.
>
> I'll take a closer look at he pins just incase.
>
> Thanks
>
> David
>
>
> ------------------------------------------------------------------------
Have you try with i2c_scan ?

Not sure but for hvr1110,

>/ saa7133[0]: i2c scan: found device @ 0x10  [???]
/>/ saa7133[0]: i2c scan: found device @ 0x96  [???]
/>/ saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
/>/ saa7133[0]: i2c scan: found device @ 0xe0  [???]
/>/ saa7133[0]: i2c scan: found device @ 0xe2  [???]         <---- ir remot=
e here
/>/ saa7133[0]: i2c scan: found device @ 0xe4  [???]
/>/ saa7133[0]: i2c scan: found device @ 0xe6  [???]
/


Then 0xe2 <<1 =3D 0x71


Good luck

Tom


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
