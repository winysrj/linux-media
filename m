Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:36340 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531Ab0DJACo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 20:02:44 -0400
Subject: Re: [PATCH] DVB-T initial scan file for Israel (dvb-utils)
From: hermann pitton <hermann-pitton@arcor.de>
To: Shaul Kremer <shaulkr@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <y2p94764e701004091616x59467e3qc4efc2580dad53d@mail.gmail.com>
References: <y2p94764e701004091616x59467e3qc4efc2580dad53d@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 10 Apr 2010 02:02:28 +0200
Message-Id: <1270857748.8003.7.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaul,

Am Samstag, den 10.04.2010, 02:16 +0300 schrieb Shaul Kremer:
> Hi,
> 
> Here is an initial scan file for IBA's DVB-T transmitters.
> 
> Generated from info at http://www.iba.org.il/reception/ (Hebrew)
> 
> # HG changeset patch
> # User Shaul Kremer <shaulkr@gmail.com>
> # Date 1270854557 -10800
> # Node ID ac84f6db6f031db82509c247ac1775ca48b0e2f3
> # Parent  7de0663facd92bbb9049aeeda3dcba9601228f30
> Added DVB-T initial tuning tables for Israel.
> 
> diff -r 7de0663facd9 -r ac84f6db6f03 util/scan/dvb-t/il-SFN1
> --- /dev/null   Thu Jan 01 00:00:00 1970 +0000
> +++ b/util/scan/dvb-t/il-SFN1   Sat Apr 10 02:09:17 2010 +0300
> @@ -0,0 +1,4 @@
> +# Israel, Israel Broadcasting Authority's SFN-1 transmitter (northern Israel)
> +# Generated from list in http://www.iba.org.il/reception/
> +# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> +T 538000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
> diff -r 7de0663facd9 -r ac84f6db6f03 util/scan/dvb-t/il-SFN2
> --- /dev/null   Thu Jan 01 00:00:00 1970 +0000
> +++ b/util/scan/dvb-t/il-SFN2   Sat Apr 10 02:09:17 2010 +0300
> @@ -0,0 +1,4 @@
> +# Israel, Israel Broadcasting Authority's SFN-2 transmitter (central Israel)
> +# Generated from list in http://www.iba.org.il/reception/
> +# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> +T 514000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE
> diff -r 7de0663facd9 -r ac84f6db6f03 util/scan/dvb-t/il-SFN3
> --- /dev/null   Thu Jan 01 00:00:00 1970 +0000
> +++ b/util/scan/dvb-t/il-SFN3   Sat Apr 10 02:09:17 2010 +0300
> @@ -0,0 +1,4 @@
> +# Israel, Israel Broadcasting Authority's SFN-3 transmitter (southern Israel)
> +# Generated from list in http://www.iba.org.il/reception/
> +# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> +T 538000000 8MHz 2/3 NONE QAM16 8k 1/4 NONE

why you don't put them into one scan file for now?

"scan" for sure does not know about any difference between northern and
southern Israel from the above and to scan the central transponder too
in one run might cost in worst case a few seconds.

Cheers,
Hermann


