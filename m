Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51483 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab1DRPPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 11:15:35 -0400
Received: by ewy4 with SMTP id 4so1396079ewy.19
        for <linux-media@vger.kernel.org>; Mon, 18 Apr 2011 08:15:34 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 18 Apr 2011 08:15:34 -0700
Message-ID: <BANLkTimoKzWrAyCBM2B9oTEKstPJjpG_MA@mail.gmail.com>
Subject: Embedded Linux memory management interest group list
From: Jesse Barker <jesse.barker@linaro.org>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

One of the big issues we've been faced with at Linaro is around GPU
and multimedia device integration, in particular the memory management
requirements for supporting them on ARM.  This next cycle, we'll be
focusing on driving consensus around a unified memory management
solution for embedded systems that support multiple architectures and
SoCs.  This is listed as part of our working set of requirements for
the next six-month cycle (in spite of the URL, this is not being
treated as a graphics-specific topic - we also have participation from
multimedia and kernel working group folks):

  https://wiki.linaro.org/Cycles/1111/TechnicalTopics/Graphics

I am working on getting the key technical decision makers to provide
input and participate in the requirements collection and design for a
unified solution. We had an initial birds-of-a-feather discussion at
the Embedded Linux Conference in San Francisco this past week to kick
off the effort in preparation for the first embedded-memory-management
mini-sprint in Budapest week of May 9th at Linaro@UDS.  One of the
outcomes of the BoF was the need for a mailing list to coordinate
ideas, planning, etc.  The subscription management for the list is
located at http://lists.linaro.org/mailman/listinfo/linaro-mm-sig.
The mini-summit in Budapest will have live audio and an IRC channel
for those that want to participate (details to go out on the list).
We expect to have additional summits over the course of the cycle,
with the next one likely at Linux Plumbers in September (though, I
would like to try for one more before then).

cheers,
Jesse
