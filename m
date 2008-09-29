Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.devoteam.com ([213.190.82.43])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Jens.Peder.Terjesen@devoteam.com>)
	id 1KkG3L-0007PG-IF
	for linux-dvb@linuxtv.org; Mon, 29 Sep 2008 12:32:32 +0200
MIME-Version: 1.0
From: Jens.Peder.Terjesen@devoteam.com
To: linux-dvb@linuxtv.org
Date: Mon, 29 Sep 2008 12:31:22 +0200
Message-ID: <OFD920AEE2.261195E1-ONC12574D3.0039CDF0-C12574D3.0039CDF6@devoteam.com>
Subject: Re: [linux-dvb] HVR-4000 and analogue tv
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



-----linux-dvb-bounces@linuxtv.org wrote: -----

>To:=A0Jens.Peder.Terjesen@devoteam.com
>From:=A0Anders=A0Semb=A0Hermansen=A0<anders@ginandtonic.no>
>Sent=A0by:=A0linux-dvb-bounces@linuxtv.org
>Date:=A029-09-2008=A011:40
>cc:=A0linux-dvb@linuxtv.org
>Subject:=A0Re:=A0[linux-dvb]=A0HVR-4000=A0and=A0analogue=A0tv
>
>Jens.Peder.Terjesen@devoteam.com=A0wrote:
>> I thought that the analogue and DVB-T on this card was quite
>separate
>>=A0parts?
>
>I=A0think=A0so=A0yes.
>
>> The DVB-T broadcast has probably already begun. At least it has in
>my=A0part
>>=A0of=A0Norway=A0where=A0the=A0official=A0date=A0is=A0also=A0November=A01=
1th.
>
>I used w_scan yesterday and it returned results. I used scan to get a
>
>channels.conf which looks ok (don't have it here, I'm at work). But I
>
>could not manage to get it to play. I don't know if this is because
>of
>software=A0not=A0supporting=A0frontend1=A0(DVB-T=A0is=A0on
>/dev/dvb/adapter0/frontend1),=A0frontend0=A0is=A0DVB-S=A0or=A0if=A0it=A0do=
es=A0not
>support=A0the=A0digital=A0standard=A0in=A0norway=A0yet.=A0I=A0tried=A0to=
=A0play=A0using
>mplayer directly, and dvbstream with a pipe to mplayer (seems mplayer
>
>does=A0not=A0cope=A0with=A0different=A0frontend).
>
>Any=A0suggestion=A0on=A0how=A0to=A0go=A0forward=A0from=A0here=A0is=A0appre=
ceated.

This is about as far as I have come too.

I know that Kaffeine handles multiple frontends, but not sure about the
support for Norwegian DVB-T.
When I scanned with Kaffeine a few weeks ago it found only one of 24
channels, but there was no picture or sound. Not sure if this was because
the one channel it found is one of the encrypted ones.

I later patched and compiled DVB-apps, and this version of scan seemed to
be outputting correct information, but I am not sure if this can be used by
Kaffeine.

Jens


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
