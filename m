Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2907 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3BGPI2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 10:08:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [RFCv1 PATCH 00/20] cx231xx: v4l2-compliance fixes
Date: Thu, 7 Feb 2013 16:08:15 +0100
Cc: linux-media@vger.kernel.org,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com
References: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl> <CAGoCfizYMTrfExhT4oeevmhUuysG6MY_CUNkzL7mY51Xjz51LQ@mail.gmail.com>
In-Reply-To: <CAGoCfizYMTrfExhT4oeevmhUuysG6MY_CUNkzL7mY51Xjz51LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302071608.15848.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue January 29 2013 17:41:29 Devin Heitmueller wrote:
> On Tue, Jan 29, 2013 at 11:32 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > I will take a closer look at the vbi support, though.. It would be nice to get
> > that working.
> 
> FYI:  I had the VBI support working when I submitted the driver
> upstream (at least for NTSC CC).  If it doesn't work, then somebody
> broke it.

OK, I did some more tests and it turned out to be related to the no_alt_vanc
setting in the board definitions. If it is 1, then usb_set_interface() is
never called and the endpoint is never created.

It's unclear to me if this means that if no_alt_vanc is set, then the vbi node
should be disabled. It seems that way.

Unfortunately, of the three cx231xx devices I have no_alt_vanc is set on two
and the third (Hauppauge EXETER) is the one where the tda18271 tuner has
issues: it always gets errors when writing to it. It used to load correctly
about 10% of the time in the past, but now I can't get it to work at all.

Devin, I think you said once that you knew what is going on. Do you have
any code that I can try to make it work again?

I did manage to stream vbi, but with a non-functioning tuner I can't check
if it really works or not.

Regards,

	Hans
