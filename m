Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35352 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759242Ab2DJTyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 15:54:49 -0400
Received: by iagz16 with SMTP id z16so198427iag.19
        for <linux-media@vger.kernel.org>; Tue, 10 Apr 2012 12:54:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <jwv4nsrtlo8.fsf-monnier+gmane.linux.drivers.video-input-infrastructure@gnu.org>
References: <jwv4nsyx9pr.fsf-monnier+gmane.linux.drivers.video-input-infrastructure@gnu.org>
	<CAGoCfiwKU1doqvdcHFpVoc2xuRQKdQirWze0oB2QQyXSQcYrKw@mail.gmail.com>
	<jwv1unvwrtn.fsf-monnier+gmane.linux.drivers.video-input-infrastructure@gnu.org>
	<CAGoCfix+YHc3wPUvdwudqk5rAed09BroPX6wf-5N6BxXV5fV0Q@mail.gmail.com>
	<jwv4nsrtlo8.fsf-monnier+gmane.linux.drivers.video-input-infrastructure@gnu.org>
Date: Tue, 10 Apr 2012 15:54:48 -0400
Message-ID: <CADnq5_MWUU3pjyR8+YqUJYmb-k8Knw_WVCjV0jWcsjsh1vXMEA@mail.gmail.com>
Subject: Re: Unknown eMPIA tuner
From: Alex Deucher <alexdeucher@gmail.com>
To: Stefan Monnier <monnier@iro.umontreal.ca>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 10, 2012 at 3:49 PM, Stefan Monnier
<monnier@iro.umontreal.ca> wrote:
>> Ok, so it's an em2874/drx-j/tda18271 design, which in terms of the
>> components is very similar to the PCTV 80e (which I believe Mauro got
>> into staging recently).  I would probably recommend looking at that
>> code as a starting point.
>
> Any pointers to actual file names?
>
>> That said, you'll need to figure out the correct IF frequency, the
>> drx-j configuration block, the GPIO layout, and the correct tuner
>> config.  If those terms don't mean anything to you, then you are best
>> to wait until some developer stumbles across the device and has the
>> time to add the needed support.
>
> The words aren't meaningless to me, but not too far either.  Maybe if
> someone could give me pointers as to how I could try to figure out the
> corresponding info, I could give it a try.

Probably useful to start with the config from a similar card (lots of
vendors use the same reference design) and see how much of it works
then tweak from there until you get it fully working.

Alex
