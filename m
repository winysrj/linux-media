Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46436 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab2ERO0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 May 2012 10:26:41 -0400
Received: by vbbff1 with SMTP id ff1so2542101vbb.19
        for <linux-media@vger.kernel.org>; Fri, 18 May 2012 07:26:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FB65975.3000806@netscape.net>
References: <4FADE682.3090005@netscape.net>
	<4FAE1CA1.1010203@redhat.com>
	<4FAEB948.7080800@netscape.net>
	<4FAF4BBA.9090904@redhat.com>
	<CAGoCfiyumZmX8PkPU_UQee4kpd82OBKF=1awLAmuL1WOcE=buQ@mail.gmail.com>
	<4FB65975.3000806@netscape.net>
Date: Fri, 18 May 2012 10:26:40 -0400
Message-ID: <CAGoCfiy3NY0_=VhbY59Q9EiZHg48S1C7s=z1FkWg+PLAG9Tw0Q@mail.gmail.com>
Subject: Re: How I must report that a driver has been broken?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 18, 2012 at 10:15 AM, Alfredo Jesús Delaiti
<alfredodelaiti@netscape.net> wrote:
> Hi
>
> Thank you all for your responses.
>
> Devin, I appreciate the time and labor you do to revise the code.
>
> My previous letters maybe I can help you see where the problem and the date
> you began.
> I thought of a patch of this type:
>
> if (card != mycard) {
>
> "bad code for my card"}
>
> but unfortunately not so easy for me.

Some initial analysis of the driver code I did last night suggests
it's much more complicated than that (in addition to the HVR-1850
support there was a bunch of refactoring done to the both the cx23885
and cx25840 drivers).

You can keep an eye on http://www.kernellabs.com/blog for updates.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
