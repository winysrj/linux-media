Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36541 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbbCYNXS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2015 09:23:18 -0400
In-Reply-To: <43CDB224-5B10-4234-9054-7A7EC1EDA3BF@butterbrot.org>
References: <550FFFB2.9020400@butterbrot.org> <55103587.3080901@butterbrot.org> <43CDB224-5B10-4234-9054-7A7EC1EDA3BF@butterbrot.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: input_polldev interval (was Re: [sur40] Debugging a race condition)?
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Wed, 25 Mar 2015 06:23:09 -0700
To: Florian Echtler <floe@butterbrot.org>,
	linux-input <linux-input@vger.kernel.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Benjamin Tissoires <benjamin.tissoires@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-ID: <DAFB1A9C-4AD7-4236-9945-6A456BEC7EDE@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On March 24, 2015 11:52:54 PM PDT, Florian Echtler <floe@butterbrot.org> wrote:
>Sorry for the continued noise, but this bug/crash is proving quite
>difficult to nail down.
>
>Currently, I'm setting the interval for input_polldev to 10 ms.
>However, with video data being retrieved at the same time, it's quite
>possible that one iteration of poll() will take longer than that. Could
>this ultimately be the reason? What happens if a new poll() call is
>scheduled before the previous one completes?

This can't happen as we schedule the next poll only after current one completes.

Hi Florian,
Thanks.

-- 
Dmitry
