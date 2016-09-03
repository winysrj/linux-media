Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36444 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753239AbcICULm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Sep 2016 16:11:42 -0400
Received: by mail-lf0-f43.google.com with SMTP id g62so104211799lfe.3
        for <linux-media@vger.kernel.org>; Sat, 03 Sep 2016 13:11:41 -0700 (PDT)
Subject: Re: [PATCH] vsp1: add R8A7792 VSP1V support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <10305550.upKOiT5SIy@wasted.cogentembedded.com>
 <2246517.O4DQlKpR2A@avalon>
Cc: mchehab@kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <15818c6d-2753-0e3c-d87d-8dfc101055b3@cogentembedded.com>
Date: Sat, 3 Sep 2016 23:11:38 +0300
MIME-Version: 1.0
In-Reply-To: <2246517.O4DQlKpR2A@avalon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 09/02/2016 01:47 AM, Laurent Pinchart wrote:

>> Add  support for the R8A7792 VSP1V cores which are different from the other
>> gen2 VSP1 cores...
>>
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>
>> ---
>> This patch is against the 'media_tree.git' repo's 'master' branch.
>
> The vsp1/next branch of my media.git tree contains a few patches that conflict
> with this patch. I've resolved the conflicts manually and pushed the result to
>
> 	git://linuxtv.org/pinchartl/media.git vsp1/next
>
> Could you please check the conflict resolution ?

    It seems alright. But I hate, hate, hate the forced branch updates! One 
wrong move and you're trapped with the changes you don't know how to resolve 
anyway... :-(

> Could you please also give me the full 32-bit IP version number for the VSP1V-
> D and VSP1V-S on R8A7792 ?

    As I told you on IRC:

[    2.563823] vsp1 fe928000.vsp1: IP version 0x01011201
[    2.574416] vsp1 fe930000.vsp1: IP version 0x01011301
[    2.583543] vsp1 fe938000.vsp1: IP version 0x01011301

MBR, Sergei

