Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:37876 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751949AbdIDHMu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Sep 2017 03:12:50 -0400
MIME-Version: 1.0
In-Reply-To: <20170903215404.425af4aa@vento.lan>
References: <cover.1504272067.git.mchehab@s-opensource.com>
 <CAJbz7-29pV9u0UZUC+sUtncsCbqbjNToA-yANJ7hExLRFw_tiQ@mail.gmail.com> <20170903215404.425af4aa@vento.lan>
From: =?UTF-8?Q?Honza_Petrou=C5=A1?= <jpetrous@gmail.com>
Date: Mon, 4 Sep 2017 09:12:49 +0200
Message-ID: <CAJbz7-2EBp0U=jdQ6QyFmkNS=PSVNDrKGj1_H0RAEMmJsoxa8Q@mail.gmail.com>
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

2017-09-04 2:54 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> Em Sun, 3 Sep 2017 22:05:23 +0200
> Honza Petrou=C5=A1 <jpetrous@gmail.com> escreveu:
>
>> 1) #define CA_SET_DESCR      _IOW('o', 134, ca_descr_t)
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> CA_SET_DESCR is used for feeding descrambler device
>> with correct keys (called here "control words") what
>> allows to get services unscrambled.
>>
>> The best docu is:
>>
>> "Digital Video Broadcasting (DVB);
>> Support for use of the DVB Scrambling Algorithm version 3
>> within digital broadcasting systems"
>>
>> Defined as DVB Document A125 and publicly
>> available here:
>>
>> https://www.dvb.org/resources/public/standards/a125_dvb-csa3.pdf
>>
>>
>> typedef struct ca_descr {
>>         unsigned int index;
>>         unsigned int parity;    /* 0 =3D=3D even, 1 =3D=3D odd */
>>         unsigned char cw[8];
>> } ca_descr_t;
>>
>> The 'index' is adress of the descrambler instance, as there exist
>> limited number of them (retieved by CA_GET_DESCR_INFO).
>
> Thanks for the info. If I understood well, the enclosed patch should
> be documenting it.
>
>
> Thanks,
> Mauro
>
> [PATCH] media: ca docs: document CA_SET_DESCR ioctl and structs
>
> The av7110 driver uses CA_SET_DESCR to store the descrambler
> control words at the CA descrambler slots.
>
> Document it.
>
> Thanks-to: Honza Petrou=C5=A1 <jpetrous@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>
> diff --git a/Documentation/media/uapi/dvb/ca-set-descr.rst b/Documentatio=
n/media/uapi/dvb/ca-set-descr.rst
> index 9c484317d55c..a6c47205ffd8 100644
> --- a/Documentation/media/uapi/dvb/ca-set-descr.rst
> +++ b/Documentation/media/uapi/dvb/ca-set-descr.rst
> @@ -28,22 +28,11 @@ Arguments
>  ``msg``
>    Pointer to struct :c:type:`ca_descr`.
>
> -.. c:type:: ca_descr
> -
> -.. code-block:: c
> -
> -    struct ca_descr {
> -       unsigned int index;
> -       unsigned int parity;
> -       unsigned char cw[8];
> -    };
> -
> -
>  Description
>  -----------
>
> -.. note:: This ioctl is undocumented. Documentation is welcome.
> -
> +CA_SET_DESCR is used for feeding descrambler CA slots with descrambling
> +keys (refered as control words).
>
>  Return Value
>  ------------
> diff --git a/include/uapi/linux/dvb/ca.h b/include/uapi/linux/dvb/ca.h
> index f66ed53f4dc7..a62ddf0cebcd 100644
> --- a/include/uapi/linux/dvb/ca.h
> +++ b/include/uapi/linux/dvb/ca.h
> @@ -109,9 +109,16 @@ struct ca_msg {
>         unsigned char msg[256];
>  };
>
> +/**
> + * struct ca_descr - CA descrambler control words info
> + *
> + * @index: CA Descrambler slot
> + * @parity: control words parity, where 0 means even and 1 means odd
> + * @cw: CA Descrambler control words
> + */
>  struct ca_descr {
>         unsigned int index;
> -       unsigned int parity;    /* 0 =3D=3D even, 1 =3D=3D odd */
> +       unsigned int parity;
>         unsigned char cw[8];
>  };
>
>

Yeh, it should be that way.

BTW, the only issue I have in mind is how to link particular
descrambler with the PID
after your removal of the CA_SET_PID. And yes, I know that currently we hav=
e
no any user of such ioctl in our driver base :)

/Honza
