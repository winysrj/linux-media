Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1695 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab3BJPCw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 10:02:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Arvydas Sidorenko <asido4@gmail.com>
Subject: Re: [RFC PATCH 1/8] stk-webcam: various fixes.
Date: Sun, 10 Feb 2013 16:02:43 +0100
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl> <201302100928.35795.hverkuil@xs4all.nl> <CA+6av4nUbHW9HTDbP0VnHZCuDUVKy7Q5DQSwEmFH7nQDZ934MQ@mail.gmail.com>
In-Reply-To: <CA+6av4nUbHW9HTDbP0VnHZCuDUVKy7Q5DQSwEmFH7nQDZ934MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302101602.43651.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun February 10 2013 15:46:05 Arvydas Sidorenko wrote:
> On Sun, Feb 10, 2013 at 8:28 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > I've improved this message, so please run again with the latest code and let me
> > know what it says. I don't understand all the upside-down problems...
> >
> 
> $ dmesg | grep upside
> upside down: 0 -1 -1
> 

Thanks, I found the bug. It's my fault: I made a logic error w.r.t. setting up
the initial hflip/vflip values. I've read over it dozens of times without
actually catching the - rather obvious - bug :-)

Get the latest code, try again and if everything works fine for you then I'll
clean up my patches and post the final version.

Thanks for testing!

Regards,

	Hans
