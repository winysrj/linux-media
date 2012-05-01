Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47488 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757924Ab2EAR62 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 13:58:28 -0400
Received: by bkcji2 with SMTP id ji2so1095216bkc.19
        for <linux-media@vger.kernel.org>; Tue, 01 May 2012 10:58:25 -0700 (PDT)
Message-ID: <4FA02440.806@gmail.com>
Date: Tue, 01 May 2012 19:58:24 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de, hdegoede@redhat.com,
	moinejf@free.fr, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH/RFC v3 00/14] V4L camera control enhancements
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com> <201204301811.40034.hverkuil@xs4all.nl>
In-Reply-To: <201204301811.40034.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 04/30/2012 06:11 PM, Hans Verkuil wrote:
> Hi Sylwester!
> 
> I've finished my review. You made excellent documentation for the new controls!

Thank you, and thanks for your time! :-) It took me quite a few hours to prepare 
it, and lack of proper sensor datasheets didn't make this task any easier.

> Other than some small stuff the only thing I am unhappy about is the use of menu
> controls for what are currently just boolean controls.
> 
> I am inclined to make them boolean controls and add a comment that they may be
> changed to menu controls in the future. That shouldn't be a problem as long as 
> the control values 0 and 1 retain their meaning.

OK, I like the idea. The menus looked rather ugly, I agree. I'll revert 
those controls back to a boolean type and add a small note in the 
documentation. In fact this solves one of the major open issues I had.

I tried to align start of second columns in the nested 2-column tables
(<entrytbl></entrytbl>) containing a menu item identifiers and their
description. I tried 'align', 'colspec', 'spanspec' but could get 
expected results and I gave up, spending hours on modify/re-compile.
I couldn't even enable the column border inside 'entrytbl'. I could 
only align the columns by getting rid of 'entrytbl', but that's not
a solution. It doesn't look that bad with different indentation at
each control's description after all, maybe I'll find some time to 
dig in it later.

I'm going to incorporate all comments and resend whole patch set at 
end of the week.

--

Regards,
Sylwester
