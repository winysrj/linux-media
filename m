Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34970 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbbJCOwV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2015 10:52:21 -0400
Received: by pacfv12 with SMTP id fv12so135756064pac.2
        for <linux-media@vger.kernel.org>; Sat, 03 Oct 2015 07:52:21 -0700 (PDT)
Subject: Re: [PATCH V2 1/2] rc-core: define a default timeout for drivers
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1441980024-1944-1-git-send-email-eric@nelint.com>
 <1442862524-3694-1-git-send-email-eric@nelint.com>
 <1442862524-3694-2-git-send-email-eric@nelint.com>
 <20151003112510.54fe2a25@recife.lan>
Cc: linux-media@vger.kernel.org, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	patrice.chotard@st.com, fabf@skynet.be, wsa@the-dreams.de,
	heiko@sntech.de, devicetree@vger.kernel.org,
	otavio@ossystems.com.br
From: Eric Nelson <eric@nelint.com>
Message-ID: <560FEBA2.6040504@nelint.com>
Date: Sat, 3 Oct 2015 07:52:18 -0700
MIME-Version: 1.0
In-Reply-To: <20151003112510.54fe2a25@recife.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Mauro,

On 10/03/2015 07:25 AM, Mauro Carvalho Chehab wrote:
> Em Mon, 21 Sep 2015 12:08:43 -0700
> Eric Nelson <eric@nelint.com> escreveu:
> 
>> A default timeout value of 100ms is workable for most decoders.
>> Declare a constant to help standardize its' use.
> 
> I guess the worse case scenario is the NEC protocol:
> 	http://www.sbprojects.com/knowledge/ir/nec.php
> 
> with allows a repeat message to be sent on every 110ms. As the
> repeat message is 11.25 ms, that would mean a maximum time without
> data for 98.75 ms. So, in thesis, 100 ms would be ok. However, IR
> timings are not always precise and may affected by the battery charge.
> 
> So, I think that a timeout of 100ms is too close to 98.75 and may
> cause troubles.
> 
> S, IMHO, it is safer to define the default timeout as 125ms.
> 

Sounds good. I'll submit V3 shortly.

