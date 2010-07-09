Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56638 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab0GIVJW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 17:09:22 -0400
Received: by iwn7 with SMTP id 7so2618443iwn.19
        for <linux-media@vger.kernel.org>; Fri, 09 Jul 2010 14:09:21 -0700 (PDT)
Message-ID: <4C378FFF.7060204@gmail.com>
Date: Fri, 09 Jul 2010 17:09:19 -0400
From: Ivan <ivan.q.public@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: em28xx: success report for KWORLD DVD Maker USB 2.0 (VS-USB2800)
 [eb1a:2860]
References: <4C353039.4030202@gmail.com>	<AANLkTikiCtPhE8uERNoYV_UF43MZU0YQgPWxyA4X0l5U@mail.gmail.com>	<4C360E64.3020703@gmail.com>	<AANLkTilNmBPU-YVXfo12MITtTJHwsMvZsxkkjCBz68H_@mail.gmail.com>	<4C362C6E.5050104@gmail.com>	<AANLkTikCrka3EyqhjP7z6wYQa4Z8exDa9Dwda60OLsVJ@mail.gmail.com>	<4C363692.5000600@gmail.com>	<4C364416.3000809@gmail.com>	<AANLkTimRQaFDzKTXAIxIs2lT7ldrMwMNIFSJN4VzJOQQ@mail.gmail.com>	<4C364CD3.3080106@gmail.com>	<4C371A74.4080901@redhat.com>	<4C375A07.7010205@gmail.com>	<4C376479.2030101@redhat.com> <AANLkTilSonpCN_gzfsOYVaMpXbmfPFVi6Wdxb06dK7W1@mail.gmail.com> <4C378D35.3080007@redhat.com>
In-Reply-To: <4C378D35.3080007@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/09/2010 04:57 PM, Mauro Carvalho Chehab wrote:
> I meant that vertical risk that appeared when scaling is on. I never saw em28xx
> scaler doing something like that. It maybe some bug at mplayer or at the nvidia
> proprietary driver. We know that this driver has serious issues with their Xv
> support, and that it do some evil things when allocating kernel memory.

Sorry, what? You still want to argue that your vague suggestions trump 
the direct experiences of Devin and myself? That particular bug has 
already been identified and squashed (and I don't think it had much to 
do with scaling, but Devin could tell you for sure).
