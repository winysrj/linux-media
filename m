Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:48744 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbbBXNrJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2015 08:47:09 -0500
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] media: Pinnacle 73e infrared control stopped working  since kernel 3.17
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Tue, 24 Feb 2015 14:47:08 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: =?UTF-8?Q?David_Cimb=C5=AFrek?= <david.cimburek@gmail.com>,
	Luis de Bethencourt <luis@debethencourt.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
In-Reply-To: <20150224104438.53bcfd59@recife.lan>
References: <CAEmZozMOenY096OwgMgdL27hizp8Z26PJ_ZZRsq0DyNpSZam-g@mail.gmail.com>
 <54D9E14A.5090200@iki.fi> <e65f6b905eae37f11e697ad20b97c37c@hardeman.nu>
 <CAEmZozPN2xDQMyao8GAYB1KqKxvgznn6CNc+LgPGhE=TJfDbFQ@mail.gmail.com>
 <32c10d8cd2303ed9476db1b68924170a@hardeman.nu>
 <CAEmZozP5jrJnWAF6ZbXtvkRveZE29BnSg+hO2x9KDSyPmjBBaQ@mail.gmail.com>
 <20150212095029.018f63df@recife.lan>
 <CAEmZozOTuigxavH_5M4mw5kDHS_mxgwLS53HipG2o4uvm_09OQ@mail.gmail.com>
 <20150212215700.GA4882@turing>
 <CAEmZozPKsBwq4=TtAOtR-LdjOi3k8MhmEqZ49gg8X48P1f5wdQ@mail.gmail.com>
 <CAEmZozMP1FFN-Y1d+7Mopy1Y9_2FjX2tJmmCne_Gpa2+_yFg0g@mail.gmail.com>
 <67d0fa2066c017a66ad785dc90447d08@hardeman.nu>
 <20150224104438.53bcfd59@recife.lan>
Message-ID: <743019811e24099226b55a708d7699af@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-02-24 14:44, Mauro Carvalho Chehab wrote:
> Em Tue, 24 Feb 2015 11:15:53 +0100
> David Härdeman <david@hardeman.nu> escreveu:
>> The output that you gave (the actual scancodes that are generated) is
>> what I was looking for, not the keymap. If I remember correctly my 
>> patch
>> wasn't supposed to change the generated scancodes (or the keymap would
>> have to be changed as well).
>> 
>> The question is whether the right thing to do is to change back the
>> scancode calculation or to update the keymap. I'll try to have a 
>> closer
>> look as soon as possible (which might take a few days more, sorry).
> 
> I suspect we should change back the scancode calculation, as I think 
> that
> the scancode table is right, but I need to do some tests with some 
> other
> driver to be certain.
> 
> I have a few devices here that I can use for testing, including a PCTV
> remote, just lacking the time.

I've exchanged a few more emails with David. I think I know what the 
problem is now. It's not the NEC scancode generation, it's that my patch 
accidentally broke the RC5 case (his remote is an RC5 one). I'll post a 
patch later.


