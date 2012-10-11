Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47146 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab2JKMy2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 08:54:28 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so990785wey.19
        for <linux-media@vger.kernel.org>; Thu, 11 Oct 2012 05:54:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ4uU1Dt+1ixM-E9BhdeguNQ3QJMHvUckCm7OJeraH19LpSx3g@mail.gmail.com>
References: <CAJ4uU1Dt+1ixM-E9BhdeguNQ3QJMHvUckCm7OJeraH19LpSx3g@mail.gmail.com>
Date: Thu, 11 Oct 2012 15:54:27 +0300
Message-ID: <CAJ4uU1Bda04GDDwXYW9OMewbR1nTQtxZihy7_1r3FnXJTkxVsQ@mail.gmail.com>
Subject: SoC camera host drivers
From: Dmitry Lavnikevich <haff@midgard.by>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

I'm trying to implement camera support for my i.MX6 board and cannot
understand a couple of (it seems) simple things according to how it
all must work.

My camera is mt9m001 and i can perfectly find and use it's camera
driver. But as far as I understand, host driver must be loaded too...
and there is a very few of them. I can find host drivers for
surprisingly few platforms like pxa_camera, mx1_camera, mx2_camera and
a few others. But there is no mx6 or something for it. And i cannot
understand why. Is it means that needed driver just wasn't implemented
yet and I must write it on my own, or I don't understand something
essential?

Because I can see in kernel meny board specific source files where
different SoC cameras are enabled but at the same time I cannot find
needed host drivers. For instance I see in
arch/arm/mach-mx6/board-mx6q_arm2.c enabled soc camera ov5640 but
again i cannot find a thing about needed mx6 host driver. Is that
means that this board camera actually cannot be used because of
absence of needed host driver or am I missing something?

Best regards,
Lavnikevich Dmitry
