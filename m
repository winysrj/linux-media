Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61640 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbaHLNYi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 09:24:38 -0400
Received: by mail-qc0-f174.google.com with SMTP id l6so2776006qcy.19
        for <linux-media@vger.kernel.org>; Tue, 12 Aug 2014 06:24:37 -0700 (PDT)
Message-ID: <53EA1591.4000108@gmail.com>
Date: Tue, 12 Aug 2014 15:24:33 +0200
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: Mihail Tommonen <patapovich@gmail.com>,
	linux-sunxi@googlegroups.com
CC: anuroop.kamu@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v4 2/2] [stage/sunxi-3.4] Add support for Allwinner (DVB/ATSC)
 Transport Stream Controller(s) (TSC)
References: <520BC1EF.9030204@gmail.com> <ed81b21e-44e4-40db-bfaa-6fbad2b5d7cb@googlegroups.com> <53E9C88B.7050400@gmail.com> <729740fb-4a6f-4a7e-a151-dd12d2d8d944@googlegroups.com>
In-Reply-To: <729740fb-4a6f-4a7e-a151-dd12d2d8d944@googlegroups.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 12.08.2014 um 14:21 schrieb Mihail Tommonen:>
> Hi,
>
> 2. I've suspended my TSC project until a complete A20 TSC manual is
>> available or I get the time for register probe rev. engineering.
>>
>
> Have you seen this:
> http://dl.linux-sunxi.org/A10/A10%20Transport%20Stream%20Controller%20V1.00%2020120917.pdf
> I expect a20 tsc to be really similiart to a10.

Incomplete. Prove me wrong by getting a full TS without bypassing the TSC using the GPIO ports in other MUX mode directly, if possible (sig speed).

>
> WBR
>
> Miska
>

y
tom
