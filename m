Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55613 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbbAYLX7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2015 06:23:59 -0500
Message-ID: <54C4D24D.2000706@iki.fi>
Date: Sun, 25 Jan 2015 13:23:57 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Robin Becker <robin@reportlab.com>, linux-media@vger.kernel.org
Subject: Re: usb3 + 2 x pctv290e issues
References: <CAOBYczptqxkRXVPs3UuKJxEtm7uf9=yF9DgpF+e5mqbj6wZRrQ@mail.gmail.com>
In-Reply-To: <CAOBYczptqxkRXVPs3UuKJxEtm7uf9=yF9DgpF+e5mqbj6wZRrQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 01/25/2015 11:33 AM, Robin Becker wrote:
> Has anyone else her had the problem described in
>
> https://bugzilla.kernel.org/show_bug.cgi?id=65021
>
> ie complete xhci freeze when a second pctv290e is accessed with vlc.
> I'm wondering if this is a problem specific to em28xx or the pctv290e
> or to this kind of device (ie dvb usb).

I have seen multiple times USB3 issues and reboot is needed in order to 
solve those. USB3 is simply not enough robust yet. Due to that, I will 
never use USB3 ports when developing the drivers - I only test it very 
quickly when driver is about ready.

regards
Antti

-- 
http://palosaari.fi/
