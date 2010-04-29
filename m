Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57442 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696Ab0D3S5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Apr 2010 14:57:00 -0400
Received: by bwz19 with SMTP id 19so316618bwz.21
        for <linux-media@vger.kernel.org>; Fri, 30 Apr 2010 11:56:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x2h94764e701004100814k2fa8b3fcq29868b73da1fc36c@mail.gmail.com>
References: <y2p94764e701004091616x59467e3qc4efc2580dad53d@mail.gmail.com>
	 <1270857748.8003.7.camel@pc07.localdom.local>
	 <x2h94764e701004100814k2fa8b3fcq29868b73da1fc36c@mail.gmail.com>
Date: Thu, 29 Apr 2010 19:25:39 +0200
Message-ID: <m2z19a3b7a81004291025h3396cff8z498fdfcc065209bb@mail.gmail.com>
Subject: Re: [PATCH] DVB-T initial scan file for Israel (dvb-utils)
From: Christoph Pfister <christophpfister@gmail.com>
To: Shaul Kremer <shaulkr@gmail.com>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/4/10 Shaul Kremer <shaulkr@gmail.com>:
<snip>
> Sounds good. Here:
>
> # HG changeset patch
> # User Shaul Kremer <shaulkr@gmail.com>
> # Date 1270911802 -10800
> # Node ID 9c2dabea9d1b63a75593b920d41159e7ba607747
> # Parent  7de0663facd92bbb9049aeeda3dcba9601228f30
> Added DVB-T initial tuning tables for Israel.
>
> diff -r 7de0663facd9 -r 9c2dabea9d1b util/scan/dvb-t/il-All
> --- /dev/null   Thu Jan 01 00:00:00 1970 +0000
> +++ b/util/scan/dvb-t/il-All    Sat Apr 10 18:03:22 2010 +0300
> @@ -0,0 +1,5 @@
> +# Israel, Israel Broadcasting Authority's transmitters
> +# Generated from list in http://www.iba.org.il/reception/
> +# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> +T 514000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
> +T 538000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE

Applied, thanks (for the next time: please attach patch instead of inlining it).

Christoph
