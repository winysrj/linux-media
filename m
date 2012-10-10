Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65159 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab2JJGwa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 02:52:30 -0400
Received: by mail-wi0-f178.google.com with SMTP id hr7so251077wib.1
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2012 23:52:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121010034342.GA3215@mtj.dyndns.org>
References: <1349840009-14014-1-git-send-email-festevam@gmail.com>
	<20121010034342.GA3215@mtj.dyndns.org>
Date: Wed, 10 Oct 2012 08:52:29 +0200
Message-ID: <CACKLOr2hLFjFDhYKa6pjK7XmgZUF7RtNzb6E_9g_7XAyFa6d5w@mail.gmail.com>
Subject: Re: [PATCH] [media] coda: Do not use __cancel_delayed_work()
From: javier Martin <javier.martin@vista-silicon.com>
To: Tejun Heo <tj@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>, mchehab@infradead.org,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10 October 2012 05:43, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Oct 10, 2012 at 12:33:29AM -0300, Fabio Estevam wrote:
>> From: Fabio Estevam <fabio.estevam@freescale.com>
>>
>> commit 136b5721d (workqueue: deprecate __cancel_delayed_work()) made
>> __cancel_delayed_work deprecated. Use cancel_delayed_work instead and get rid of
>> the following warning:
>>
>> drivers/media/platform/coda.c:1543: warning: '__cancel_delayed_work' is deprecated (declared at include/linux/workqueue.h:437)
>>
>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>
> Acked-by: Tejun Heo <tj@kernel.org>
>
> Thanks!
>
> --
> tejun

Thanks Fabio.

Acked-by: Javier Martin <javier.martin@vista-silicon.com>


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
