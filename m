Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54308 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726288AbeK1Evv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 23:51:51 -0500
Date: Tue, 27 Nov 2018 15:53:01 -0200
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: stakanov <stakanov@eclipso.eu>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Sean Young <sean@mess.org>, Brad Love <brad@nextdimension.cc>,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Message-ID: <20181127155301.751e545e@coco.lan>
In-Reply-To: <s5hk1kywlrp.wl-tiwai@suse.de>
References: <4e0356d6303c128a3e6d0bcc453ba1be@mail.eclipso.de>
        <1673172.qrKGPYx0fj@roadrunner.suse>
        <20181127104946.195487ec@coco.lan>
        <45396912.h74atscUxZ@roadrunner.suse>
        <s5hk1kywlrp.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 27 Nov 2018 17:03:22 +0100
Takashi Iwai <tiwai@suse.de> escreveu:

> On Tue, 27 Nov 2018 16:58:58 +0100,
> stakanov wrote:
> >=20
> > In data marted=C3=AC 27 novembre 2018 13:49:46 CET, Mauro Carvalho Cheh=
ab ha=20
> > scritto: =20
> > > Hi Stakanov,
> > >=20
> > > Em Tue, 27 Nov 2018 11:02:57 +0100
> > >=20
> > > stakanov <stakanov@eclipso.eu> escreveu: =20
> > > > In data luned=C3=AC 26 novembre 2018 14:31:09 CET, Takashi Iwai ha =
scritto: =20
> > > > > On Fri, 23 Nov 2018 18:26:25 +0100,
> > > > >=20
> > > > > Mauro Carvalho Chehab wrote: =20
> > > > > > Takashi,
> > > > > >=20
> > > > > > Could you please produce a Kernel for Stakanov to test
> > > > > > with the following patches:
> > > > > >=20
> > > > > > https://patchwork.linuxtv.org/patch/53044/
> > > > > > https://patchwork.linuxtv.org/patch/53045/
> > > > > > https://patchwork.linuxtv.org/patch/53046/
> > > > > > https://patchwork.linuxtv.org/patch/53128/ =20
> > > > >=20
> > > > > Sorry for the late reaction.  Now it's queued to OBS
> > > > > home:tiwai:bsc1116374-2 repo.  It'll be ready in an hour or so.
> > > > > It's based on 4.20-rc4.
> > > > >=20
> > > > > Stakanov, please give it a try later.
> > > > >=20
> > > > >=20
> > > > > thanks,
> > > > >=20
> > > > > Takashi =20
> > > >=20
> > > > O.K. this unbricks partially the card. =20
> > >=20
> > > From the logs, the Kernel is now working as expected.
> > >  =20
> > > > Now hotbird does search and does sync
> > > > on all channels. Quality is very good. Astra still does interrupt t=
he
> > > > search immediately and does not receive a thing. So it is a 50% bri=
ck
> > > > still, but it is a huge progress compared to before. =20
> > >=20
> > > As I said before, you need to tell Kaffeine what's the LNBf that you'=
re
> > > using. The LNBf is a physical device[1] that it is installed on your
> > > satellite dish. There's no way to auto-detect the model you actually =
have,
> > > so you need to provide this information to the digital TV software yo=
u're
> > > using.
> > >=20
> > > [1] It looks like this:
> > > 	https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Astra_lnb.=
jpg/ =20
> > 240 =20
> > > px-Astra_lnb.jpg
> > >=20
> > > The "Universal" one is for an old universal model sold in Europe about
> > > 15 years ago. It doesn't support all transponders found on an Astra
> > > satellite.
> > >=20
> > > For those, you need to use the LNBf that it is known as "Astra 1E"[2].
> > >=20
> > > [2] The name is there just for historical reasons. The actual Astra 1E
> > > satellite was retired, but another satellite occupies the same orbital
> > > position (19.2=C2=B0E), and they keep adding/retiring satellites ther=
e as
> > > needed (https://en.wikipedia.org/wiki/Astra_19.2%C2%B0E).
> > >=20
> > > As I pointed you on a past e-mail, when you set the DVB-S board on
> > > Kaffeine, you should have explicitly set it.
> > >=20
> > > If you start Kaffeine in English:
> > >=20
> > > 	$ LANG=3DC kaffeine
> > >=20
> > > You'll see it at the following menu:
> > >=20
> > > 	Television -> Configure Television -> Device 0
> > >=20
> > > (assuming that your device is device 0)
> > >=20
> > > There, you need to tell that you'll be using a DiSEqC swith. It
> > > will then allow you to select up to 4 satellite sources. Once you
> > > set a source, it will allow you to edit the LNB <n> Settings
> > > (where <n> will be 1 to 4). Clicking there, it will present you
> > > a menu with all known LNBf models. Astra 1E is the third option[3].
> > >=20
> > > [3] yeah, on a separate discussion, we should likely rename "Astra 1E"
> > > to just "Astra", and place it as the first option. I'll do such chang=
e,
> > > but it will be at v4l-utils package (libdvbv5) and it will probably
> > > take some time until distros start packaging the new version, even
> > > if we add it to the stable branch.
> > >  =20
> > > > I paste the output of the directory below, unfortunately the opensu=
se
> > > > paste
> > > > does not work currently so I try here, sorry if this is long.
> > > >=20
> > > > Content of the directory 99-media.conf created following the indica=
tions
> > > > (please bear in mind that I have also another card installed (Haupp=
auge
> > > > 5525) although it was not branched to the sat cable and i did chang=
e the
> > > > settings in Kaffeine to use only the technisat. But my understandin=
g is
> > > > limited if this may give "noise" in the output, so I thought to und=
erline
> > > > it, just FYI.
> > > > Output: =20
> > > Looks ok to me.
> > >  =20
> > > > [  649.009548] cx23885 0000:03:00.0: invalid short VPD tag 01 at of=
fset 1
> > > > [  649.011439] r8169 0000:06:00.0: invalid short VPD tag 00 at offs=
et 1 =20
> > >=20
> > > Those two above are weird... It seems to be related to some issue that
> > > the PCI core detected:
> > >=20
> > > drivers/pci/vpd.c:                      pci_warn(dev, "invalid %s VPD=
 tag
> > > %02x at offset %zu",
> > >=20
> > > I've no idea what they mean, nor if you'll face any issues related to=
 it.
> > >=20
> > > Thanks,
> > > Mauro =20
> > The two are known annoyances especially the cx23885 complaining in the =
logs=20
> > about a "wrong revision". But as they AFAIK do not cause major issues o=
r=20
> > havoc, it is not a problem, at least for me.=20
> > Now, the card suddenly works. The only thing you have to do (limited to=
 this=20
> > technisat PCI card, not applicable to the Hauppauge PCI-e mounted on th=
e same=20
> > machine) is to set the "square" to high voltage, limited for Astra. Hot=
bird=20
> > scans better without this, with "no setting send" as I do for the Haupp=
auge as=20
> > well.=20
> > This must be something weird related to our sat dish.
> >=20
> > But the GOOD news is: yes now you made it! The card works. And yes, you=
 should=20
> > really rename ASTRA E setting. Maybe also be more clear or give some hi=
nt in=20
> > kaffeine when hovering over it, about how to set it, for some reason it=
 came=20
> > straightforward to me to click on the right radio button to select the =
type of=20
> > satellite,  but I did not understand, nor did suspect, I would be able =
to set,=20
> > or that I would have to set the left button (must be a cultural deforma=
tion,=20
> > or whatever). Once you told me about I did find it, but in my very limi=
ted=20
> > experience, I think that could be enhanced.
> >=20
> > So congratulations. It works and now I am officially even more impresse=
d about=20
> > Linux and the spirit behind it. Compliments and thank you all for your =
work=20
> > and time! =20
>=20
> Good to hear that now everything nailed down.
> So, the patch
>   https://patchwork.linuxtv.org/patch/53128/
> is needed in addition to=20
>   https://patchwork.linuxtv.org/patch/53044/

Yes.

> If so, Mauro, please don't forget to put Fixes and stable tags, so
> that both will be backported to stable trees.

Yeah, I'll do that.
>=20
> Meanwhile I'll backport it to openSUSE kernels so that the issue will
> be fixed in the next kernel update.

Btw, I'm adding this to v4l-utils (both upstream and stable):

	https://patchwork.linuxtv.org/patch/53172/

Despite being applied against version 1.16, It should be easy to
backport it (if openSUSE is using an older version - probably it is,
since version 1.16 is brand new).

It is not really a bugfix (it is just renaming an entry's full name
and moving it to be at the beginning of the file). It shouldn't
cause any regression (as it doesn't change the short name for the
LNBf), but it may help new users, as, with that, the default
european LNBf will the the one with the extended frequency range
required for Astra satellites.

Thanks,
Mauro
