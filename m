Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:41399 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbbAYRwK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2015 12:52:10 -0500
Received: by mail-ig0-f181.google.com with SMTP id hn18so4993812igb.2
        for <linux-media@vger.kernel.org>; Sun, 25 Jan 2015 09:52:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOBYczoCeMDjCJthynWyC5OhFCqKKDCSjsj93QkcrDHQMv+S3w@mail.gmail.com>
References: <CAOBYczptqxkRXVPs3UuKJxEtm7uf9=yF9DgpF+e5mqbj6wZRrQ@mail.gmail.com>
	<54C4D24D.2000706@iki.fi>
	<CAOBYczoCeMDjCJthynWyC5OhFCqKKDCSjsj93QkcrDHQMv+S3w@mail.gmail.com>
Date: Sun, 25 Jan 2015 19:52:09 +0200
Message-ID: <CAAZRmGzJ6DmP9hb5w+2kgrRW53rvS9ThS0-zX+Z96xf192YAUA@mail.gmail.com>
Subject: Re: usb3 + 2 x pctv290e issues
From: Olli Salonen <olli.salonen@iki.fi>
To: Robin Becker <robin@reportlab.com>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems I managed to miss the reply-all button, so I thought that in
case someone else is looking at this I'll post it here on the mailing
list as well. This is what I wrote:

"I saw this quite a while ago on my Intel NUC (that only has USB 3
ports, so I've got no choice).

The same issue is reported here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1313279

In OpenELEC we got rid of the issue by reverting one patch, look here:
https://github.com/OpenELEC/OpenELEC.tv/commit/b636927dec20652ff020e54ed7838a2e9be51e03
"

Cheers,
-olli

On 25 January 2015 at 18:08, Robin Becker <robin@reportlab.com> wrote:
> Thanks to all, I applied the patch suggested by Olli Salonen and I can
> now run multiple vlc's on my NUC.
>
> On 25 January 2015 at 11:23, Antti Palosaari <crope@iki.fi> wrote:
>> Moikka!
>>
>>
>> On 01/25/2015 11:33 AM, Robin Becker wrote:
>>>
>>> Has anyone else her had the problem described in
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=65021
>>>
>>> ie complete xhci freeze when a second pctv290e is accessed with vlc.
>>> I'm wondering if this is a problem specific to em28xx or the pctv290e
>>> or to this kind of device (ie dvb usb).
>>
>>
>> I have seen multiple times USB3 issues and reboot is needed in order to
>> solve those. USB3 is simply not enough robust yet. Due to that, I will never
>> use USB3 ports when developing the drivers - I only test it very quickly
>> when driver is about ready.
>>
>> regards
>> Antti
>>
>> --
>> http://palosaari.fi/
>
>
>
> --
> Robin Becker
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
