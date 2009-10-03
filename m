Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:65156 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZJCGuH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2009 02:50:07 -0400
Received: by fxm27 with SMTP id 27so1678765fxm.17
        for <linux-media@vger.kernel.org>; Fri, 02 Oct 2009 23:50:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <F05EB5AC-F40E-4FD6-92D6-5DB92406A4C8@wilsonet.com>
References: <4AC5FA6E.2000201@tmr.com>
	 <1254514454.3169.51.camel@palomino.walls.org>
	 <F05EB5AC-F40E-4FD6-92D6-5DB92406A4C8@wilsonet.com>
Date: Sat, 3 Oct 2009 02:50:10 -0400
Message-ID: <829197380910022350t66736b23qc57ee320f3a6f6ac@mail.gmail.com>
Subject: Re: Upgrading from FC4 to current Linux
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Bill Davidsen <davidsen@tmr.com>,
	"video4linux M/L" <video4linux-list@redhat.com>,
	Andy Walls <awalls@radix.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 2, 2009 at 11:24 PM, Jarod Wilson <jarod@wilsonet.com> wrote:
>> (Non-emulated) OSS was ditched by the linux kernel folks long ago.  And
>> I thought xawtv and tvtime were abandon-ware.
>
> Yeah, seems that way. Though Devin's been talking about maybe starting up a
> new tvtime maintenance tree, which Fedora would be happy to contribute to
> and track... (nudge, nudge, Devin ;)

Yeah, I started working on it when I was at the Plumbers Conference,
but haven't wanted to commit to it publicly until I had something
working, mainly because it's a project I'm working on in the
background (and I've already got three or four such projects).  And
like most stuff I'm working on, progress can always be sped up
considerably if a commercial party comes along and decides its worth
sponsoring (but the converse applies as well - progress slows down on
background items when I'm working on other sponsored work).

In the worst case, tvtime is my target use case for the part of the
Media Controller framework that allows you to associate video streams
with ALSA and VBI devices, so it *will* get done eventually.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
