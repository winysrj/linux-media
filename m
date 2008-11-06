Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from blu0-omc1-s12.blu0.hotmail.com ([65.55.116.23])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stevthro@hotmail.fr>) id 1Ky4SB-0007W2-OE
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 13:59:21 +0100
Message-ID: <BLU126-W6957B65360F3DA0A48FDEAF1E0@phx.gbl>
From: Steve Thro <stevthro@hotmail.fr>
To: <darron@kewl.org>
Date: Thu, 6 Nov 2008 13:58:41 +0100
In-Reply-To: <15933.1225913396@kewl.org>
References: <BLU126-W211E02BF45832661F2020BAF1F0@phx.gbl>
	<14964.1225909409@kewl.org>
	<BLU126-W1455E0B6279BBF11D1BDD4AF1F0@phx.gbl>
	<15308.1225910609@kewl.org>
	<BLU126-W53DD1C6541585D37293AC1AF1F0@phx.gbl>
	<15933.1225913396@kewl.org>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] no lock on 3/4 with cx24116
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


>>There are some difference between your output and mine:
>>yours:
>>rolloff 0.35
>>sid 0x0edb
>>
>>mine=3D3B
>>rolloff auto
>>sid 0x0000
>>

It's locking now changing the rolloff value from 0 to 35

Discovery HD;BSkyB:12324:VC34M2O35S1:S28.2E:29500:514=3D27:0;662=3Deng:0:0:=
3803:2:2032:0

Thanks Darron for the patch,

Steve,

_________________________________________________________________
In=E9dit ! Des Emotic=F4nes D=E9jant=E9es! Installez les dans votre Messeng=
er ! =

http://www.ilovemessenger.fr/Emoticones/EmoticonesDejantees.aspx
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
