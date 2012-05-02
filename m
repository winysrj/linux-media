Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63215 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab2EBN6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 09:58:31 -0400
Received: by vcqp1 with SMTP id p1so426768vcq.19
        for <linux-media@vger.kernel.org>; Wed, 02 May 2012 06:58:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2923357.1335965525570.JavaMail.root@mswamui-chipeau.atl.sa.earthlink.net>
References: <2923357.1335965525570.JavaMail.root@mswamui-chipeau.atl.sa.earthlink.net>
Date: Wed, 2 May 2012 09:58:30 -0400
Message-ID: <CAGoCfiy2kJRsAiYmGrQs6X9Z-cvPUR=4RsZMKMSzG1Z0CbuM6Q@mail.gmail.com>
Subject: Re: HVR-1800 Analog Driver: MPEG video broken
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: sitten74490@mypacks.net
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 2, 2012 at 9:32 AM,  <sitten74490@mypacks.net> wrote:
> I have been testing the latest cx23885 driver built from http://git.kernellabs.com/?p=stoth/cx23885-hvr1850-fixups.git;a=summary running on kernel 3.3.4 with my HVR-1800 (model 78521).  I am able to watch analog TV with tvtime using the raw device, /dev/video0.  But if I try to use it with the MPEG device, /dev/video1, I briefly get a blue screen and then tvtime segfaults.

Tvtime segfaulting if you try to use it on an MPEG device is a known
tvtime bug.  Tvtime lacks an MPEG decoder, and only works with devices
that support raw video.

cat /dev/video1 > /tmp/foo.mpg gives video with moving, distorted,
mostly black and white diagonal lines just like @Britney posted here:
http://www.kernellabs.com/blog/?p=1636.

Yup, I've been going back and forth with bfransen on this.  I received
a board last week, and am hoping to debug it this week.

Regards,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
