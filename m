Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:63465 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZGXGas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 02:30:48 -0400
Received: by qw-out-2122.google.com with SMTP id 8so791650qwh.37
        for <linux-media@vger.kernel.org>; Thu, 23 Jul 2009 23:30:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090723114758.49a7026c@tele>
References: <91b198a70907100305t762a4596r734e44f7f4f88bc3@mail.gmail.com>
	 <91b198a70907130042y6594a96do8634eebdfef8ba5c@mail.gmail.com>
	 <91b198a70907162030l760bd7c5r32daaf6823c1dbe6@mail.gmail.com>
	 <20090717043225.4c786455@pedra.chehab.org>
	 <20090717124431.1bd3ea43@free.fr>
	 <91b198a70907200004y5418796dkbf491d2cae877fb7@mail.gmail.com>
	 <20090720105325.26f2ae1a@free.fr>
	 <91b198a70907201918l68435905u1ad590144d664a29@mail.gmail.com>
	 <91b198a70907220215t14d509e7u8b33623cecafa26f@mail.gmail.com>
	 <20090723114758.49a7026c@tele>
Date: Fri, 24 Jul 2009 14:25:33 +0800
Message-ID: <91b198a70907232325p4ad94fc5n680ccb7e06daa65e@mail.gmail.com>
Subject: Re: Lenovo webcam problem which using gspca's vc032x driver
From: AceLan Kao <acelan.kao@canonical.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, hugh@canonical.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/7/23 Jean-Francois Moine <moinejf@free.fr>:
> On Wed, 22 Jul 2009 17:15:15 +0800
> AceLan Kao <acelan.kao@canonical.com> wrote:
>
>> I would like to know which version of vc032x.c won't make 041e:405b
>> device display upside down.
>> And have you let the 041e:405b device owner to test the SXGA setting
>> and with the 1280x960 resolution? What's the result?
>
>
> Hi AceLan Kao,
>
> The 041e:405b had a good display with the current version of vc032x
> (i.e., including the change 'Webcam 041e:405b added and mi1310_soc
> updated').
>
> I've just asked the 405b owners to test the XGA resolution. I'll give
> you the results as soon as I will get them.
>
> Best regards.
>
> --
> Ken ar c'hentañ |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
>

Dear Jean-Francois,

It sounds like that the Lenovo webcam(0x17ef, 0x4802) sensor and the
0x041e, 0x405b device sensor doesn't be placed at the same direction
and the initial tables seems not so compatible.
Do you think that it would be better to split the code for these two
model of webcams? If yes, I can do some help.

Best regards,
AceLan Kao.

-- 
Chia-Lin Kao(AceLan)
http://blog.acelan.idv.tw/
E-Mail: acelan.kaoATcanonical.com (s/AT/@/)
