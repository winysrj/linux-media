Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:37821 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488Ab3AIOox (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jan 2013 09:44:53 -0500
Message-ID: <50ED824E.708@schinagl.nl>
Date: Wed, 09 Jan 2013 15:44:30 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
References: <507FE752.6010409@schinagl.nl> <50D0E7A7.90002@schinagl.nl> <50EAA778.6000307@gmail.com> <50EAC41D.4040403@schinagl.nl> <20130108200149.GB408@linuxtv.org> <50ED3BBB.4040405@schinagl.nl> <20130109084143.5720a1d6@redhat.com> <20130109084425.7ac6dc50@redhat.com> <50ED4CEB.3050303@schinagl.nl> <20130109100438.748924c8@redhat.com> <50ED616D.1070108@schinagl.nl> <20130109123758.7d91ab5a@redhat.com>
In-Reply-To: <20130109123758.7d91ab5a@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

On 09-01-13 15:37, Mauro Carvalho Chehab wrote:
> Hi Oliver,
>
> Em Wed, 09 Jan 2013 13:24:13 +0100
> Oliver Schinagl <oliver@schinagl.nl> escreveu:
>
>>>>>> If I understood it right, you want to split the scan files into a separate
>>>>>> git tree and maintain it, right?
>>>>>>
>>>>>> I'm ok with that.
<snip>
>>>>> I also migrated the dvb-apps changesets with the tables to: 
>>>>> http://git.linuxtv.org/dtv-scan-tables.git Feel free to maintain it.
Thank you, this will be the new name for it (I will locally rename it) 
and try my bestest to maintain it :)

I will put a mention on the wiki 'how to submit scanfiles' (via the ML 
with tags in subject/pull requests) so people have a clear way how to 
submit them and I have a clear way to find them.

>
> You should also have access to the dvb-apps hg tree. IMHO, it makes sense
> to remove the files from there, and add a pointer there (README?) to the
> new tree.
I will remove the scanfiles from there, add/edit the readme that the 
tree is a dependancy?
>
> Regards,
> Mauro.
>
Oliver
