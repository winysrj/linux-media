Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:38854 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaIXXCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 19:02:21 -0400
Received: by mail-la0-f51.google.com with SMTP id pv20so2032048lab.10
        for <linux-media@vger.kernel.org>; Wed, 24 Sep 2014 16:02:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ed21f64844bd63573466c2667fd035f9e650a5f9.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
	<ed21f64844bd63573466c2667fd035f9e650a5f9.1411597610.git.mchehab@osg.samsung.com>
Date: Wed, 24 Sep 2014 20:02:19 -0300
Message-ID: <CAOMZO5CoaX05r50p+Ug++napxZEoL_+CR8-T7tN6wtiSRfT1pw@mail.gmail.com>
Subject: Re: [PATCH 15/18] [media] s5p_mfc_opr: Fix warnings
From: Fabio Estevam <festevam@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jeongtae Park <jtp.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Sep 24, 2014 at 7:27 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:


> drivers/media//platform/s5p-mfc/s5p_mfc_opr.c:44:2: warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘size_t’ [-Wformat=]

...

> -       mfc_debug(3, "Allocating priv: %d\n", b->size);
> +       mfc_debug(3, "Allocating priv: %zd\n", b->size);

This should be %zu instead.
