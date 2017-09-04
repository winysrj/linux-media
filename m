Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36242 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753390AbdIDJlA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Sep 2017 05:41:00 -0400
MIME-Version: 1.0
In-Reply-To: <20170904060629.2f8feeab@vento.lan>
References: <cover.1504272067.git.mchehab@s-opensource.com>
 <CAJbz7-29pV9u0UZUC+sUtncsCbqbjNToA-yANJ7hExLRFw_tiQ@mail.gmail.com>
 <20170903215404.425af4aa@vento.lan> <CAJbz7-2EBp0U=jdQ6QyFmkNS=PSVNDrKGj1_H0RAEMmJsoxa8Q@mail.gmail.com>
 <20170904060629.2f8feeab@vento.lan>
From: =?UTF-8?Q?Honza_Petrou=C5=A1?= <jpetrous@gmail.com>
Date: Mon, 4 Sep 2017 11:40:59 +0200
Message-ID: <CAJbz7-24qJ8Qz9V_KArhn4uf_3fJwaDcGS399JCZ7nz2O_oBGQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/26] Improve DVB documentation and reduce its gap
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-09-04 11:06 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>=
:
> Em Mon, 4 Sep 2017 09:12:49 +0200
> Honza Petrou=C5=A1 <jpetrous@gmail.com> escreveu:
>
>> 2017-09-04 2:54 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.co=
m>:
>> > Em Sun, 3 Sep 2017 22:05:23 +0200
>> > Honza Petrou=C5=A1 <jpetrous@gmail.com> escreveu:
>> >
>> >> 1) #define CA_SET_DESCR      _IOW('o', 134, ca_descr_t)
>> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> >>
>> >> CA_SET_DESCR is used for feeding descrambler device
>> >> with correct keys (called here "control words") what
>> >> allows to get services unscrambled.
>> >>
>> >> The best docu is:
>> >>
>> >> "Digital Video Broadcasting (DVB);
>> >> Support for use of the DVB Scrambling Algorithm version 3
>> >> within digital broadcasting systems"
>> >>
>> >> Defined as DVB Document A125 and publicly
>> >> available here:
>> >>
>> >> https://www.dvb.org/resources/public/standards/a125_dvb-csa3.pdf
>> >>
>> >>
>> >> typedef struct ca_descr {
>> >>         unsigned int index;
>> >>         unsigned int parity;    /* 0 =3D=3D even, 1 =3D=3D odd */
>> >>         unsigned char cw[8];
>> >> } ca_descr_t;
>> >>
>> >> The 'index' is adress of the descrambler instance, as there exist
>> >> limited number of them (retieved by CA_GET_DESCR_INFO).
>> >
>> > Thanks for the info. If I understood well, the enclosed patch should
>> > be documenting it.
>> >
>> >
>> > Thanks,
>> > Mauro
>> >
>> > [PATCH] media: ca docs: document CA_SET_DESCR ioctl and structs
>> >
>> > The av7110 driver uses CA_SET_DESCR to store the descrambler
>> > control words at the CA descrambler slots.
>> >
>> > Document it.
>> >
>> > Thanks-to: Honza Petrou=C5=A1 <jpetrous@gmail.com>
>> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> >
>> > diff --git a/Documentation/media/uapi/dvb/ca-set-descr.rst b/Documenta=
tion/media/uapi/dvb/ca-set-descr.rst
>> > index 9c484317d55c..a6c47205ffd8 100644
>> > --- a/Documentation/media/uapi/dvb/ca-set-descr.rst
>> > +++ b/Documentation/media/uapi/dvb/ca-set-descr.rst
>> > @@ -28,22 +28,11 @@ Arguments
>> >  ``msg``
>> >    Pointer to struct :c:type:`ca_descr`.
>> >
>> > -.. c:type:: ca_descr
>> > -
>> > -.. code-block:: c
>> > -
>> > -    struct ca_descr {
>> > -       unsigned int index;
>> > -       unsigned int parity;
>> > -       unsigned char cw[8];
>> > -    };
>> > -
>> > -
>> >  Description
>> >  -----------
>> >
>> > -.. note:: This ioctl is undocumented. Documentation is welcome.
>> > -
>> > +CA_SET_DESCR is used for feeding descrambler CA slots with descrambli=
ng
>> > +keys (refered as control words).
>> >
>> >  Return Value
>> >  ------------
>> > diff --git a/include/uapi/linux/dvb/ca.h b/include/uapi/linux/dvb/ca.h
>> > index f66ed53f4dc7..a62ddf0cebcd 100644
>> > --- a/include/uapi/linux/dvb/ca.h
>> > +++ b/include/uapi/linux/dvb/ca.h
>> > @@ -109,9 +109,16 @@ struct ca_msg {
>> >         unsigned char msg[256];
>> >  };
>> >
>> > +/**
>> > + * struct ca_descr - CA descrambler control words info
>> > + *
>> > + * @index: CA Descrambler slot
>> > + * @parity: control words parity, where 0 means even and 1 means odd
>> > + * @cw: CA Descrambler control words
>> > + */
>> >  struct ca_descr {
>> >         unsigned int index;
>> > -       unsigned int parity;    /* 0 =3D=3D even, 1 =3D=3D odd */
>> > +       unsigned int parity;
>> >         unsigned char cw[8];
>> >  };
>> >
>> >
>>
>> Yeh, it should be that way.
>
> Good! I'll add this patch to the series.
>
>> BTW, the only issue I have in mind is how to link particular
>> descrambler with the PID
>> after your removal of the CA_SET_PID. And yes, I know that currently we =
have
>> no any user of such ioctl in our driver base :)
>
> Well, I don't think that an ioctl like CA_SET_PID would solve it.
>
> On a generic case with is quite common nowadays on embedded hardware,
> We have K demods and M CIs (where K may be different than M).
>
> Also, You may need to route N PIDs to O descramblers.

TBH that is exactly most common use-case =3D most Digital TV
vendors are scrambling per-service, what requires one descrambler
for all scrambled PIDs (usually only A/V PIDs are scrambled)
for particular service. So we have to add more PIDs to one descrambler

What was possible by multiple call of CA_SET_PID (I agree that much
better would be name like CA_ADD_PID)
>
> As user switch channels, the N PIDs should be unset, and another
> set of N' pids will be routed.
>
> CA_SET_PID allows to set just one PID, without identifying from
> what demod it would be received, and doesn't have a "reset"
> function to undo.

Here I can agree - it looks like the value -1 in 'index' should
do the job, but it, unfortunately, looses info from which descrambler
it should be removed (see note in struct ca_pid for value -1)

>
> So, IMHO, the interface is broken by design. Perhaps that's
> the reason why no upstream driver uses it.

I have the same feeling regarding brokenness.

>
> What seems to be a much better design would be to use the demux
> set filter ioctls and route the PIDs to the right CA.
>

I don't have access to any programmer reference documentation
for any modern DVB-enabled SoC, but I see two possible scenario
of connecting descramblers to the demuxes (most of modern SoCs
have more then one demux) - static one, when every demux has
predefined descramblers already connected to it and dynamic ones,
when any descrambler can be connected to the any demux.

>From that reason I vote to have some descrambler specific ioctl,
which allow more flexibility then if we add it to the filter set ioctl.

My 5 cents

/Honza

PS: I understand that until we get some multi-descrambler device included,
we don't need to address descrambler management.
