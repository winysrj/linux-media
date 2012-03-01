Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686Ab2CAKMr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Mar 2012 05:12:47 -0500
Message-ID: <4F4F4B9B.7090705@redhat.com>
Date: Thu, 01 Mar 2012 07:12:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Eddi De Pieri <eddi@depieri.net>
CC: linux-media@vger.kernel.org
Subject: Re: possible bug in http://git.linuxtv.org/mchehab/experimental-v4l-utils.git
References: <CAKdnbx4Vhj5ZoArOssETJQFbM0YxSfSoU62ybSK3J+cMX9irSA@mail.gmail.com>
In-Reply-To: <CAKdnbx4Vhj5ZoArOssETJQFbM0YxSfSoU62ybSK3J+cMX9irSA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Eddi,

Em 05-02-2012 09:53, Eddi De Pieri escreveu:
> Hi mauro,
> 
> I suspect a bug in follow code:
> 
>                 for (bw = 0; fe_bandwidth_name[bw] != 0; bw++) {
>                         if (fe_bandwidth_name[bw] == v3_parms.u.ofdm.bandwidth)
>                                 break;
>                 }
>                 dvb_fe_retrieve_parm(parms, DTV_BANDWIDTH_HZ, &bw);
> 
> I think should be something like:
> 
>                 int bw_idx;
> 
>                 dvb_fe_retrieve_parm(parms, DTV_BANDWIDTH_HZ, &bw);
> 
>                 for (bw_idx = 0; fe_bandwidth_name[bw_idx] != 0; bw_idx++) {
>                         if (fe_bandwidth_name[bw_idx] == bw) {
>                                 v3_parms.u.ofdm.bandwidth = bw;
>                                 break;
>                         }
>                 }
> 
> regards,

I've aplied the dvb code at the main v4l-utils tree some time ago. Since then,
I'm applying the fixes directly there. So, please check if the issue you're pointing
weren't fix yet there. If not, please send me a patch.

Thanks!
Mauro
