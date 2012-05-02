Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42719 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab2EBNMW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 09:12:22 -0400
Received: by qcro28 with SMTP id o28so302626qcr.19
        for <linux-media@vger.kernel.org>; Wed, 02 May 2012 06:12:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120502114430.GA4608@kipc2.localdomain>
References: <20120424122156.GA16769@kipc2.localdomain> <20120502084318.GA21181@kipc2.localdomain>
 <CAPueXH4-VSxHYjryO8kN5R-hG6seFrwCu3Kjrq4TXV=XFKLETg@mail.gmail.com> <20120502114430.GA4608@kipc2.localdomain>
From: Paulo Assis <pj.assis@gmail.com>
Date: Wed, 2 May 2012 14:12:01 +0100
Message-ID: <CAPueXH7TjHo-Dx2wUCQEcDvn=5L_xobYVKrf+b6wnmLGwOSeRg@mail.gmail.com>
Subject: Re: logitech quickcam 9000 uvcdynctrl broken since kernel 3.2 - PING
To: Karl Kiniger <karl.kiniger@med.ge.com>
Cc: linux-media@vger.kernel.org, linux-uvc-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

karl,
I've run some tests under ubuntu 12.04 with kernel 3.2.0 and
everything seems to be working fine.
I know some changes were made to the uvcvideo module regarding XU
controls, but I was under the impression that they wouldn't break
userspace.

Logitech shutdown the quickcamteam site, so you won't be able to
download libwebcam from there.
I'm currently the debian mantainer of that package, so I'll try to
test it on a newer kernel and patch it as necessary.
I'll also fix guvcview if needed.

Regards,
Paulo

2012/5/2 Karl Kiniger <karl.kiniger@med.ge.com>:
> Hi Paulo,
>
> I am running plain Fedora 16 on x86_64.
>
> The last kernel where UVC dyncontrols worked was 3.1.10-2.
> (If I remember correctly...) The first kernel with failing
> dyncontrols was 3.2.1-1 and all later kernels up to 3.3.2-6
> fail as well.
>
> libwebcam version is libwebcam-0.2.0-4.20100322svn and guvcview
> is guvcview-1.5.1-1.
>
> http://www.quickcamteam.net/software/libwebcam seems to be offline/
> discontinued since a few months.
>
> what software versions are you running? Is there a later libwebcam
> available from somewhere else?
>
> pls look also at:
> http://permalink.gmane.org/gmane.linux.kernel/1257500
>
> Greetings,
> Karl
>
> On Wed 120502, Paulo Assis wrote:
>> Karl Hi,
>> I'm using a 3.2 kernel and I haven't notice this problem, can you
>> check the exact version that causes it.
>>
>> Regards,
>> Paulo
>>
