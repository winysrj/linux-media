Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43023 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab1KUVnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 16:43:00 -0500
Received: by ywt32 with SMTP id 32so5190214ywt.19
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 13:42:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHFNz9KAi=XRZt=qM=KKnSKmmf_mn18JJAiUmd_5gXG71VBELA@mail.gmail.com>
References: <CAHFNz9KAi=XRZt=qM=KKnSKmmf_mn18JJAiUmd_5gXG71VBELA@mail.gmail.com>
Date: Mon, 21 Nov 2011 16:42:59 -0500
Message-ID: <CAOcJUbww1BZ6wxMMWxz40jmq+R093L9fTn-Bm8pknCrZrtYy5Q@mail.gmail.com>
Subject: Re: PATCH 00/13: Enumerate DVB frontend Delivery System capabilities
 to identify devices correctly.
From: Michael Krufky <mkrufky@linuxtv.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 21, 2011 at 4:05 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
> Hi,
>
> As discussed prior, the following changes help to advertise a
> frontend's delivery system capabilities.
>
> Sending out the patches as they are being worked out.
>
> The following patch series are applied against media_tree.git
> after the following commit
>
> commit e9eb0dadba932940f721f9d27544a7818b2fa1c5
> Author: Hans Verkuil <hans.verkuil@cisco.com>
> Date:   Tue Nov 8 11:02:34 2011 -0300
>
>    [media] V4L menu: add submenu for platform devices
>
>
> Regards,
> Manu

I am on board with this change -- it is a positive move in the right
direction.  I believe that after this is merged, we may be able to
obsolete and remove the set_params callback.  In fact, we can even
obsolete the set_analog_params callback as well, using set_state as
the single entry point for setting the tuner.  Of course, one step at
a time -- this is great for now.  We should consider the other
optimizations after this has been merged and tested. :-)

Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>
