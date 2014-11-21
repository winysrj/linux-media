Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41831 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaKUUDz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 15:03:55 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so368599wiv.8
        for <linux-media@vger.kernel.org>; Fri, 21 Nov 2014 12:03:54 -0800 (PST)
Received: from gjasny01.ad.corp.expertcity.com ([95.91.248.53])
        by mx.google.com with ESMTPSA id ud1sm9403042wjc.7.2014.11.21.12.03.53
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Nov 2014 12:03:54 -0800 (PST)
Message-ID: <546F9AA9.40500@googlemail.com>
Date: Fri, 21 Nov 2014 21:03:53 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: v4l-utils stable release 1.6.2
References: <546E093D.4030203@googlemail.com>
In-Reply-To: <546E093D.4030203@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just released v4l-utils 1.6.1 and 1.6.2 with these changes:

> v4l-utils-1.6.2
> ---------------
> 
> Hans Verkuil (5):
>       v4l2-ctl: fix sliced vbi mode parsing
>       v4l2-compliance: when streaming used at least 2 buffers.
>       v4l2-compliance: add initial checks for VIDIOC_QUERY_EXT_CTRL
>       v4l2-ctl: add support for U32 control type.
>       v4l2-ctl: fix array handling
> 
> 
> v4l-utils-1.6.1
> ---------------
> 
> Gregor Jasny (5):
>       man: remove duplicate backslash from NAME section
>       man: Use Unicode character for ellipsis and fall back to ...
>       man: add generated files to .gitignore
>       v4l2-compliance: Explicitely link against rt library
>       v4l2-ctl: Explicitely link against rt library
> 
> Hans Verkuil (1):
>       qv4l2/v4l2-ctl: fix buffer overrun in vivid-tpg.
> 
> Hans de Goede (2):
>       rc_keymaps: allwinner: S/KEY_HOME/KEY_HOMEPAGE/
>       v4lconvert: Fix decoding of jpeg data with no vertical sub-sampling
> 
> Mauro Carvalho Chehab (4):
>       libdvbv5: properly represent Satellite frequencies
>       README: better document the package
>       ir-keytable: fix a regression introduced by fe2aa5f767eba
>       rc: Update the protocol name at RC6 tables
> 
> Niels Ole Salscheider (1):
>       qv4l2: Fix out-of-source build

Thanks,
Gregor
