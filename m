Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757319Ab2BNVzY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 16:55:24 -0500
Message-ID: <4F3AD84B.1030800@redhat.com>
Date: Tue, 14 Feb 2012 16:55:23 -0500
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: W R <gridmuncher@hotmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Fintek driver linux
References: <BLU145-W35C32BF2C2E1EDFD8DC5F4BD800@phx.gbl>,<4F2822AE.1020705@redhat.com>,<BLU145-W31A99136480C1FBA4E0AC7BD770@phx.gbl>,<4F356866.6090208@redhat.com> <BLU145-W1658A220E336DBC96C53D7BD7C0@phx.gbl>,<4F3ABF41.9060800@redhat.com> <BLU145-W31DB93CC932394E4E288E2BD7C0@phx.gbl>
In-Reply-To: <BLU145-W31DB93CC932394E4E288E2BD7C0@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/14/2012 04:25 PM, W R wrote:
> Thanks for your quick reply. It does seem like I have the old version:
>
> cat /proc/bus/input/devices
>
> *I: Bus=0019 Vendor=1934 Product=0004 Version=0008*

Hm, okay, so the changes for newer hardware shouldn't matter at all.

> N: Name="Fintek LPC SuperIO Consumer IR Transceiver"
> P: Phys=fintek/cir0
...
> Is there anything out of the ordinary? Any way to find out which modules
> that cause the problem and can maybe be removed?

Nothing out of the ordinary, no. You'd have to capture serial console 
output or a vmcore from the time of the crash to really get a better 
idea of where its falling down. The panic trace ought to give a clue 
where to start looking.

I can't recall, have you tried using this under Windows, and if so, was 
it stable there? A hardware fault is always a possibility, especially 
when there's only a single report of something like this. Then again, 
this is a fairly young driver. But I never saw anything like this in my 
own testing during driver devel, nor did Fintek. :\

-- 
Jarod Wilson
jarod@redhat.com
