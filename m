Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:7669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab1CYQpI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 12:45:08 -0400
Message-ID: <4D8CC691.7020201@redhat.com>
Date: Fri, 25 Mar 2011 13:45:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] HVR-900 R2 and PCTV 330e DVB support
References: <AANLkTi=hppcpARY1DOOJwK7kyKPe+2Q415jt8dNh8Z=-@mail.gmail.com>	<4D8CB9C0.1000005@redhat.com> <AANLkTimW+e8-YC=nFdiKYr=6TKYRozf8uAct21i5QHN0@mail.gmail.com>
In-Reply-To: <AANLkTimW+e8-YC=nFdiKYr=6TKYRozf8uAct21i5QHN0@mail.gmail.com>
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 25-03-2011 13:09, Devin Heitmueller escreveu:
> On Fri, Mar 25, 2011 at 11:50 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> I've added a patch for it at the end of the series.
>>
>> Could you please double check if everything is ok, for me to move this upstream?
>>
>> Thanks!
>> Mauro
>>
> 
> Sure, I will find some time this weekend to try out your tree.

Ok, thanks!
> 
> http://git.linuxtv.org/mchehab/experimental.git?a=blobdiff;f=drivers/media/dvb/frontends/drxd.h;h=7113535844f2304f58e24571f538b9a71528cfb9;hp=d3d6c9246535def0e309f0714c9acbec0f350e25;hb=cf36b96eac59311f37b7881a6f48b465d1522fe9;hpb=df1bf4caabf1284289a4f6d7c1516e74c4e944c8
> 
> This patch is a bit funny, because the latest version of Lindent
> actually introduced the space between "*" and "off".  Might be
> something for you to consider looking at in the tool.

indent tool has some drawbacks. Sometimes, it does bad things, but when
the code has lots of issues, it is still better than nothing. Maybe it
believed that off is some keyword.
> 
> Devin
> 

