Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:47812 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab3GBSEz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jul 2013 14:04:55 -0400
Received: by mail-ea0-f177.google.com with SMTP id j14so2890532eak.8
        for <linux-media@vger.kernel.org>; Tue, 02 Jul 2013 11:04:54 -0700 (PDT)
Received: from myon.exnihilo (51-213.60-188.cust.bluewin.ch. [188.60.213.51])
        by mx.google.com with ESMTPSA id n42sm38045445eeh.15.2013.07.02.11.04.52
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Tue, 02 Jul 2013 11:04:53 -0700 (PDT)
Date: Tue, 2 Jul 2013 20:04:49 +0200
From: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 0/6] v4l-utils: v4l-utils: Fix satellite support in
 dvbv5-{scan,zap} tools
Message-ID: <20130702200449.28365ea4@myon.exnihilo>
In-Reply-To: <cover.1371561676.git.gmsoft@tuxicoman.be>
References: <cover.1371561676.git.gmsoft@tuxicoman.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Acked-by: André Roth <neolynx@gmail.com>


On Tue, 18 Jun 2013 16:19:03 +0200
Guy Martin <gmsoft@tuxicoman.be> wrote:
> Hi all,
> 
> This set of patch fix sat support for dvbv5 libs and utils.
> In this set, a different approach is used. The polarization parameter is stored in
> the DTV_POLARIZATION property.
> 
>   Guy
> 
> Guy Martin (6):
>   libdvbv5: Remove buggy parsing of extra DTV_foo parameters
>   libdvbv5: Add parsing of POLARIZATION
>   libdvbv5: Export dvb_fe_is_satellite()
>   libdvbv5: Fix satellite handling and apply polarization parameter to
>     the frontend
>   libdvbv5: Use a temporary copy of the dvb parameters when tuning
>   dvbv5-zap: Parse the LNB from the channel file
> 
>  lib/include/dvb-fe.h      |  2 +-
>  lib/include/dvb-file.h    |  1 -
>  lib/include/dvb-sat.h     |  1 -
>  lib/libdvbv5/dvb-fe.c     | 79 ++++++++++++++++++-----------------------
>  lib/libdvbv5/dvb-file.c   | 90 +++++++++++++++--------------------------------
>  lib/libdvbv5/dvb-sat.c    | 68 +++++++++++++----------------------
>  lib/libdvbv5/dvb-v5-std.c |  9 ++---
>  utils/dvb/dvbv5-zap.c     |  9 +++++
>  8 files changed, 100 insertions(+), 159 deletions(-)
> 
