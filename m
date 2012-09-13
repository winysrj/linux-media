Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:38984 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551Ab2IMLcY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 07:32:24 -0400
Received: by weyx8 with SMTP id x8so1614671wey.19
        for <linux-media@vger.kernel.org>; Thu, 13 Sep 2012 04:32:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347535478.2429.345.camel@pizza.hi.pengutronix.de>
References: <1347462158-20417-1-git-send-email-p.zabel@pengutronix.de>
	<CACKLOr2XDFUU=_dQ+P=ff9o27+_YZTTiA_nS+tv5t09mwDFPrQ@mail.gmail.com>
	<CACKLOr2AjC3chZHK_jx1ZJsariT7i_f6pQ6BCiUJG+nfDzZBKA@mail.gmail.com>
	<1347535478.2429.345.camel@pizza.hi.pengutronix.de>
Date: Thu, 13 Sep 2012 13:32:23 +0200
Message-ID: <CACKLOr0NVi0tq3=ADRJPGJkjXA=+=u2=_Cu9vSNpgpYhK1a8pQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/13] Initial i.MX5/CODA7 support for the CODA driver
From: javier Martin <javier.martin@vista-silicon.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On 13 September 2012 13:24, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Am Donnerstag, den 13.09.2012, 09:51 +0200 schrieb javier Martin:
>> If you want to speed up the process and you have you could send a pull
>> request to Mauro.
>
> Should I include the four patches below in the pull request, or wait for
> them to hit staging/for_v3.7 ?

I think you should include them.
In fact it could be more comfortable for you to apply them before your
series and rebase those trivial patches instead of doing the opposite.
Unless you have developed your series on top of the four patches
below, which I think you didn't. Or maybe a rebase isn't necessary and
the patches apply cleanly. I haven't tried.

>> But be careful with the following patches that have been sent to the
>> list after the initial support of the driver and before these series:
>> http://patchwork.linuxtv.org/patch/14048/
>> https://patchwork.kernel.org/patch/1367011/
>> https://patchwork.kernel.org/patch/1363331/
>> https://patchwork.kernel.org/patch/1352551/
>
> regards
> Philipp
>



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
