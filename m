Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:40693 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932486AbeCMQLB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 12:11:01 -0400
MIME-Version: 1.0
In-Reply-To: <871008484.8702062.1520771930968.JavaMail.zimbra@univ-grenoble-alpes.fr>
References: <382b6f23-d36e-696a-a536-bb5c05b10d34@univ-grenoble-alpes.fr>
 <1512989520.22920.2.camel@suse.com> <1607480650.971508.1513000904833.JavaMail.zimbra@univ-grenoble-alpes.fr>
 <1513002580.22920.15.camel@suse.com> <1599416013.1022922.1513002815596.JavaMail.zimbra@univ-grenoble-alpes.fr>
 <1513004631.22920.20.camel@suse.com> <1847654838.1115072.1513006781751.JavaMail.zimbra@univ-grenoble-alpes.fr>
 <871008484.8702062.1520771930968.JavaMail.zimbra@univ-grenoble-alpes.fr>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 13 Mar 2018 18:11:00 +0200
Message-ID: <CAHp75Vf0EWNzn+aRrg8XRZpKvmNMq=OXmLiW5FVGx+20xTvDuw@mail.gmail.com>
Subject: Re: Webcams not recognized on a Dell Latitude 5285 laptop
To: =?UTF-8?Q?FR=C3=89D=C3=89RIC_PARRENIN?=
        <frederic.parrenin@univ-grenoble-alpes.fr>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Oliver Neukum <oneukum@suse.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 11, 2018 at 2:38 PM, FR=C3=89D=C3=89RIC PARRENIN
<frederic.parrenin@univ-grenoble-alpes.fr> wrote:
> Dear Oliver and all,
>
> So I was expecting linux-4.16 to recognize my webcams, thanks to this new=
 PCI driver Oliver mentioned.
> Therefore I installed 4.16-rc4.
> Unfortunately, there is still no /dev/video* device
>
> Any idea what could be done to have these webcams working?

I guess you need a driver.
Cc: + Sakari, and thus leaving the complete message uncut.

>
> Thanks,
>
> Frederic
>
>
>> De: "FR=C3=89D=C3=89RIC PARRENIN" <frederic.parrenin@univ-grenoble-alpes=
.fr>
>> =C3=80: "Oliver Neukum" <oneukum@suse.com>
>> Cc: "linux-usb" <linux-usb@vger.kernel.org>
>> Envoy=C3=A9: Lundi 11 D=C3=A9cembre 2017 16:39:41
>> Objet: Re: Webcams not recognized on a Dell Latitude 5285 laptop
>
>> > > > it looks like you need the experimental driver posted here
>
>> > > > https://www.spinics.net/lists/linux-media/msg123268.html
>
>> > > Thanks for the information.
>> >> So, if I understand correctly, this driver will not be included in 4.=
15, will
>> > > it?
>> > > Any idea when this will be included in a release?
>
>> > I have no idea. Could you contact the original developers?
>> > The answer is interesting, but I have no idea.
>
>> It seems it will be included in the 4.16 release:
>
>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg122619.html
>
>> Probably just a bit too late for 4.15.
>
>> Frederic
>
> !!! WARNING!!! New email address: frederic.parrenin@univ-grenoble-alpes.f=
r
> http://pp.ige-grenoble.fr/pageperso/parrenif/index.html
>
> ----- Mail original -----
>> De: "FR=C3=89D=C3=89RIC PARRENIN" <frederic.parrenin@univ-grenoble-alpes=
.fr>
>> =C3=80: "Oliver Neukum" <oneukum@suse.com>
>> Cc: "linux-usb" <linux-usb@vger.kernel.org>
>> Envoy=C3=A9: Lundi 11 D=C3=A9cembre 2017 16:39:41
>> Objet: Re: Webcams not recognized on a Dell Latitude 5285 laptop
>
>> > > > it looks like you need the experimental driver posted here
>
>> > > > https://www.spinics.net/lists/linux-media/msg123268.html
>
>> > > Thanks for the information.
>> >> So, if I understand correctly, this driver will not be included in 4.=
15, will
>> > > it?
>> > > Any idea when this will be included in a release?
>
>> > I have no idea. Could you contact the original developers?
>> > The answer is interesting, but I have no idea.
>
>> It seems it will be included in the 4.16 release:
>
>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg122619.html
>
>> Probably just a bit too late for 4.15.
>
>> Frederic
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
With Best Regards,
Andy Shevchenko
