Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:48169 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393Ab0DISyO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 14:54:14 -0400
Message-ID: <4BBF77BC.3030309@mailbox.hu>
Date: Fri, 09 Apr 2010 20:53:48 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] cx88: implement sharpness control
References: <4BADFC12.4030707@mailbox.hu> <4BBEAE08.5010908@redhat.com>
In-Reply-To: <4BBEAE08.5010908@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/09/2010 06:33 AM, Mauro Carvalho Chehab wrote:

> You're not adjusting the sharpness. Instead, you're changing the vertical tap filter,
> and just for the even frames, plus the notch filter.
> Tricky, and you're probably affecting the sharpness, but on an indirect and non-linear
> way, as you're adjusting different measures.

No, I actually change the luma peak filter, which can add a peak of up
to about 6 dB centered at the chroma subcarrier frequency. So, it does
increase sharpness, and horizontally, not vertically. I did test the
patch before submitting it. Also, there is code in the patch that sets
the parameter for the odd field as well. So, in fact, this control
affects three registers: two for the peak filter, and a third one for
the notch filter.

> If this is really needed, it would be better to break it into two controls
> (one for the notch filter and another for the vertical tap filter).

Yes, that could possibly have been a good idea to have a separate
control for the notch filter. It was just easier to implement this way,
and I think there is no existing control that would be well suited for
the notch filter. Since both parameters do affect sharpness in some way,
I implemented it as a single control, rather than creating a separate
new one.

> Also, the "side effect" is not good: if you're using those bits, your code should assure
> that no other part of the driver will touch on the used bits, and that the device will
> be initialized with the default standard.

That is correct, and I did note that it would be addressed later if the
general idea of implementing the control is accepted. Fortunately, the
registers are changed elsewhere at only about two places.

By the way, did you have a look at the other two cx88 patches
(containing minor fixes only) I sent at the same time ?
