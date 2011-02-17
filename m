Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx12.extmail.prod.ext.phx2.redhat.com
	[10.5.110.17])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p1HK6gvr003081
	for <video4linux-list@redhat.com>; Thu, 17 Feb 2011 15:06:42 -0500
Received: from smtp2.sms.unimo.it (smtp2.sms.unimo.it [155.185.44.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1HK6YU3022243
	for <video4linux-list@redhat.com>; Thu, 17 Feb 2011 15:06:34 -0500
Received: from mail-qw0-f51.google.com ([209.85.216.51]:32901)
	by smtp2.sms.unimo.it with esmtps (TLS1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.69) (envelope-from <76466@studenti.unimore.it>)
	id 1PqA7V-00024M-33
	for video4linux-list@redhat.com; Thu, 17 Feb 2011 21:06:33 +0100
Received: by qwb7 with SMTP id 7so2839840qwb.24
	for <video4linux-list@redhat.com>; Thu, 17 Feb 2011 12:06:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1102172029220.30692@axis700.grange>
References: <AANLkTika03k=cppbejCHkuOT+Uq9ptVHZwYa80ubwLqT@mail.gmail.com>
	<Pine.LNX.4.64.1102172029220.30692@axis700.grange>
Date: Thu, 17 Feb 2011 21:06:13 +0100
Message-ID: <AANLkTi=9hTp-s0UGKMNrTJOL0pzhnsunWkA6UwpobJE5@mail.gmail.com>
Subject: Re: Kernel configuration for ov9655 on the PXA27x Quick Capture
	Interface
From: Paolo Santinelli <paolo.santinelli@unimore.it>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

Hi Guennadi,

thank you for the information.

Can I use or adapt this patch:  https://patchwork.kernel.org/patch/16548/  ?

I Could  use the code from the patch  to direct control the sensor
register configuration and use the  PXA27x Quick Capture Interface to
capture data by mean "soc_camera" and "pxa_camera" driver modules. But
now when I try to load the soc_camera module i get this error:

insmod soc_camera.ko
insmod: cannot insert 'soc_camera.ko': No such device

Please, could you give mi some tips and indication

Thanks

Paolo

2011/2/17 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> On Wed, 16 Feb 2011, Paolo Santinelli wrote:
>
>> Hi all,
>>
>> I have an embedded smart camera equipped with an XScal-PXA270
>> processor running Linux 2.6.37 and the OV9655 Image sensor connected
>> on the PXA27x Quick Capture Interface.
>>
>> Please, what kernel module I have to select in order to use the Image se=
nsor ?
>
> You need to write a new or adapt an existing driver for your ov9655
> sensor, currently, there's no driver available to work with your pxa270.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>



-- =

--------------------------------------------------
Paolo Santinelli
ImageLab Computer Vision and Pattern Recognition Lab
Dipartimento di Ingegneria dell'Informazione
Universita' di Modena e Reggio Emilia
via Vignolese 905/B, 41125, Modena, Italy

Cell. +39 3472953357,=A0 Office +39 059 2056270, Fax +39 059 2056129
email:=A0 <mailto:paolo.santinelli@unimore.it> paolo.santinelli@unimore.it
URL:=A0 <http://imagelab.ing.unimo.it/> http://imagelab.ing.unimo.it
--------------------------------------------------

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
