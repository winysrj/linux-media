Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <miloody@gmail.com>) id 1KMJM9-0007Mh-TL
	for linux-dvb@linuxtv.org; Fri, 25 Jul 2008 11:12:59 +0200
Received: by wx-out-0506.google.com with SMTP id h27so1155773wxd.17
	for <linux-dvb@linuxtv.org>; Fri, 25 Jul 2008 02:12:53 -0700 (PDT)
Message-ID: <3a665c760807250212i1902e4fdud47da351262c140f@mail.gmail.com>
Date: Fri, 25 Jul 2008 17:12:53 +0800
From: loody <miloody@gmail.com>
To: "Nico Sabbi" <Nicola.Sabbi@poste.it>
In-Reply-To: <200807241153.55596.Nicola.Sabbi@poste.it>
MIME-Version: 1.0
Content-Disposition: inline
References: <3a665c760807240246x7bb3d442lac2b407dd138accf@mail.gmail.com>
	<200807241153.55596.Nicola.Sabbi@poste.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] question about definition of section in PSI of
	Transport stream
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

Hi:
thanks for your explanation.
BTW, I find all my Ts only have one section, section_number and
last_section_number are both 0.

Would you please tell me where I can get multi-sections TS for tracing?

appreciate your help,
miloody


2008/7/24 Nico Sabbi <Nicola.Sabbi@poste.it>:
> On Thursday 24 July 2008 11:46:48 loody wrote:
>> Dear all:
>> I am reading iso13818-1 right now.
>> But I cannot figure out what the section mean in PSI.
>>
>> In PAT, there is a N loop tell us how many programs in this TS and
>> the corresponding pid of PMT.
>> Is section equivalent to program?
>
> each item identifies a program and a pid
>
>> Suppose there is 10 loop in PAT, and there will be 10 sections,
>> right?
>
> no, the section is only needed to split overly long PATs and / or PMTs
> in smaller pieces
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
