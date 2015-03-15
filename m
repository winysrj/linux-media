Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44918 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbbCOOXX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 10:23:23 -0400
Message-ID: <550595D1.4080605@iki.fi>
Date: Sun, 15 Mar 2015 16:23:13 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "W.Pelser" <w.pelser@web.de>, linux-media@vger.kernel.org
Subject: Re: new bug
References: <55056136.2070305@web.de>
In-Reply-To: <55056136.2070305@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/15/2015 12:38 PM, W.Pelser wrote:
> I filed a new bug and I got a comment from Greg Kroah-Hartman:
>
> On Sat, Mar 14, 2015 at 06:17:39PM +0000,
> bugzilla-daemon@bugzilla.kernel.org wrote:
>  > https://bugzilla.kernel.org/show_bug.cgi?id=94861
>  >
>  >             Bug ID: 94861
>  >            Summary: After resume from hibernate/sleep USB-DVBT-adapter
>  >                     does not work
>
> Please send to the linux-media@vger.kernel.org mailing list.
>
> I hope, this time I can pass the spam-filter.
> <mailto:greg@kroah.com>

These media drivers does not support hibernate/suspend/resume generally, 
only runtime PM. Almost all drivers will just fail when you try sleep 
during streaming (only few usb drivers I made are supporting it).

In order to support hibernate driver needs to stop all (USB) 
communication on hibernate, which means in practice stopping remote 
controller polling and stopping possible data stream and on resume those 
should be restored.

regards
Antti

-- 
http://palosaari.fi/
