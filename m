Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab2E1OJq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 10:09:46 -0400
Message-ID: <4FC38722.2020502@redhat.com>
Date: Mon, 28 May 2012 11:09:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] [media] firedtv: Port it to use rc_core
References: <1338210875-4620-1-git-send-email-mchehab@redhat.com> <1338210875-4620-2-git-send-email-mchehab@redhat.com> <20120528160132.2041d761@stein>
In-Reply-To: <20120528160132.2041d761@stein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-05-2012 11:01, Stefan Richter escreveu:
> On May 28 Mauro Carvalho Chehab wrote:
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>  drivers/media/dvb/firewire/firedtv-rc.c |  152 ++-----------------------------
>>  drivers/media/dvb/firewire/firedtv.h    |    2 +-
>>  2 files changed, 11 insertions(+), 143 deletions(-)
> 
> Also in drivers/media/dvb/firewire/Kconfig, INPUT needs to be replaced by
> RC_CORE, right?

Yes.

(sorry, I missed that one on the previous email ;) )

Regards,
Mauro
