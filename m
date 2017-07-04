Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:36652 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbdGDFok (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Jul 2017 01:44:40 -0400
Received: by mail-wr0-f182.google.com with SMTP id c11so243241143wrc.3
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 22:44:39 -0700 (PDT)
Date: Tue, 4 Jul 2017 07:44:34 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, rjkm@metzlerbros.de, jasmin@anw.at
Subject: Re: [PATCH v2 01/10] [media] dvb-frontends: add ST STV0910 DVB-S/S2
 demodulator frontend driver
Message-ID: <20170704074434.690e3070@audiostation.wuest.de>
In-Reply-To: <201707040532.u5fUKFTH%fengguang.wu@intel.com>
References: <20170630205106.1268-2-d.scheller.oss@gmail.com>
        <201707040532.u5fUKFTH%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Tue, 4 Jul 2017 06:01:32 +0800
schrieb kbuild test robot <lkp@intel.com>:

> All errors (new ones prefixed by >>):
> 
>    drivers/media/dvb-frontends/stv0910.c: In function
> 'read_signal_strength':
> >> drivers/media/dvb-frontends/stv0910.c:1284: error: 'p' undeclared
> >> (first use in this function)  
>    drivers/media/dvb-frontends/stv0910.c:1284: error: (Each
> undeclared identifier is reported only once
> drivers/media/dvb-frontends/stv0910.c:1284: error: for each function
> it appears in.)

Fixed in v3 (by "Add required fe.dtv_propcache vars/references to the
dummy STR function, fixes bisect" in v3-1/10).

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
