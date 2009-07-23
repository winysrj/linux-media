Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:59317 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbZGWJsJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2009 05:48:09 -0400
Date: Thu, 23 Jul 2009 11:47:58 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: AceLan Kao <acelan.kao@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, hugh@canonical.com,
	linux-media@vger.kernel.org
Subject: Re: Lenovo webcam problem which using gspca's vc032x driver
Message-ID: <20090723114758.49a7026c@tele>
In-Reply-To: <91b198a70907220215t14d509e7u8b33623cecafa26f@mail.gmail.com>
References: <91b198a70907100305t762a4596r734e44f7f4f88bc3@mail.gmail.com>
	<20090711185415.3756dc26@pedra.chehab.org>
	<91b198a70907130042y6594a96do8634eebdfef8ba5c@mail.gmail.com>
	<91b198a70907162030l760bd7c5r32daaf6823c1dbe6@mail.gmail.com>
	<20090717043225.4c786455@pedra.chehab.org>
	<20090717124431.1bd3ea43@free.fr>
	<91b198a70907200004y5418796dkbf491d2cae877fb7@mail.gmail.com>
	<20090720105325.26f2ae1a@free.fr>
	<91b198a70907201918l68435905u1ad590144d664a29@mail.gmail.com>
	<91b198a70907220215t14d509e7u8b33623cecafa26f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 22 Jul 2009 17:15:15 +0800
AceLan Kao <acelan.kao@canonical.com> wrote:

> I would like to know which version of vc032x.c won't make 041e:405b
> device display upside down.
> And have you let the 041e:405b device owner to test the SXGA setting
> and with the 1280x960 resolution? What's the result?


Hi AceLan Kao,

The 041e:405b had a good display with the current version of vc032x
(i.e., including the change 'Webcam 041e:405b added and mi1310_soc
updated').

I've just asked the 405b owners to test the XGA resolution. I'll give
you the results as soon as I will get them.

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
