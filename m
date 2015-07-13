Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:51401 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbbGMRr4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 13:47:56 -0400
Date: Mon, 13 Jul 2015 19:47:50 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Antti =?iso-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>,
	linux-media@vger.kernel.org, James Hogan <james@albanarts.com>
Subject: Re: [PATCH v3 1/7] rc: rc-ir-raw: Add scancode encoder callback
Message-ID: <20150713174750.GB3038@hardeman.nu>
References: <db6f383689a45d2d9b5346c41e48d535@hardeman.nu>
 <CAKv9HNY5jM-i5i420iu_kcfS2ZsnnMjdED59fxkxH5e5mjYe=Q@mail.gmail.com>
 <20150521194034.GB19532@hardeman.nu>
 <CAKv9HNbsCK_1XbYMgO3Monui9JnHc7knJL3yon9FUMJ_MCLppg@mail.gmail.com>
 <5418c2397b8a8dab54bfbcfe9ed3df1d@hardeman.nu>
 <CAKv9HNbGAta3BDSk=xjsviUuqMP7TBGtf4PhdfNn8B7N-Gz_dg@mail.gmail.com>
 <3b967113dc16d6edc8d8dd7df9be8b80@hardeman.nu>
 <20150618182305.577ba0df@recife.lan>
 <e50840af0dbb6e43148ae999a9c60da5@hardeman.nu>
 <20150629190524.GA29330@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150629190524.GA29330@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 29, 2015 at 09:05:24PM +0200, David Härdeman wrote:
>On Tue, Jun 23, 2015 at 10:45:42PM +0200, David Härdeman wrote:
>>On 2015-06-18 23:23, Mauro Carvalho Chehab wrote:
>>>Em Sun, 14 Jun 2015 01:44:54 +0200
>>>David Härdeman <david@hardeman.nu> escreveu:
>>>>Mauro....wake up? I hope you're not planning to push the current code
>>>>upstream???
>>>
>>>What's there are planned to be sent upstream. If you think that something
>>>is not mature enough to be applied, please send a patch reverting it,
>>>with "[PATCH FIXES]" in the subject, clearly explaining why it should be
>>>reverted for me to analyze. Having Antti/James acks on that would help.
>>
>>This thread should already provide you with all the information you need why
>>the patches should be reverted (including Antii saying the patches should be
>>reverted).
>>
>>The current code includes hilarious "features" like producing different
>>results depending on module load order and makes sure we'll be stuck with a
>>bad API. Sending them upstream will look quite foolish...
>
>And now the patches have been submitted and comitted upstream. What's
>your plan? Leave it like this?

Mauro, I see that you've applied four of my patches...thanks for
that...but the question is still what you plan to do about the patches
that should be reverted....4.2-rc2 was recently released and I'm still
not seeing any action on this while time is running out...?

-- 
David Härdeman
