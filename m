Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:53451 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab1L0WnH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 17:43:07 -0500
Message-ID: <4EFA49F4.9050608@infradead.org>
Date: Tue, 27 Dec 2011 20:43:00 -0200
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

Btw, the event ioctl is DVBv3 only. It probably makes sense to add one DTV
command to implement it.

In a matter of fact, IMO, the better is to implement a set of DTV read status
commands, plus one command for event.

This way, a status call could return the events that are specific for each
delivery system, instead of returning something that will require the userspace
to do a FE_GET_PROPERTY call, in order to get the real parameters for the
newer delivery systems.

The current status API has some limits for some new delivery systems.
For example, on ISDB-T, devices can produce both consolidated and
per-layer status.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

