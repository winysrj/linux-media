Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37765 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab2CAUjf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Mar 2012 15:39:35 -0500
Received: by wibhm2 with SMTP id hm2so195599wib.19
        for <linux-media@vger.kernel.org>; Thu, 01 Mar 2012 12:39:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKdnbx6P=MhCV+aoUxeFEdWCseeJSfAd2UgjhZJHjRNA7NtGog@mail.gmail.com>
References: <CAKdnbx4Vhj5ZoArOssETJQFbM0YxSfSoU62ybSK3J+cMX9irSA@mail.gmail.com>
 <4F4F4B9B.7090705@redhat.com> <CAKdnbx6P=MhCV+aoUxeFEdWCseeJSfAd2UgjhZJHjRNA7NtGog@mail.gmail.com>
From: Eddi De Pieri <eddi@depieri.net>
Date: Thu, 1 Mar 2012 21:39:14 +0100
Message-ID: <CAKdnbx50bPzgF5o5a_N-WtmnQJWiv-NmEPq7ajjUn==g06rcWg@mail.gmail.com>
Subject: Re: possible bug in http://git.linuxtv.org/mchehab/experimental-v4l-utils.git
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

> I've aplied the dvb code at the main v4l-utils tree some time ago. Since then,
> I'm applying the fixes directly there. So, please check if the issue you're pointing
> weren't fix yet there. If not, please send me a patch.

The code is still unchanged.

I prefere you double check my suggested patch below since I don't
fully understand your code.

However sound strange to me that you compute "bw" value and then you
overwrite it.


> I suspect a bug in follow code:
>
>                 for (bw = 0; fe_bandwidth_name[bw] != 0; bw++) {
>                         if (fe_bandwidth_name[bw] == v3_parms.u.ofdm.bandwidth)
>                                 break;
>                 }
>                 dvb_fe_retrieve_parm(parms, DTV_BANDWIDTH_HZ, &bw);
>
> I think should be something like:
>
>                 int bw_idx;
>
>                 dvb_fe_retrieve_parm(parms, DTV_BANDWIDTH_HZ, &bw);
>
>                 for (bw_idx = 0; fe_bandwidth_name[bw_idx] != 0; bw_idx++) {
>                         if (fe_bandwidth_name[bw_idx] == bw) {
>                                 v3_parms.u.ofdm.bandwidth = bw;
>                                 break;
>                         }
>                 }

Regards,
Eddi
