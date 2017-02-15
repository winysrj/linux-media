Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44576
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750800AbdBONN1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 08:13:27 -0500
Date: Wed, 15 Feb 2017 11:13:18 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gregor Jasny <gjasny@googlemail.com>
Cc: Marcel Heinz <quisquilia@gmx.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Bug#854100: libdvbv5-0: fails to tune / scan
Message-ID: <20170215111318.65ae1f0b@vento.lan>
In-Reply-To: <20170213080448.11f49304@vento.lan>
References: <148617570740.6827.6324247760769667383.reportbug@ixtlilton.netz.invalid>
        <0db3f8d1-0461-5d82-a92d-ecc3cfcfec71@googlemail.com>
        <8792984d-54c9-01a8-0f84-7a1f0312a12f@gmx.de>
        <CAJxGH0-ewWzxSJ1vE+n4FMkqv+pnmT9G0uAZS5oUYkhxWm+=5A@mail.gmail.com>
        <ba755934-7946-59ea-e900-fe76d4ea2f0a@gmx.de>
        <458abbd2-a98b-243b-bf2f-48d5e5a8060b@googlemail.com>
        <20170213080448.11f49304@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gregor,

Em Mon, 13 Feb 2017 08:04:48 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Fri, 10 Feb 2017 22:02:01 +0100
> Gregor Jasny <gjasny@googlemail.com> escreveu:
> 
> > Hello Mauro & DVB-S maintainers,
> > 
> > could you please have a look at the bug report below? Marcel was so kind
> > to bisect the problem to the following commit:
> > 
> > https://git.linuxtv.org/v4l-utils.git/commit/?id=d982b0d03b1f929269104bb716c9d4b50c945125
> 
> Sorry for not handling it earlier. I took vacations on Jan, and had a pile
> of patches to handle after my return. I had to priorize them, as we're
> close to a Kernel merge window.
> 
> Now that Linus postponed the merge window, I had some time to dig into
> it.
> 
> > 
> > Bug report against libdvbv5 is here:
> > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=854100
> 
> There was a bug at the logic that was checking if the frequency was
> at the range of the local oscillators. This patch should be addressing
> it:
> 	https://git.linuxtv.org/v4l-utils.git/commit/?id=5380ad44de416a41b4972e8a9c147ce42b0e3ba0
> 
> With that, the logic now seems to be working fine:
> 
> $ ./utils/dvb/dvbv5-scan ~/Intelsat-34 --lnbf universal -vv
> Using LNBf UNIVERSAL
> 	Universal, Europe
> 	10800 to 11800 MHz, LO: 9750 MHz
> 	11600 to 12700 MHz, LO: 10600 MHz
> ...
> Seeking for LO for 12.17 MHz frequency
> LO setting 0: 10.80 MHz to 11.80 MHz
> LO setting 1: 11.60 MHz to 12.70 MHz
> Multi-LO LNBf. using LO setting 1 at 10600.00 MHz
> frequency: 12170.00 MHz, high_band: 1
> L-Band frequency: 1570.00 MHz (offset = 10600.00 MHz)
> 
> I can't really test it here, as my satellite dish uses a different
> type of LNBf, but, from the above logs, the bug should be fixed.
> 
> Marcel,
> 
> Could you please test? The patch is already upstream.
> I added a debug patch after it, in order to help LNBf issues
> (enabled by using "-vv" command line parameters).

I added both patches to stable-1.12 branch. I also added a small
patch there adding support for an extra LNBf model at the DVB
Satellite table. Such change is not disruptive, as it just
adds a new element on an already-existing table.

Btw, I found another bug there. Starting to look on it right now.

There's something wrong with translations there. It seems that
something is causing i18n to print its headers instead of doing
the right thing. 

I'm enclosing the results at the end of this e-mail, with 
pt_BR translation, with is currently the only one available.

I think you should wait for this bug to get fixed before releasing
a new -stable release.

Thanks,
Mauro

---

$ LANG=pt_BR.utf8 dvbv5-scan -l
Por favor selecione o modelo do LNBf  abaixo:
UNIVERSAL
	Universal, Europe
	Project-Id-Version: libdvbv5 1.7.0
Report-Msgid-Bugs-To: linux-media@vger.Kernel.org
POT-Creation-Date: 2016-01-24 08:42+0100
PO-Revision-Date: 2015-05-13 19:33-0300
Last-Translator: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Language-Team: Brazilian Portuguese
Language: pt_BR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
X-Generator: Poedit 1.7.5
X-Poedit-KeywordsList: _;N_
X-Poedit-Basepath: ../
X-Poedit-SourceCharset: UTF-8
X-Poedit-SearchPath-0: lib/libdvbv5
10800 to 11800 MHz, LO: 9750 MHz
	Project-Id-Version: libdvbv5 1.7.0
Report-Msgid-Bugs-To: linux-media@vger.Kernel.org
POT-Creation-Date: 2016-01-24 08:42+0100
PO-Revision-Date: 2015-05-13 19:33-0300
Last-Translator: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Language-Team: Brazilian Portuguese
Language: pt_BR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
X-Generator: Poedit 1.7.5
X-Poedit-KeywordsList: _;N_
X-Poedit-Basepath: ../
X-Poedit-SourceCharset: UTF-8
X-Poedit-SearchPath-0: lib/libdvbv5
11600 to 12700 MHz, LO: 10600 MHz

DBS
	Expressvu, North America
	Project-Id-Version: libdvbv5 1.7.0
Report-Msgid-Bugs-To: linux-media@vger.Kernel.org
POT-Creation-Date: 2016-01-24 08:42+0100
PO-Revision-Date: 2015-05-13 19:33-0300
Last-Translator: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Language-Team: Brazilian Portuguese
Language: pt_BR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
X-Generator: Poedit 1.7.5
X-Poedit-KeywordsList: _;N_
X-Poedit-Basepath: ../
X-Poedit-SourceCharset: UTF-8
X-Poedit-SearchPath-0: lib/libdvbv5
12200 to 12700 MHz, LO: 11250 MHz

EXTENDED
	Astra 1E, European Universal Ku (extended)
	Project-Id-Version: libdvbv5 1.7.0
Report-Msgid-Bugs-To: linux-media@vger.Kernel.org
POT-Creation-Date: 2016-01-24 08:42+0100
PO-Revision-Date: 2015-05-13 19:33-0300
Last-Translator: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Language-Team: Brazilian Portuguese
Language: pt_BR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
X-Generator: Poedit 1.7.5
X-Poedit-KeywordsList: _;N_
X-Poedit-Basepath: ../
X-Poedit-SourceCharset: UTF-8
X-Poedit-SearchPath-0: lib/libdvbv5
10700 to 11700 MHz, LO: 9750 MHz
	Project-Id-Version: libdvbv5 1.7.0
Report-Msgid-Bugs-To: linux-media@vger.Kernel.org
POT-Creation-Date: 2016-01-24 08:42+0100
PO-Revision-Date: 2015-05-13 19:33-0300
Last-Translator: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Language-Team: Brazilian Portuguese
Language: pt_BR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
X-Generator: Poedit 1.7.5
X-Poedit-KeywordsList: _;N_
X-Poedit-Basepath: ../
X-Poedit-SourceCharset: UTF-8
X-Poedit-SearchPath-0: lib/libdvbv5
11700 to 12750 MHz, LO: 10600 MHz

STANDARD
	Standard
	Project-Id-Version: libdvbv5 1.7.0
Report-Msgid-Bugs-To: linux-media@vger.Kernel.org
POT-Creation-Date: 2016-01-24 08:42+0100
PO-Revision-Date: 2015-05-13 19:33-0300
Last-Translator: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Language-Team: Brazilian Portuguese
Language: pt_BR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
X-Generator: Poedit 1.7.5
X-Poedit-KeywordsList: _;N_
X-Poedit-Basepath: ../
X-Poedit-SourceCharset: UTF-8
X-Poedit-SearchPath-0: lib/libdvbv5
10945 to 11450 MHz, LO: 10000 MHz

L10700
	L10700
	Project-Id-Version: libdvbv5 1.7.0
Report-Msgid-Bugs-To: linux-media@vger.Kernel.org
POT-Creation-Date: 2016-01-24 08:42+0100
PO-Revision-Date: 2015-05-13 19:33-0300
Last-Translator: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Language-Team: Brazilian Portuguese
Language: pt_BR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
X-Generator: Poedit 1.7.5
X-Poedit-KeywordsList: _;N_
X-Poedit-Basepath: ../
X-Poedit-SourceCharset: UTF-8
X-Poedit-SearchPath-0: lib/libdvbv5
11750 to 12750 MHz, LO: 10700 MHz

L11300
	L11300
	Project-Id-Version: libdvbv5 1.7.0
Report-Msgid-Bugs-To: linux-media@vger.Kernel.org
POT-Creation-Date: 2016-01-24 08:42+0100
PO-Revision-Date: 2015-05-13 19:33-0300
Last-Translator: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Language-Team: Brazilian Portuguese
Language: pt_BR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
X-Generator: Poedit 1.7.5
X-Poedit-KeywordsList: _;N_
X-Poedit-Basepath: ../
X-Poedit-SourceCharset: UTF-8
X-Poedit-SearchPath-0: lib/libdvbv5
12250 to 12750 MHz, LO: 11300 MHz

ENHANCED
	Astra
	Project-Id-Version: libdvbv5 1.7.0
Report-Msgid-Bugs-To: linux-media@vger.Kernel.org
POT-Creation-Date: 2016-01-24 08:42+0100
PO-Revision-Date: 2015-05-13 19:33-0300
Last-Translator: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Language-Team: Brazilian Portuguese
Language: pt_BR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
X-Generator: Poedit 1.7.5
X-Poedit-KeywordsList: _;N_
X-Poedit-Basepath: ../
X-Poedit-SourceCharset: UTF-8
X-Poedit-SearchPath-0: lib/libdvbv5
10700 to 11700 MHz, LO: 9750 MHz

QPH031
	Invacom QPH-031
	Project-Id-Version: libdvbv5 1.7.0
Report-Msgid-Bugs-To: linux-media@vger.Kernel.org
POT-Creation-Date: 2016-01-24 08:42+0100
PO-Revision-Date: 2015-05-13 19:33-0300
Last-Translator: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Language-Team: Brazilian Portuguese
Language: pt_BR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
X-Generator: Poedit 1.7.5
X-Poedit-KeywordsList: _;N_
X-Poedit-Basepath: ../
X-Poedit-SourceCharset: UTF-8
X-Poedit-SearchPath-0: lib/libdvbv5
11700 to 12200 MHz, LO: 10750 MHz
	Project-Id-Version: libdvbv5 1.7.0
Report-Msgid-Bugs-To: linux-media@vger.Kernel.org
POT-Creation-Date: 2016-01-24 08:42+0100
PO-Revision-Date: 2015-05-13 19:33-0300
Last-Translator: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Language-Team: Brazilian Portuguese
Language: pt_BR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
X-Generator: Poedit 1.7.5
X-Poedit-KeywordsList: _;N_
X-Poedit-Basepath: ../
X-Poedit-SourceCharset: UTF-8
X-Poedit-SearchPath-0: lib/libdvbv5
12200 to 12700 MHz, LO: 11250 MHz

C-BAND
	Big Dish - Monopoint LNBf
	Project-Id-Version: libdvbv5 1.7.0
Report-Msgid-Bugs-To: linux-media@vger.Kernel.org
POT-Creation-Date: 2016-01-24 08:42+0100
PO-Revision-Date: 2015-05-13 19:33-0300
Last-Translator: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Language-Team: Brazilian Portuguese
Language: pt_BR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
X-Generator: Poedit 1.7.5
X-Poedit-KeywordsList: _;N_
X-Poedit-Basepath: ../
X-Poedit-SourceCharset: UTF-8
X-Poedit-SearchPath-0: lib/libdvbv5
3700 to 4200 MHz, LO: 5150 MHz

C-MULT
	Big Dish - Multipoint LNBf (bandstacking)
	Right     : 3700 to 4200 MHz, LO: 5150 MHz
	Left      : 3700 to 4200 MHz, LO: 5750 MHz

DISHPRO
	DishPro LNBf (bandstacking)
	Vertical  : 12200 to 12700 MHz, LO: 11250 MHz
	Horizontal: 12200 to 12700 MHz, LO: 14350 MHz

110BS
	Japan 110BS/CS LNBf
	Project-Id-Version: libdvbv5 1.7.0
Report-Msgid-Bugs-To: linux-media@vger.Kernel.org
POT-Creation-Date: 2016-01-24 08:42+0100
PO-Revision-Date: 2015-05-13 19:33-0300
Last-Translator: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Language-Team: Brazilian Portuguese
Language: pt_BR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
X-Generator: Poedit 1.7.5
X-Poedit-KeywordsList: _;N_
X-Poedit-Basepath: ../
X-Poedit-SourceCharset: UTF-8
X-Poedit-SearchPath-0: lib/libdvbv5
11710 to 12751 MHz, LO: 10678 MHz

STACKED-BRASILSAT
	BrasilSat Stacked (bandstacking)
	Horizontal: 10700 to 11700 MHz, LO: 9710 MHz
	Horizontal: 10700 to 11700 MHz, LO: 9750 MHz

OI-BRASILSAT
	BrasilSat Oi
	Project-Id-Version: libdvbv5 1.7.0
Report-Msgid-Bugs-To: linux-media@vger.Kernel.org
POT-Creation-Date: 2016-01-24 08:42+0100
PO-Revision-Date: 2015-05-13 19:33-0300
Last-Translator: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Language-Team: Brazilian Portuguese
Language: pt_BR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
X-Generator: Poedit 1.7.5
X-Poedit-KeywordsList: _;N_
X-Poedit-Basepath: ../
X-Poedit-SourceCharset: UTF-8
X-Poedit-SearchPath-0: lib/libdvbv5
10950 to 11200 MHz, LO: 10000 MHz
	Project-Id-Version: libdvbv5 1.7.0
Report-Msgid-Bugs-To: linux-media@vger.Kernel.org
POT-Creation-Date: 2016-01-24 08:42+0100
PO-Revision-Date: 2015-05-13 19:33-0300
Last-Translator: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Language-Team: Brazilian Portuguese
Language: pt_BR
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=2; plural=(n > 1);
X-Generator: Poedit 1.7.5
X-Poedit-KeywordsList: _;N_
X-Poedit-Basepath: ../
X-Poedit-SourceCharset: UTF-8
X-Poedit-SearchPath-0: lib/libdvbv5
11800 to 12200 MHz, LO: 10445 MHz

AMAZONAS
	BrasilSat Amazonas 1/2 - 3 Oscilators (bandstacking)
	Vertical  : 11037 to 11450 MHz, LO: 9670 MHz
	Horizontal: 11770 to 12070 MHz, LO: 9922 MHz
	Horizontal: 10950 to 11280 MHz, LO: 10000 MHz

AMAZONAS
	BrasilSat Amazonas 1/2 - 2 Oscilators (bandstacking)
	Vertical  : 11037 to 11360 MHz, LO: 9670 MHz
	Horizontal: 11780 to 12150 MHz, LO: 10000 MHz
	Horizontal: 10950 to 11280 MHz, LO: 10000 MHz

GVT-BRASILSAT
	BrasilSat custom GVT (bandstacking)
	Vertical  : 11010 to 11067 MHz, LO: 12860 MHz
	Vertical  : 11704 to 11941 MHz, LO: 13435 MHz
	Horizontal: 10962 to 11199 MHz, LO: 13112 MHz
	Horizontal: 11704 to 12188 MHz, LO: 13138 MHz
