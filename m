Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <greblus@gmail.com>) id 1KymlT-0006JF-Pg
	for linux-dvb@linuxtv.org; Sat, 08 Nov 2008 13:18:12 +0100
Received: by wa-out-1112.google.com with SMTP id j40so1275803wah.1
	for <linux-dvb@linuxtv.org>; Sat, 08 Nov 2008 04:18:02 -0800 (PST)
Message-ID: <912f87b30811080418m66e6bc04g349c1dfabf5beb50@mail.gmail.com>
Date: Sat, 8 Nov 2008 13:18:01 +0100
From: "=?ISO-8859-2?Q?Wiktor_Gr=EAbla?=" <greblus@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <d9def9db0811080302r35823330k167042d2e8462340@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	<200811011459.17706.hverkuil@xs4all.nl>
	<20081102022728.68e5e564@pedra.chehab.org>
	<a2aa6e3a0811072150t535e802cge3375a7b88ee6287@mail.gmail.com>
	<20081108081508.496f6582@pedra.chehab.org>
	<d9def9db0811080222l57e9db9fwb835395d6069571@mail.gmail.com>
	<alpine.LFD.2.00.0811080529000.7489@bombadil.infradead.org>
	<d9def9db0811080242v5fd108c6g80873f681e17224a@mail.gmail.com>
	<alpine.LFD.2.00.0811080549191.7489@bombadil.infradead.org>
	<d9def9db0811080302r35823330k167042d2e8462340@mail.gmail.com>
Subject: Re: [linux-dvb] [PATCH 1/7] Adding empia base driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Markus.

Maybe it's worth to note that I've wasted nice Saturday evening in
order to find this trivial modification, after you refused to help in
solving this annoying issue.

I'm sorry. If you need an authorship attribution let's be fair. The
patch resulted from your repos diffing because you simply wanted
em28xx driver to remain 'inferior' in the mainline kernel.

It's also worth to note that mainline driver works fine. No audio
problems, oopses, etc.

Cheers,
W.


2008/11/8 Markus Rechberger <mrechberger@gmail.com>:
> On Sat, Nov 8, 2008 at 11:56 AM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
>> On Sat, 8 Nov 2008, Markus Rechberger wrote:
>>
>>> Should I start picking patches from the linuxtv.org tree where patches
>>> from my tree are taken
>>> and where the Sign off is not provided?
>>
>> SOB's are just meant to testify that the code is GPL. It has nothing to do
>> with authorship.
>>
>> On all cases I'm aware, when some code from your tree were merged upstream,
>> your authorship were marked inside the patch's description. Also, your
>> authorship are explicit at the em28xx files you've contributed.
>>
>
> really?
> http://linuxtv.org/hg/v4l-dvb/rev/5f3c3af9c1f9
>
> http://article.gmane.org/gmane.linux.drivers.dvb/44726
>
> nevermind.
>
> Markus
>


-- 
Talkers are no good doers.
http://greblus.net/djangoblog/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
