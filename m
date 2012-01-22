Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab2AVCNc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 21:13:32 -0500
Message-ID: <4F1B70B6.10209@redhat.com>
Date: Sun, 22 Jan 2012 00:13:10 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Christian_Pr=E4hauser?= <cpraehaus@cosy.sbg.ac.at>
CC: linux-media@vger.kernel.org
Subject: Re: DVB-S2 multistream support
References: <4EF67721.9050102@unixsol.org> <4EF6DD91.2030800@iki.fi> <4EF6F84C.3000307@redhat.com> <CAF0Ff2kkFJYLUjVdmV9d9aWTsi-2ZHHEEjLrVSTCUnP+VTyxRg@mail.gmail.com> <4EF7066C.4070806@redhat.com> <loom.20111227T105753-96@post.gmane.org>
In-Reply-To: <loom.20111227T105753-96@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christian,

Em 27-12-2011 08:12, Christian Prähauser escreveu:
>>
>> Yes, I'm meaning something like what it was described there. I think
>> that the code written by Christian were never submitted upstream.
>>
> 
> Hello Mauro,
> 
> Konstantin drew my attention to this discussion. Indeed, some time ago I wrote 
> a base-band demux for LinuxDVB. It was part of a project to integrate support 
> for second-generation IP/DVB encapsulations (GSE). The BB-demux allows to
> register filters for different ISIs and data types (raw, generic stream,
> transport stream).
> 
> I realized that the repo hosted at our University is down. If there is interest,
> I can update my patches to the latest LinuxDVB version and we can put them on a 
> public repo e.g. at linuxdvb.org.

Sorry, I didn't notice your comment on this thread until today. It sounds
interesting. Please post the patches at the ML, when they're available, for
us to review.

Thanks!
Mauro
> 
> Kind regards,
> Christian.
>  
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

