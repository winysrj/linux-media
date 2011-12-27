Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:53412 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1L0Wgy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 17:36:54 -0500
Message-ID: <4EFA4881.9050906@infradead.org>
Date: Tue, 27 Dec 2011 20:36:49 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 03/91] [media] dvb-core: add support for a DVBv5 get_frontend()
 callback
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com> <1324948159-23709-2-git-send-email-mchehab@redhat.com> <1324948159-23709-3-git-send-email-mchehab@redhat.com> <1324948159-23709-4-git-send-email-mchehab@redhat.com> <4EF9B860.4000103@linuxtv.org> <4EF9CD07.6080608@infradead.org> <4EF9DA66.1070409@linuxtv.org> <4EF9FFC2.30705@infradead.org> <4EFA2EC4.6020901@linuxtv.org>
In-Reply-To: <4EFA2EC4.6020901@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27-12-2011 18:47, Andreas Oberritter wrote:
> On 27.12.2011 18:26, Mauro Carvalho Chehab wrote:
>> One usage of such call would be to retrieve the autodetected properties,
>> after having a frontend lock.
> 
> Btw., dvb_frontend already refreshes the cache whenever the lock status
> changes, i.e. when generating frontend events.

True. Well, if all agree, we can add a patch after this series removing
the extra parameter from get_frontend(), making it symmetric to the set
calls.

(I prefer to code it as a separate patch, as changing the entire chain of
about 80 patches is very painful. Also, a simple perl script is probably
enough to do the trick of changing all at once).

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

