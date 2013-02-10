Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:47379 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab3BJQmP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 11:42:15 -0500
Received: by mail-we0-f182.google.com with SMTP id t57so4302642wey.41
        for <linux-media@vger.kernel.org>; Sun, 10 Feb 2013 08:42:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201302101602.43651.hverkuil@xs4all.nl>
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl>
	<201302100928.35795.hverkuil@xs4all.nl>
	<CA+6av4nUbHW9HTDbP0VnHZCuDUVKy7Q5DQSwEmFH7nQDZ934MQ@mail.gmail.com>
	<201302101602.43651.hverkuil@xs4all.nl>
Date: Sun, 10 Feb 2013 16:16:30 +0000
Message-ID: <CA+6av4m3iwimsYX46fjDjAvOG=QD3P1NgPVvoRg=i+2BnpPf7Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/8] stk-webcam: various fixes.
From: Arvydas Sidorenko <asido4@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 10, 2013 at 3:02 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Thanks, I found the bug. It's my fault: I made a logic error w.r.t. setting up
> the initial hflip/vflip values. I've read over it dozens of times without
> actually catching the - rather obvious - bug :-)
>
> Get the latest code, try again and if everything works fine for you then I'll
> clean up my patches and post the final version.
>

Looks good. Thanks for you effort!

Arvydas
