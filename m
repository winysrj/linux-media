Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46870 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaEETaf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 May 2014 15:30:35 -0400
Received: by mail-qa0-f46.google.com with SMTP id w8so7496131qac.19
        for <linux-media@vger.kernel.org>; Mon, 05 May 2014 12:30:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140505192633.GQ11231@htj.dyndns.org>
References: <cover.1398797954.git.shuah.kh@samsung.com>
	<6cb20ce23f540c883e60e6ce71302042b034c4aa.1398797955.git.shuah.kh@samsung.com>
	<20140501145337.GC31611@htj.dyndns.org>
	<5367E39E.7090401@samsung.com>
	<20140505192633.GQ11231@htj.dyndns.org>
Date: Mon, 5 May 2014 15:30:34 -0400
Message-ID: <CAGoCfiwoFipx79tx6Jkgx5nfU_K9qXdfGe25kzrNb6Jwka0H7A@mail.gmail.com>
Subject: Re: [PATCH 1/4] drivers/base: add managed token devres interfaces
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Tejun Heo <tj@kernel.org>
Cc: Shuah Khan <shuah.kh@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	olebowle@gmx.com, Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tejun,

On Mon, May 5, 2014 at 3:26 PM, Tejun Heo <tj@kernel.org> wrote:
> As such, please consider the patches nacked and try to find someone
> who can shepherd the code.  Mauro, can you help out here?

We actually discussed this proposal at length at the media summit last
week.  The patches are being pulled pending further internal review
and after Shuah has exercised some other use cases.

Regards,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
