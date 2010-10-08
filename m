Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42227 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797Ab0JHVPS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Oct 2010 17:15:18 -0400
Received: by gyg13 with SMTP id 13so233792gyg.19
        for <linux-media@vger.kernel.org>; Fri, 08 Oct 2010 14:15:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101008151110.127a62fe@bike.lwn.net>
References: <20101008210412.E85769D401B@zog.reactivated.net>
	<20101008151110.127a62fe@bike.lwn.net>
Date: Fri, 8 Oct 2010 22:15:17 +0100
Message-ID: <AANLkTi=Lsu0JXgQ5ZGja0w7q6+wzQA1gmpx9b724UH+Z@mail.gmail.com>
Subject: Re: [PATCH 1/3] ov7670: remove QCIF mode
From: Daniel Drake <dsd@laptop.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 8 October 2010 22:11, Jonathan Corbet <corbet@lwn.net> wrote:
> I'm certainly not attached to this mode, but...does it harm anybody if
> it's there?

Yes. Applications like gstreamer will pick this resolution if its the
closest resolution to the target file resolution. On XO-1 we always
pick a low res so gstreamer picks this one. And we end up with a video
that only records a miniscule portion of the FOV.

All the other settings of the camera scale the image so that the whole
FOV is covered. But this one records at normal resolution, only
sending a small center portion of the FOV. The same pixels can be read
by recording at full res and then just cutting out the center bit.

Daniel
