Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:48331 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbZHXWiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2009 18:38:04 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Mon, 24 Aug 2009 17:37:36 -0500
Subject: RE: [PATCH v1 - 1/5] DaVinci - restructuring code to support vpif
 capture driver
Message-ID: <A69FA2915331DC488A831521EAE36FE40154CEAA34@dlee06.ent.ti.com>
References: <1250283702-5582-1-git-send-email-m-karicheri2@ti.com>
	<A69FA2915331DC488A831521EAE36FE40145300FC7@dlee06.ent.ti.com>
	<200908180849.14003.hverkuil@xs4all.nl>
	<200908180851.06222.hverkuil@xs4all.nl>
	<A69FA2915331DC488A831521EAE36FE401548C1E27@dlee06.ent.ti.com>
	<20090818142817.26de0893@pedra.chehab.org>
	<A69FA2915331DC488A831521EAE36FE401548C23A5@dlee06.ent.ti.com>
	<20090820013306.696e5dd9@pedra.chehab.org>
	<A69FA2915331DC488A831521EAE36FE401548C2BFE@dlee06.ent.ti.com>
 <20090824000934.68b82d9c@pedra.chehab.org>
In-Reply-To: <20090824000934.68b82d9c@pedra.chehab.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kevin,

How do we handle this? 

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
new phone: 301-407-9583
Old Phone : 301-515-3736 (will be deprecated)
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Mauro Carvalho Chehab [mailto:mchehab@infradead.org]
>Sent: Sunday, August 23, 2009 11:10 PM
>To: Karicheri, Muralidharan
>Cc: Kevin Hilman; Mauro Carvalho Chehab; linux-media@vger.kernel.org; Hans
>Verkuil
>Subject: Re: [PATCH v1 - 1/5] DaVinci - restructuring code to support vpif
>capture driver
>
>Em Thu, 20 Aug 2009 16:27:40 -0500
>"Karicheri, Muralidharan" <m-karicheri2@ti.com> escreveu:
>
>> Kevin & Mauro,
>>
>> Do I need to wait or this can be resolved by either of you for my work to
>proceed?
>
>Murali,
>
>If I fix your patch in order to apply it on my tree, backporting it to the
>old
>arch header files, we'll have merge troubles upstream, when Kevin merge his
>changes. It will also mean that he'll need to apply a diff patch on his
>tree,
>in order to convert the patch to the new headers, and that git bisect may
>break. I might merge his tree here, but this means that, if he needs to
>rebase
>his tree (and sometimes people need to rebase their linux-next trees), I'll
>have troubles here, and I'll loose my work.
>
>So, the better solution is if he could apply this specific patch, merging
>his
>tree upstream before your patches.
>
>Cheers,
>Mauro

