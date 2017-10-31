Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-m005e.mx.aol.com ([204.29.186.5]:60746 "EHLO
        omr-m005e.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932723AbdJaWoT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 18:44:19 -0400
Received: from mtaout-mba02.mx.aol.com (mtaout-mba02.mx.aol.com [172.26.133.110])
        by omr-m005e.mx.aol.com (Outbound Mail Relay) with ESMTP id 0C0DA380009A
        for <linux-media@vger.kernel.org>; Tue, 31 Oct 2017 18:44:19 -0400 (EDT)
Received: from [192.168.0.25] (unknown [181.231.56.226])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mtaout-mba02.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id DA0253800008A
        for <linux-media@vger.kernel.org>; Tue, 31 Oct 2017 18:44:17 -0400 (EDT)
To: linux-media@vger.kernel.org
From: =?UTF-8?Q?Alfredo_Jes=c3=bas_Delaiti?=
        <alfredodelaiti@netscape.net>
Subject: mb86a20s: last patches affect the card X8507
Message-ID: <28d6449b-b7e9-2a53-7820-e41d19633f1f@netscape.net>
Date: Tue, 31 Oct 2017 19:44:07 -0300
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: es-ANY
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

After updating my operating system I notice that my Mygica X8507 board 
has stopped working the digital part.

After bisecting the kernel: git: 
//git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
   I find that the patch: 
https://www.mail-archive.com/linux-media@vger.kernel.org/msg102082.html 
is the one that affects the operation. Reverting this patch I see that 
it tunes (FE_HAS_LOCK) but does not take any channel, so I try to also 
remove the patch 
https://www.mail-archive.com/linux-media@vger.kernel.org/msg102085.html, 
after doing this everything has worked perfectly again.

I have tried removing these patches with the latest versions of 
media_build.git, as well as with the latest kernels and everything works 
fine.

Can these patches be reversed?
Mr. Mauro Carvalho Chehab: can you try it if you still have the card 
Leadership X8502

Regards

Alfredo
