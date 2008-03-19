Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rn-out-0910.google.com ([64.233.170.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <matthijsorfu@gmail.com>) id 1Jc6ov-00030i-QO
	for linux-dvb@linuxtv.org; Wed, 19 Mar 2008 23:31:42 +0100
Received: by rn-out-0910.google.com with SMTP id e11so562441rng.17
	for <linux-dvb@linuxtv.org>; Wed, 19 Mar 2008 15:31:34 -0700 (PDT)
Message-ID: <e45d04010803191531g119753d5n22accf13e1b4b096@mail.gmail.com>
Date: Wed, 19 Mar 2008 23:31:34 +0100
From: "Matthijs De Smedt" <matthijs@orfu.net>
To: "Derk Dukker" <derk.dukker@gmail.com>
In-Reply-To: <e2d627830803191424v36a4ffacxe629f49b8490b28d@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <e45d04010803190957k5dc862aeod3fed3cf5848e8fa@mail.gmail.com>
	<e2d627830803191424v36a4ffacxe629f49b8490b28d@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Terratec Cinergy CI USB
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

Hello Derk,

Thanks for the interesting information. I've looked at the
specification. It's very comprehensive concerning the implementation
of CI, but does not contain anything about the USB2CI device itself.
Also, this thing is complicated.

I have no idea how to reverse engineer the BDA driver. I have no
experience with reverse engineering nor the technologies used here. If
nobody wants to work on this I might give it a shot, but without specs
I doubt I'll get very far.

Regards,

Matthijs

On Wed, Mar 19, 2008 at 10:24 PM, Derk Dukker <derk.dukker@gmail.com> wrote:
> Hi Matthijs,
>
> I also need a linux driver for the Cinergy CI USB. I found out that it's
> made by smardtv (www.smardtv.com) and there is an ACTEL chip in it. As far
> as I know there isn't any linux driver (yet), but smardtv is willing to give
> the specification to you by mail on
> http://www.smardtv.com/index.php?page=dvbci&rubrique=specification .On the
> terratec site there is a BDA driver for windows. Don't know if it's hard to
> reverse engineer it.
> I have a ps3 with linux on it, a cinergy ci usb and a cinergy xt diversity
> and want to make a mediacenter out of my ps3 with the tuner and ci. Only the
> Cinergy CI usb is the obstacle, the xs diversity is supported I think.
>
> regards,
>
> Derk
>
>
>
> On Wed, Mar 19, 2008 at 5:57 PM, Matthijs De Smedt <matthijs@orfu.net>
> wrote:
>
> >
> >
> >
> > Hi,
> >
> > Is anyone working on supporting the Terratec Cinergy CI USB add-on?
> >
> > http://www.terratec.net/en/products/Cinergy_CI_USB_2296.html
> >
> > Supporting this would hypothetically enable channel decryption for any
> > DVB tuner. PCI or USB.
> >
> > If there is interest in supporting this device I'd be happy to help in
> some way.
> >
> > --
> > Kind regards,
> >
> > Matthijs De Smedt
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
>
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
