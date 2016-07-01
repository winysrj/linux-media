Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:36549 "EHLO
	mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbcGAPmO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2016 11:42:14 -0400
Received: by mail-qt0-f174.google.com with SMTP id w59so59605587qtd.3
        for <linux-media@vger.kernel.org>; Fri, 01 Jul 2016 08:42:14 -0700 (PDT)
Date: Fri, 1 Jul 2016 12:42:04 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Federico Vaga <federico.vaga@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCHv5 05/13] media/pci: convert drivers to use the new
 vb2_queue dev field
Message-ID: <20160701154139.GA1989@laptop>
References: <1467034324-37626-1-git-send-email-hverkuil@xs4all.nl>
 <1467034324-37626-6-git-send-email-hverkuil@xs4all.nl>
 <eb8277fd-c462-3eff-8ada-5319f3b5057b@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb8277fd-c462-3eff-8ada-5319f3b5057b@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01 Jul 11:55 AM, Hans Verkuil wrote:
> From 62ddd1aabe5672541055bc6de3c80ca1e3635729 Mon Sep 17 00:00:00 2001
> From: Hans Verkuil <hans.verkuil@cisco.com>
> Date: Mon, 15 Feb 2016 15:37:15 +0100
> Subject: [PATCH 05/13] media/pci: convert drivers to use the new vb2_queue dev
>  field
> 
> Stop using alloc_ctx and just fill in the device pointer.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Federico Vaga <federico.vaga@gmail.com>
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
> After rebasing the vb2: replace allocation context by device pointer patch series I discovered
> that newly committed changes to tw686x required that driver to be updated as well.
> This is the patch for that.

Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>

Thanks for the cleanup,
-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
