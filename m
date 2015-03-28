Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:35337 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbbC1MTq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2015 08:19:46 -0400
Received: by qgh3 with SMTP id 3so138751896qgh.2
        for <linux-media@vger.kernel.org>; Sat, 28 Mar 2015 05:19:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALzAhNXBw-cCvdfb=DjvKaMfk3JEyoAEGA_nPec4+=Hetj_yRA@mail.gmail.com>
References: <CALzAhNXBw-cCvdfb=DjvKaMfk3JEyoAEGA_nPec4+=Hetj_yRA@mail.gmail.com>
Date: Sat, 28 Mar 2015 08:19:45 -0400
Message-ID: <CALzAhNUZzMAqW4xmuoK3sZMM-8tdKaiz973kMhkV_9qTAMEgPw@mail.gmail.com>
Subject: Re: [GIT PULL] Adding HVR2205/HVR2255 support / misc cleanup
From: Steven Toth <stoth@kernellabs.com>
To: Linux-Media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Long awaited patches for the Hauppauge HVR2205 and HVR2255 in this patchset.
> Along with a fix for the querycap warning being thrown on newer kernels.

Mauro, I had a user point out that I'd missed a critical ATSC patch.
You'll see an additional patch in this
tree not mentioned in the original pull request "[media] saa7164: fix
HVR2255 ATSC inversion issue"

Please ensure this is also pulled.

Thank you sir!

- Steve+1.646.355.8490

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
