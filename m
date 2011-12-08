Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab1LHKEi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Dec 2011 05:04:38 -0500
Message-ID: <4EE08BB1.4090408@redhat.com>
Date: Thu, 08 Dec 2011 08:04:33 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Christoph Pfister <christophpfister@gmail.com>
CC: gennarone@gmail.com, linux-media list <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/1] xc3028: force reload of DTV7 firmware in VHF band
 with Zarlink demodulator
References: <4EDE27A0.8060406@gmail.com> <4EDF6640.801@redhat.com> <4EDF6E7E.30200@gmail.com> <4EDF762A.9030604@redhat.com> <4EDF7DF3.1080007@gmail.com> <4EDF80AF.5060709@redhat.com> <4EDF8A22.6020201@gmail.com> <4EDF8B68.1040009@gmail.com> <4EDF9291.2030703@redhat.com> <4EDFA19E.7090608@gmail.com> <4EDFB746.8010309@redhat.com> <CAL7owaDDDUx=rAw+7YRLVvw8LF6WWLhtoXOaXy-hGXJD8TWDTQ@mail.gmail.com>
In-Reply-To: <CAL7owaDDDUx=rAw+7YRLVvw8LF6WWLhtoXOaXy-hGXJD8TWDTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christoph,

On 07-12-2011 19:54, Christoph Pfister wrote:
> 2011/12/7 Mauro Carvalho Chehab<mchehab@redhat.com>:
> <snip>
>> Several channels in Italy are marked as if they are using 8MHz for VHF (the
>> auto-Italy is
>> the most weird one, as it defines all VHF frequencies with both 7MHz and
>> 8MHz).
>
> Well, auto-Italy is a superset of the it-* files. For example "T
> 177500000 7MHz" exists in some files (Modena, Montevergina) and "T
> 177500000 8MHz" in others (Sassari), so both possibilities have to
> appear in auto-Italy (similar for other VHF frequencies, it simply
> doesn't seem to be regulated). There's nothing to fix there,
> auto-Italy exists exactly because of these irregularities.

I see. From Gianluca's email and from w_scan code, I understood that
8 MHz on VHF in Italy is not used there anymore.

If there are places there using 8 MHz, then w_scan requires a fix.

Regards,
Mauro
