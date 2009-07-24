Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:36524 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbZGXLOp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 07:14:45 -0400
Date: Fri, 24 Jul 2009 13:14:36 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: AceLan Kao <acelan.kao@canonical.com>
Cc: hugh@canonical.com, linux-media@vger.kernel.org
Subject: Re: Lenovo webcam problem which using gspca's vc032x driver
Message-ID: <20090724131436.69fab6ce@tele>
In-Reply-To: <91b198a70907232325p4ad94fc5n680ccb7e06daa65e@mail.gmail.com>
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
	<91b198a70907232325p4ad94fc5n680ccb7e06daa65e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 24 Jul 2009 14:25:33 +0800
AceLan Kao <acelan.kao@canonical.com> wrote:

> It sounds like that the Lenovo webcam(0x17ef, 0x4802) sensor and the
> 0x041e, 0x405b device sensor doesn't be placed at the same direction
> and the initial tables seems not so compatible.
> Do you think that it would be better to split the code for these two
> model of webcams? If yes, I can do some help.

Hi Acelan Kao,

An other guy with the 405b said that all modes were correct but 640x
and 320x upside down.

Looking at the .inf of the ms-win driver, it seems that the Mirror and
Vertical controls exist for the mi1310_soc sensor. May you change them
on ms-win? If yes, may you do a snoop to know which registers do the
job? Then, in the vc032x subdriver, only the set h/v flip had to be
inverted for the 2 webcam types.

Otherwise, I compared the sequences of the ms-win files C0130Dev.inf
(041e:405b) and usbvm323.inf (17ef:4802). The bridge sequences are
close enough, but the sensors sequences are completely different, as if
the sensors were different! So, it is not easy to find how the image
may be upside down...

BTW, I can't read your binary USB snoop. Have you any tool to read it
or may you send me a more readable version?

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
