Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3947 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719Ab3BJRa1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 12:30:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Arvydas Sidorenko <asido4@gmail.com>
Subject: Re: [RFC PATCH 1/8] stk-webcam: various fixes.
Date: Sun, 10 Feb 2013 18:30:07 +0100
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl> <201302101602.43651.hverkuil@xs4all.nl> <CA+6av4m3iwimsYX46fjDjAvOG=QD3P1NgPVvoRg=i+2BnpPf7Q@mail.gmail.com>
In-Reply-To: <CA+6av4m3iwimsYX46fjDjAvOG=QD3P1NgPVvoRg=i+2BnpPf7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302101830.07581.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun February 10 2013 17:16:30 Arvydas Sidorenko wrote:
> On Sun, Feb 10, 2013 at 3:02 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > Thanks, I found the bug. It's my fault: I made a logic error w.r.t. setting up
> > the initial hflip/vflip values. I've read over it dozens of times without
> > actually catching the - rather obvious - bug :-)

After rechecking I discovered that I didn't introduce this after all. It was
recently introduced in a patch for the 3.9 kernel. Luckily that patch isn't
in the upcoming 3.8 kernel.

> > Get the latest code, try again and if everything works fine for you then I'll
> > clean up my patches and post the final version.
> >
> 
> Looks good. Thanks for you effort!

No problem, nice to have another driver pass the compliance test.

Regards,

	Hans
