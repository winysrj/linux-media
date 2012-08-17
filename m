Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53563 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030708Ab2HQHmP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 03:42:15 -0400
Received: by ggdk6 with SMTP id k6so3740048ggd.19
        for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 00:42:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGzWAshccKZedEzaxboV0t-KO5yFp4UR=i_KdVtOV5LuNv6BHA@mail.gmail.com>
References: <bf682233fde61ca77ed4512ba77271f6daeedb31.1344592468.git.hans.verkuil@cisco.com>
	<1344597684-8413-1-git-send-email-hans.verkuil@cisco.com>
	<1c192a606143bbe1fb56fe02ffd5715e6592b3b6.1344592468.git.hans.verkuil@cisco.com>
	<CAGzWAshccKZedEzaxboV0t-KO5yFp4UR=i_KdVtOV5LuNv6BHA@mail.gmail.com>
Date: Fri, 17 Aug 2012 13:12:14 +0530
Message-ID: <CAGzWAsiiD-6U7iDF90Z+VYNnosP7HuafpdLVCRbZwRM27YnYjQ@mail.gmail.com>
Subject: Re: [RFCv3 PATCH 3/8] v4l2-subdev: add support for the new edid ioctls.
From: Soby Mathew <soby.linuxtv@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org, marbugge@cisco.com,
	Soby Mathew <soby.mathew@st.com>, mats.randgaard@cisco.com,
	manjunath.hadli@ti.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans
 I didnt catch this sentence in the documentation of the API "It is
not possible to set part of an EDID, it is always all or nothing." .
Guess, I have to read the documentation thoroughly before making
assumptions. It makes my question irrelevant.

Best Regards
Soby Mathew



On Thu, Aug 16, 2012 at 11:25 PM, Soby Mathew <soby.linuxtv@gmail.com> wrote:
> Hi Hans,
>    For EDID update, it is recommended that the HPD line be toggled
> after the EDID update is completed. So for the driver to detect the
> EDID write is complete, probably a field mentioning the EDID write
> completed would be good, so that the HPD toggling can be done by the
> driver.
>
> Best Regards
> Soby Mathew
>
<clipped>
