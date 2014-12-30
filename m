Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:50843 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaL3XXv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Dec 2014 18:23:51 -0500
Message-ID: <54A333FF.3050201@southpole.se>
Date: Wed, 31 Dec 2014 00:23:43 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC][PATCH] mn88472: add support for the mn88473 demod
References: <1419119853-29452-1-git-send-email-benjamin@southpole.se> <54960F0C.5020506@southpole.se> <54969102.3030204@iki.fi>
In-Reply-To: <54969102.3030204@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/21/2014 10:21 AM, Antti Palosaari wrote:
> Moikka!
>
[...]
>
>
> You patch looks rather good and these drivers should be merged to one if
> possible, lets say registers are 80% same or something like that. Looks
> like those are.

I've dropped this effort, the chips registers are not similar enough. 
The code that could be shared is not enough to give any advantage over 2 
drivers.

MvH
Benjamin Larsson
