Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44052 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932730AbeEaQ6w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 12:58:52 -0400
Subject: Re: linux-next: Tree for May 31 (media/radio/radio-aimslab.c)
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20180531194010.1177687e@canb.auug.org.au>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <30d330b7-e09e-9e4c-174d-7bc81e553d91@infradead.org>
Date: Thu, 31 May 2018 09:58:42 -0700
MIME-Version: 1.0
In-Reply-To: <20180531194010.1177687e@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/31/2018 02:40 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20180530:
> 

on i386:
when CONFIG_RADIO_ISA=m but CONFIG_RADIO_RTRACK=y (for radio-aimslab.c)

drivers/media/radio/radio-aimslab.o:(.data+0x0): undefined reference to `radio_isa_match'
drivers/media/radio/radio-aimslab.o:(.data+0x4): undefined reference to `radio_isa_probe'
drivers/media/radio/radio-aimslab.o:(.data+0x8): undefined reference to `radio_isa_remove'


I was going to add a "select RADIO_ISA" for RADIO_RTRACK, but it looks like
that line was just removed/deleted in linux-next.  What's going on?

-- 
~Randy
