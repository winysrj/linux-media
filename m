Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:55505 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaKOKEa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Nov 2014 05:04:30 -0500
Received: by mail-pa0-f49.google.com with SMTP id lj1so19065684pab.36
        for <linux-media@vger.kernel.org>; Sat, 15 Nov 2014 02:04:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANZNk82OVwQP3aZO3uherp3jcL1LYyF8z9Lx2hzZr-FccODhdQ@mail.gmail.com>
References: <m3lhneez9h.fsf@t19.piap.pl>
	<CANZNk82C9SmBXx4T=CxRjLGOZPuRdahwF4mXYUk8pJ427vdCPQ@mail.gmail.com>
	<m3wq6xpivf.fsf@t19.piap.pl>
	<CANZNk82OVwQP3aZO3uherp3jcL1LYyF8z9Lx2hzZr-FccODhdQ@mail.gmail.com>
Date: Sat, 15 Nov 2014 14:04:29 +0400
Message-ID: <CANZNk8226SU_Nsc8jmp7Sy2vmsJ9mUkkPyYjvOTTc82Of-avHw@mail.gmail.com>
Subject: Re: SOLO6x10: fix a race in IRQ handler.
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: =?ISO-8859-2?Q?Krzysztof_Ha=B3asa?= <khalasa@piap.pl>
Cc: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof, it seems to really help. The host is working stable for 2.5
hours at the moment, with original framerate of 2 fps.
Thank you very much.

-- 
Andrey Utkin
