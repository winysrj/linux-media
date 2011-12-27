Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:57923 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab1L0UrD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 15:47:03 -0500
Message-ID: <4EFA2EC4.6020901@linuxtv.org>
Date: Tue, 27 Dec 2011 21:47:00 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 03/91] [media] dvb-core: add support for a DVBv5 get_frontend()
 callback
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com> <1324948159-23709-2-git-send-email-mchehab@redhat.com> <1324948159-23709-3-git-send-email-mchehab@redhat.com> <1324948159-23709-4-git-send-email-mchehab@redhat.com> <4EF9B860.4000103@linuxtv.org> <4EF9CD07.6080608@infradead.org> <4EF9DA66.1070409@linuxtv.org> <4EF9FFC2.30705@infradead.org>
In-Reply-To: <4EF9FFC2.30705@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27.12.2011 18:26, Mauro Carvalho Chehab wrote:
> One usage of such call would be to retrieve the autodetected properties,
> after having a frontend lock.

Btw., dvb_frontend already refreshes the cache whenever the lock status
changes, i.e. when generating frontend events.
