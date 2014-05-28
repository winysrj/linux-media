Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:56325 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191AbaE1O3W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 May 2014 10:29:22 -0400
Received: by mail-yk0-f174.google.com with SMTP id 9so8394084ykp.19
        for <linux-media@vger.kernel.org>; Wed, 28 May 2014 07:29:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC8M0Eu7AyMJxyo-knwXdeJEy_UAYMs=ufE+oDK-kwHWrqvPQg@mail.gmail.com>
References: <CAC8M0EtVTh+EmDaJa-Xmtm17x8VK6ozzw2A56Et_aj_m8ZFdpw@mail.gmail.com>
	<537CF2C4.6030302@iki.fi>
	<CAC8M0EsCjtc2+uPEQ=n36h_w4OEjoZOaHViAQgF_0MshgF2TJw@mail.gmail.com>
	<CALzAhNU50EFaZ83_+=4GYHN-rBdHPEMU3zufbqXroCJSJctmTw@mail.gmail.com>
	<CAC8M0Eu7AyMJxyo-knwXdeJEy_UAYMs=ufE+oDK-kwHWrqvPQg@mail.gmail.com>
Date: Wed, 28 May 2014 10:29:21 -0400
Message-ID: <CALzAhNX-m83z_odrt3=BiX-1zxQsH=N7H72DWSfEPtUqxtXYyA@mail.gmail.com>
Subject: Re: am i in the right list?
From: Steven Toth <stoth@kernellabs.com>
To: Michael Durkin <kc7noa@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 27, 2014 at 8:18 PM, Michael Durkin <kc7noa@gmail.com> wrote:
> what's the process tree like when its looked at?
>
> 1d5c:2000
>
> On Thu, May 22, 2014 at 8:44 AM, Steven Toth <stoth@kernellabs.com> wrote:
>>> Should i email Hans Verkuil or would he see this already ?
>>> Fresco Logic FL2000 USB to VGA adapter
>>
>> He would have seen this already.

I'm not sure I understand your question but let me take a shot at what
I think you mean. I think you mean, how does a developer someone go
about creating a driver for a new product?

1. They announce their intensions on the mailing-list (here), just to
check that no other developer is actively working the same driver.
This isn't mandatory, but can often avoid cases where multiple people
are working on the same end-goal.

2. Wait a week, anyone interested will likely comment very quickly, if
they are already working on something. If you get little or no
feedback then nobody is working in that area.

3. Assuming nobody is working on it (as in your case), go ahead and
start development - or hire someone to engineer the driver on your
behalf.

:)

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490
