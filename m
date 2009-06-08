Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out002.kontent.com ([81.88.40.216]:44735 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbZFHLCR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 07:02:17 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alexey Klimov <klimov.linux@gmail.com>
Subject: Re: Probably strange bug with usb radio-mr800
Date: Mon, 8 Jun 2009 13:03:02 +0200
Cc: Linux Media <linux-media@vger.kernel.org>,
	linux-usb@vger.kernel.org,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Greg KH <gregkh@suse.de>
References: <208cbae30905271051jfe3294bye415b5b4cd0ce14b@mail.gmail.com> <200906062307.14730.oliver@neukum.org> <208cbae30906070641j12cc04c1vcaf28f31b38e8e1e@mail.gmail.com>
In-Reply-To: <208cbae30906070641j12cc04c1vcaf28f31b38e8e1e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906081303.02570.oliver@neukum.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sonntag, 7. Juni 2009 15:41:13 schrieb Alexey Klimov:

> > If not, the driver may not be 64bit clean. Which driver is affected?
>
> media/radio/radio-mr800.c

I can see no obvious 64bit problem.

> Please, also take a look in my first letter to usb and v4l mail lists
> from May 27.

Please resend that and put linux-usb@vger.kernel.org into cc.

	Regards
		Oliver

