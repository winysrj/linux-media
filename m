Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:64703 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbZLPNKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2009 08:10:04 -0500
Received: by fxm21 with SMTP id 21so859539fxm.21
        for <linux-media@vger.kernel.org>; Wed, 16 Dec 2009 05:10:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <624893.42863.qm@web23203.mail.ird.yahoo.com>
References: <624893.42863.qm@web23203.mail.ird.yahoo.com>
Date: Wed, 16 Dec 2009 17:10:02 +0400
Message-ID: <1a297b360912160510x5e8f1094se95560e6584e0337@mail.gmail.com>
Subject: Re: Anyone capable of fixing inverted spectrum issue on tt s2-3200?
From: Manu Abraham <abraham.manu@gmail.com>
To: Newsy Paper <newspaperman_germany@yahoo.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 16, 2009 at 4:15 PM, Newsy Paper
<newspaperman_germany@yahoo.com> wrote:
> Hi,
>
> as the problem with the ORF HD transponder on Astra is now figured out and ORF switched inversion off again, we know know where the bug in the driver is. I don't know if the problem also occours on dvb-s(1) transponders but I'll try to figure that out.
>
> Is anyone able to fix that dvb-s2 problem? Perhaps it would also solve the problem with some transponders on 1° west?
>


To verify whether an inversion will solve the issue:

Please try changing

line: #1313 .inversion = IQ_SWAP_ON, /* 1 */  to IQ_SWAP_OFF

in

http://linuxtv.org/hg/v4l-dvb/file/79fc32bba0a0/linux/drivers/media/dvb/ttpci/budget-ci.c

and check whether that solves your inversion issue. Please report your findings.


Regards,
Manu
