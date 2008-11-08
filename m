Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1KynD7-0000na-Ux
	for linux-dvb@linuxtv.org; Sat, 08 Nov 2008 13:46:43 +0100
Received: by fg-out-1718.google.com with SMTP id e21so1424830fga.25
	for <linux-dvb@linuxtv.org>; Sat, 08 Nov 2008 04:46:38 -0800 (PST)
Message-ID: <d9def9db0811080446n22aeaa9fqb243bd2f41c24d64@mail.gmail.com>
Date: Sat, 8 Nov 2008 13:46:38 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "=?ISO-8859-2?Q?Wiktor_Gr=EAbla?=" <greblus@gmail.com>
In-Reply-To: <912f87b30811080435v1c76b004o77bbe9d89b8958a5@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	<20081108081508.496f6582@pedra.chehab.org>
	<d9def9db0811080222l57e9db9fwb835395d6069571@mail.gmail.com>
	<alpine.LFD.2.00.0811080529000.7489@bombadil.infradead.org>
	<d9def9db0811080242v5fd108c6g80873f681e17224a@mail.gmail.com>
	<alpine.LFD.2.00.0811080549191.7489@bombadil.infradead.org>
	<d9def9db0811080302r35823330k167042d2e8462340@mail.gmail.com>
	<912f87b30811080418m66e6bc04g349c1dfabf5beb50@mail.gmail.com>
	<d9def9db0811080427o5cdb313jb38ce76590a5b2e9@mail.gmail.com>
	<912f87b30811080435v1c76b004o77bbe9d89b8958a5@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH 1/7] Adding empia base driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

2008/11/8 Wiktor Gr=EAbla <greblus@gmail.com>:
> Hi.
>
> W dniu 8 listopada 2008 13:27 u=BFytkownik Markus Rechberger
> <mrechberger@gmail.com> napisa=B3:
>
>>> It's also worth to note that mainline driver works fine. No audio
>>> problems, oopses, etc.
>> Don't overlook that I wrote that audio driver and spent a little more
>> time on all this too.
>
> I'm only saying that it works for me.
>
> Anyway I really hope that all animosities will be left aside and your
> code will be merged finally.
>

This is actually what I hope too sooner or later especially the first
part of it,
the merging part should be the second one.
There are still some issues with the audio driver which is in the kernel, e=
g.
deinitialization, and there are 2 more audiodrivers available for other dev=
ices
 and use cases.

Markus
_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
