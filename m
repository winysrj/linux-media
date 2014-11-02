Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54256 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaKBJw5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 04:52:57 -0500
Received: by mail-pa0-f50.google.com with SMTP id eu11so10304634pac.23
        for <linux-media@vger.kernel.org>; Sun, 02 Nov 2014 01:52:56 -0800 (PST)
Message-ID: <5455FEF4.6010803@gmail.com>
Date: Sun, 02 Nov 2014 18:52:52 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/7] v4l-utils/libdvbv5: add support for ISDB-S scanning
References: <1414323983-15996-1-git-send-email-tskd08@gmail.com> <1414323983-15996-4-git-send-email-tskd08@gmail.com> <20141027124650.522d394b.m.chehab@samsung.com> <54539EC6.8090001@gmail.com> <20141031175353.4b1dec17.m.chehab@samsung.com>
In-Reply-To: <20141031175353.4b1dec17.m.chehab@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Hmm... Is this due to a spec definition, or is it just how satellite
> operators decided?
> 
> If ARIB spec doesn't allow polarization set, we should remove it from the
> Kernel DocBook. 

ARIB spec does NOT limit polarization, just the satellite operators do.

> 
> Btw, how does the PT1 driver handle those parameters? If it just uses
> frequency (it seems so), then the only valid parameters for ISDB-S are
> 	DTV_FREQUENCY
> and
> 	DTV_STREAM_ID
> 
> (and, eventually, polarization, if ARIB spec allows it)
> 
> right?

Yes, right. PT1 uses DTV_FREQUENCY and DTV_STREAM_ID.
--
Akihiro
