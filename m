Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:56389 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbZA1KJS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 05:09:18 -0500
Received: by rv-out-0506.google.com with SMTP id k40so6877269rvb.1
        for <linux-media@vger.kernel.org>; Wed, 28 Jan 2009 02:09:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <497F7117.9000607@dark-green.com>
References: <497F7117.9000607@dark-green.com>
Date: Wed, 28 Jan 2009 12:09:17 +0200
Message-ID: <b1dab3a10901280209w291507b2lfdba81b60cb16e36@mail.gmail.com>
Subject: Re: [linux-dvb] Broken Tuning on Wintv Nova HD S2
From: n37 <n37lkml@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I also can confirm this. Reverting to a previous revision restores
proper tuning to vertical transponders.

On Tue, Jan 27, 2009 at 10:39 PM, gimli <gimli@dark-green.com> wrote:
> Hi,
>
> the following changesets breaks Tuning to Vertical Transponders :
>
> http://mercurial.intuxication.org/hg/s2-liplianin/rev/1ca67881d96a
> http://linuxtv.org/hg/v4l-dvb/rev/2cd7efb4cc19
>
> For example :
>
> DMAX;BetaDigital:12246:vC34M2O0S0:S19.2E:27500:511:512=deu:32:0:10101:1:1092:0
>
>
> cu
>
> Edgar ( gimli ) Hucek
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
