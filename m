Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wr-out-0506.google.com ([64.233.184.233])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <roman.pena.perez@gmail.com>) id 1JoqEx-0002dR-A5
	for linux-dvb@linuxtv.org; Thu, 24 Apr 2008 03:27:12 +0200
Received: by wr-out-0506.google.com with SMTP id c30so1953426wra.14
	for <linux-dvb@linuxtv.org>; Wed, 23 Apr 2008 18:27:06 -0700 (PDT)
Message-ID: <28a25ce0804231827h4272c0a9w7c815babe48b435e@mail.gmail.com>
Date: Thu, 24 Apr 2008 03:27:05 +0200
From: "=?ISO-8859-1?Q?Rom=E1n?=" <roman.pena.perez@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <28a25ce0712131712s24ff079awb5ab42e7ffffbea9@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <28a25ce0711261002t5e671187ub61aca7796c61d3f@mail.gmail.com>
	<28a25ce0711281206p744c8ff8n7ab1065edecf2f4a@mail.gmail.com>
	<28a25ce0712010901n3eacedd7q7864e299798be19b@mail.gmail.com>
	<20071202091122.0b9c121a@aapo-desktop>
	<28a25ce0712020514l5feb56at2dc11261eef16e05@mail.gmail.com>
	<20071202223807.76b9b215@aapo-desktop>
	<28a25ce0712041445p42a07fe9p5cda5e833a2eb56f@mail.gmail.com>
	<28a25ce0712121400w2f5d0712s7ac5ccb677796784@mail.gmail.com>
	<476163E0.4050706@iki.fi>
	<28a25ce0712131712s24ff079awb5ab42e7ffffbea9@mail.gmail.com>
Cc: Aapo Tahkola <aet@rasterburn.org>, Antti Palosaari <crope@iki.fi>
Subject: Re: [linux-dvb] m920x device: Genius TVGo DVB-T02Q
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

Hello,

I'm back after some months away. And I have good news. Finally, the
hack to m920x to add support for the t02q v2.0 has worked. It still
lacks a lot of things -e.g. remote controller support-, but I can tune
channels and read the video flawlessly (except for my very bad signal
reception :-).

Right now I won't attach the patch to this message because of the lack
of time. I'll try to post it tomorrow, so people can start testing and
criticizing.

If you are curious, the success depended on a new firmware I
"borrowed" from the last windows drivers, downloaded from the Genius'
homepage. It makes the stick work in bulk transfer mode.

On a side note, I want to say there are some people with Genius/KYE
TVGo T02PRO and/or T02Q-MCE devices that ask for support. Indeed, they
made me return to this development a couple of weeks ago, so I thank
them a lot. But I want to point out those are different devices, with
different chips inside (for two reasons: [a] for the record, so new
users don't get confused, and [b] to spread the word in case someone
knows how to help them and is kind enough to do it d^_~b; the T02PRO
frontend chip, for instance, is currently unsupported as far as I
know, so there's little chance newbies can add code for their
devices.)

Best regards,

-- =


 Rom=E1n

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
