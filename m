Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.247])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1Jx4zF-0005QE-RT
	for linux-dvb@linuxtv.org; Fri, 16 May 2008 20:50:27 +0200
Received: by an-out-0708.google.com with SMTP id c31so318103anc.125
	for <linux-dvb@linuxtv.org>; Fri, 16 May 2008 11:48:56 -0700 (PDT)
Message-ID: <d9def9db0805161148q3d62caefn8bd5052a876191aa@mail.gmail.com>
Date: Fri, 16 May 2008 20:48:46 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: Andrea <thejest@gmail.com>
In-Reply-To: <e8f7aa7e0805160152k572df413oe9ddd9e68f2f5396@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <e8f7aa7e0805160152k572df413oe9ddd9e68f2f5396@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Choosing composite input, Terratec Cinergy Hybrid XS
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

Hi,

On 5/16/08, Andrea <thejest@gmail.com> wrote:
> Hello everybody,
>
> I installed Terratec Cinergy Hybrid XS USB stick on xUbuntu and it works.
>
> I want to use this tv stick to get a surveillance cam composite
> signal, display it full screen on a monitor and stream over the web
> using Mogulus.com
>
> My problem now, is that default input for this stick is the Television
> (black screen for me). I installed TvTime and from there I can switch
> to the composite signal, I can see it and it's ok.
>
> Mogulus.com flash interface "sees" my TV stick, but in Television channel
> only.
>
> My question is: is it possible somehow to set the composite channel as
> default, instead of Television channel?
>


You might use v4lctl for switching the input.
For example "v4lctl setinput next"

the manpage shows up:
       setinput [ <input> | next ]
              Set the video input (Television/Composite1/...)

v4lctl is part of the xawtv package.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
