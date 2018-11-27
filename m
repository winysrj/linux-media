Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.eclipso.de ([217.69.254.104]:48235 "EHLO mail.eclipso.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbeK1C5Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 21:57:25 -0500
Received: from roadrunner.suse (p5B31873F.dip0.t-ipconnect.de [91.49.135.63])
        by mail.eclipso.de with ESMTPS id 26637438
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2018 16:59:01 +0100 (CET)
From: stakanov <stakanov@eclipso.eu>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Ira Krufky <mkrufky@linuxtv.org>,
        Sean Young <sean@mess.org>, Brad Love <brad@nextdimension.cc>,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Date: Tue, 27 Nov 2018 16:58:58 +0100
Message-ID: <45396912.h74atscUxZ@roadrunner.suse>
In-Reply-To: <20181127104946.195487ec@coco.lan>
References: <4e0356d6303c128a3e6d0bcc453ba1be@mail.eclipso.de> <1673172.qrKGPYx0fj@roadrunner.suse> <20181127104946.195487ec@coco.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In data marted� 27 novembre 2018 13:49:46 CET, Mauro Carvalho Chehab ha 
scritto:
> Hi Stakanov,
> 
> Em Tue, 27 Nov 2018 11:02:57 +0100
> 
> stakanov <stakanov@eclipso.eu> escreveu:
> > In data luned� 26 novembre 2018 14:31:09 CET, Takashi Iwai ha scritto:
> > > On Fri, 23 Nov 2018 18:26:25 +0100,
> > > 
> > > Mauro Carvalho Chehab wrote:
> > > > Takashi,
> > > > 
> > > > Could you please produce a Kernel for Stakanov to test
> > > > with the following patches:
> > > > 
> > > > https://patchwork.linuxtv.org/patch/53044/
> > > > https://patchwork.linuxtv.org/patch/53045/
> > > > https://patchwork.linuxtv.org/patch/53046/
> > > > https://patchwork.linuxtv.org/patch/53128/
> > > 
> > > Sorry for the late reaction.  Now it's queued to OBS
> > > home:tiwai:bsc1116374-2 repo.  It'll be ready in an hour or so.
> > > It's based on 4.20-rc4.
> > > 
> > > Stakanov, please give it a try later.
> > > 
> > > 
> > > thanks,
> > > 
> > > Takashi
> > 
> > O.K. this unbricks partially the card.
> 
> From the logs, the Kernel is now working as expected.
> 
> > Now hotbird does search and does sync
> > on all channels. Quality is very good. Astra still does interrupt the
> > search immediately and does not receive a thing. So it is a 50% brick
> > still, but it is a huge progress compared to before.
> 
> As I said before, you need to tell Kaffeine what's the LNBf that you're
> using. The LNBf is a physical device[1] that it is installed on your
> satellite dish. There's no way to auto-detect the model you actually have,
> so you need to provide this information to the digital TV software you're
> using.
> 
> [1] It looks like this:
> 	https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Astra_lnb.jpg/
240
> px-Astra_lnb.jpg
> 
> The "Universal" one is for an old universal model sold in Europe about
> 15 years ago. It doesn't support all transponders found on an Astra
> satellite.
> 
> For those, you need to use the LNBf that it is known as "Astra 1E"[2].
> 
> [2] The name is there just for historical reasons. The actual Astra 1E
> satellite was retired, but another satellite occupies the same orbital
> position (19.2�E), and they keep adding/retiring satellites there as
> needed (https://en.wikipedia.org/wiki/Astra_19.2%C2%B0E).
> 
> As I pointed you on a past e-mail, when you set the DVB-S board on
> Kaffeine, you should have explicitly set it.
> 
> If you start Kaffeine in English:
> 
> 	$ LANG=C kaffeine
> 
> You'll see it at the following menu:
> 
> 	Television -> Configure Television -> Device 0
> 
> (assuming that your device is device 0)
> 
> There, you need to tell that you'll be using a DiSEqC swith. It
> will then allow you to select up to 4 satellite sources. Once you
> set a source, it will allow you to edit the LNB <n> Settings
> (where <n> will be 1 to 4). Clicking there, it will present you
> a menu with all known LNBf models. Astra 1E is the third option[3].
> 
> [3] yeah, on a separate discussion, we should likely rename "Astra 1E"
> to just "Astra", and place it as the first option. I'll do such change,
> but it will be at v4l-utils package (libdvbv5) and it will probably
> take some time until distros start packaging the new version, even
> if we add it to the stable branch.
> 
> > I paste the output of the directory below, unfortunately the opensuse
> > paste
> > does not work currently so I try here, sorry if this is long.
> > 
> > Content of the directory 99-media.conf created following the indications
> > (please bear in mind that I have also another card installed (Hauppauge
> > 5525) although it was not branched to the sat cable and i did change the
> > settings in Kaffeine to use only the technisat. But my understanding is
> > limited if this may give "noise" in the output, so I thought to underline
> > it, just FYI.
> > Output:
> Looks ok to me.
> 
> > [  649.009548] cx23885 0000:03:00.0: invalid short VPD tag 01 at offset 1
> > [  649.011439] r8169 0000:06:00.0: invalid short VPD tag 00 at offset 1
> 
> Those two above are weird... It seems to be related to some issue that
> the PCI core detected:
> 
> drivers/pci/vpd.c:                      pci_warn(dev, "invalid %s VPD tag
> %02x at offset %zu",
> 
> I've no idea what they mean, nor if you'll face any issues related to it.
> 
> Thanks,
> Mauro
The two are known annoyances especially the cx23885 complaining in the logs 
about a "wrong revision". But as they AFAIK do not cause major issues or 
havoc, it is not a problem, at least for me. 
Now, the card suddenly works. The only thing you have to do (limited to this 
technisat PCI card, not applicable to the Hauppauge PCI-e mounted on the same 
machine) is to set the "square" to high voltage, limited for Astra. Hotbird 
scans better without this, with "no setting send" as I do for the Hauppauge as 
well. 
This must be something weird related to our sat dish.

But the GOOD news is: yes now you made it! The card works. And yes, you should 
really rename ASTRA E setting. Maybe also be more clear or give some hint in 
kaffeine when hovering over it, about how to set it, for some reason it came 
straightforward to me to click on the right radio button to select the type of 
satellite,  but I did not understand, nor did suspect, I would be able to set, 
or that I would have to set the left button (must be a cultural deformation, 
or whatever). Once you told me about I did find it, but in my very limited 
experience, I think that could be enhanced.

So congratulations. It works and now I am officially even more impressed about 
Linux and the spirit behind it. Compliments and thank you all for your work 
and time!

Regards. 



_________________________________________________________________
________________________________________________________
Ihre E-Mail-Postf�cher sicher & zentral an einem Ort. Jetzt wechseln und alte E-Mail-Adresse mitnehmen! https://www.eclipso.de
