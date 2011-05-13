Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:46759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757903Ab1EMIKv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 04:10:51 -0400
Message-ID: <4DCCE77B.8090905@redhat.com>
Date: Fri, 13 May 2011 10:10:35 +0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: HoP <jpetrous@gmail.com>
CC: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
	linux-media@vger.kernel.org, Andreas Oberritter <obi@linuxtv.org>
Subject: Re: dvb-core/dvb_frontend.c: Synchronizing legacy and new tuning
 API
References: <87sjslaxwz.fsf@nemi.mork.no>	<4DCAEED2.6040906@linuxtv.org>	<87oc38bdsf.fsf@nemi.mork.no> <BANLkTinqjMYEkZc4-+rAgfb952_NnCNYkQ@mail.gmail.com>
In-Reply-To: <BANLkTinqjMYEkZc4-+rAgfb952_NnCNYkQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 12-05-2011 09:12, HoP escreveu:
> 2011/5/12 Bjørn Mork <bjorn@mork.no>:
>> Andreas Oberritter <obi@linuxtv.org> writes:
>>
>>> Please try the patches submitted for testing:
>>>
>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg31194.html
>>
>> Ah, great! Thanks.  Nothing better than a problem already solved.
> 
> Not solved. Andreas did an attempt to solve it (at least as far as I know
> patches not get accepted yet), so please report your result of testing.

The better is reply to the patches with a Tested-by: 

This helps me to better handle the patches when analyzing them. 

PS.: I shouldn't be touching on it until next week, as it is harder for
me to work remotely, and I can't test it from here.

Mauro.
