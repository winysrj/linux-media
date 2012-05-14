Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49399 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2ENEvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 00:51:19 -0400
Received: by vbbff1 with SMTP id ff1so4466494vbb.19
        for <linux-media@vger.kernel.org>; Sun, 13 May 2012 21:51:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FAF4BBA.9090904@redhat.com>
References: <4FADE682.3090005@netscape.net>
	<4FAE1CA1.1010203@redhat.com>
	<4FAEB948.7080800@netscape.net>
	<4FAF4BBA.9090904@redhat.com>
Date: Mon, 14 May 2012 00:51:18 -0400
Message-ID: <CAGoCfiyumZmX8PkPU_UQee4kpd82OBKF=1awLAmuL1WOcE=buQ@mail.gmail.com>
Subject: Re: How I must report that a driver has been broken?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 13, 2012 at 1:50 AM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
>
> On 05/12/2012 09:26 PM, Alfredo Jesús Delaiti wrote:
>>
>> Hi
>>
>> Thanks for your response Hans and Patrick
>>
>> Maybe I doing wrong this, because it reports twice:
>>
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg45199.html
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg44846.html
>
>
> In your last message you indicate that you've found the patch causing it,
> and that you were looking into figuring which bit of the patch actually
> breaks things, so I guess people reading the thread were / are
> waiting for you to follow up on it with the results of your attempts
> to further isolate the cause.
>
> What I were do if I were you is send a mail directly to the author
> of the patch causing the problems, with what you've discovered
> about the problem sofar in there, and put the list in the CC.
>
> Regards,
>
> Hans

Steven loaned me his HVR-1850 board last week, and I'm hoping to debug
the regression this week (I have an HVR-1800 that is also effected).
I suspect the problem is related to a codepath for the cx23888's
onboard DIF being executed for 885 based boards.  Steven did a whole
series of patches to make the cx23888 work properly and I think a
regression snuck in there.  Simply backing out the change isn't the
correct fix.

I've got all the boards and the datasheets - I just need to find a bit
of time to get the current tree installed onto a machine and plug in
the various boards...

In short, it's in my queue so please be patient.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
