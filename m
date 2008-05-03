Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.234])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JsGGF-0007JL-Iy
	for linux-dvb@linuxtv.org; Sat, 03 May 2008 13:50:40 +0200
Received: by rv-out-0506.google.com with SMTP id b25so1257881rvf.41
	for <linux-dvb@linuxtv.org>; Sat, 03 May 2008 04:50:34 -0700 (PDT)
Message-ID: <d9def9db0805030450h4ff0fd52q689161fcf016fb2d@mail.gmail.com>
Date: Sat, 3 May 2008 13:50:34 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "luc legrand" <legrandluc@gmail.com>
In-Reply-To: <9f2475180805030250w7e25d43cie6220c614a23acca@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <9f2475180805020625nd6ff2a9ked408aa61ba3553@mail.gmail.com>
	<d9def9db0805020754tbe8fcd1k1c2bbe2024c17d9a@mail.gmail.com>
	<9f2475180805021058s2292cfe8pac958286b7cfb36a@mail.gmail.com>
	<d9def9db0805021124sf25e63fme8e4319169bc83de@mail.gmail.com>
	<9f2475180805021151r5ae14022w90603f5c3c66c8d9@mail.gmail.com>
	<d9def9db0805021215n3f5cbc06r24340d7dd551a541@mail.gmail.com>
	<9f2475180805030250w7e25d43cie6220c614a23acca@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Avermedia M115 MiniPCI hybrid
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On 5/3/08, luc legrand <legrandluc@gmail.com> wrote:
> ok I'll give it a try.
> I have seen that you recently modify v4l-dvb-experimental tree. Should
> I compile using make or should I continue using make
> LINUXINCLUDE="-I`pwd`/linux/include -I`pwd`/v4l -Iinclude
> -include include/linux/autoconf.h" ?
>

just try it the normal way without those parameters, I might go
through that tree next week and extract the non em28xx patches to fit
into the official linuxtv repository... I'm a bit short on time
though.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
