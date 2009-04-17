Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-gx0-f161.google.com ([209.85.217.161])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <poplyra@gmail.com>) id 1LuxaZ-0000sP-Qd
	for linux-dvb@linuxtv.org; Sat, 18 Apr 2009 01:35:20 +0200
Received: by gxk5 with SMTP id 5so2896991gxk.17
	for <linux-dvb@linuxtv.org>; Fri, 17 Apr 2009 16:34:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200904171633.54211.lyra@pop-pr.rnp.br>
References: <200904171633.54211.lyra@pop-pr.rnp.br>
Date: Fri, 17 Apr 2009 20:34:44 -0300
Message-ID: <ff07fffe0904171634k7e8210ebw85cfc153cde7cdbc@mail.gmail.com>
From: Christian Lyra <lyra@pop-pr.rnp.br>
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Current state of DVB-C support
Reply-To: linux-media@vger.kernel.org
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

Hi,

>
> =A0 =A0 =A0 =A0My first attempt to use a DVB-C was with a KNC1 card. I ju=
st had to
> download the latest source from dvb repository, compile and install.
> The card was identified, I could scan channels and watch TV. BUT some
> channels works very badly, as the card couldnt lock properly on a few
> transponders (309mhz and 321mhz). Running a czap on those channels
> shows that the card keep "locking" and loosing the lock.
> =A0 =A0 =A0 =A0I thought that the problem could be something with my cabl=
ing, so I
> tried my card at a friend=B4s house with the same results. I also tried a
> attenuator, but without success too.
>
> =A0 =A0 =A0 =A0On my second attempt I bought a twinhan CAB ci card. Card =
identified,
> but scan didnt worked. Some googleing later, I got it working by
> commenting the line 1360 in dst.c (!(state->dst_type =3D=3D
> DST_TYPE_IS_CABLE) &&). To my surprise this card has NO problem locking
> on 309mhz and 321mhz channels. It seems to take a little longer to
> lock/changing channels compared to my twinhan DVB-S card (I=B4m comparing
> apples and oranges, right?), but so far it=B4s working ok.
>
> =A0 =A0 =A0 =A0My third attempt was with a technisat cablestar HD2 card. =
I used the
> mantis repository to get the card working (is the mantis driver already
> merged with v4l-dvb?). Again, I can scan channels, but the card could
> not =A0lock on those Transponders. In fact it also take a lot longer to
> lock on a channel, but after it got a lock, it works right.
>
> =A0 =A0 =A0 =A0Since twinhan works fine, I supose that there=B4s no probl=
em with my
> cable/splitter. Also, I supose that the chance of two disctinct broken
> tuners is low. A recent thread on TT-1501 shows that, if I understood
> it right, there=B4s a kind of table where a power level is set to each
> frequency range. Is it possible that my two cards didnt worked on those
> especif transporders because of this kind of setting?

Just a note: both non-working cards uses a tda10023 chip, so I think
it should a good start pointing...


-- =

Christian Lyra
PoP-PR/RNP

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
