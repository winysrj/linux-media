Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:39638 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbbLRLAq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 06:00:46 -0500
Subject: Re: Preliminary HDCP code available in my tree
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
References: <5673BE11.7040702@xs4all.nl>
 <CAH-u=81eoRTXyog9wekZohajEU21b8nNSH+=S2ppAj3eLAombw@mail.gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	mkhelik@cisco.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5673E755.5090909@xs4all.nl>
Date: Fri, 18 Dec 2015 12:00:37 +0100
MIME-Version: 1.0
In-Reply-To: <CAH-u=81eoRTXyog9wekZohajEU21b8nNSH+=S2ppAj3eLAombw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/18/2015 10:59 AM, Jean-Michel Hautbois wrote:
> Hi Hans,
> 
> 
> 2015-12-18 9:04 GMT+01:00 Hans Verkuil <hverkuil@xs4all.nl <mailto:hverkuil@xs4all.nl>>:
> 
>     Hi all,
> 
>     Two years ago Cisco did some work on HDCP support for HDMI receivers and transmitters,
>     but for one reason or another that work was never put into actual use. Rather than
>     letting that work go unnoticed I decided to put it up in my git tree:
> 
>     http://git.linuxtv.org/hverkuil/media_tree.git/log/?h=hdcp
> 
>     It's missing documentation, it's tested with HDCP 1.4 only (not 2.2), and it needs some
>     TLC, but it was working at the time. So this could be a good starting point for someone.
> 
>     If someone decides to work on this, please contact me first.
> 
> 
> I will give it a try soon, as I was about to implement it :).
> I have an ADV7611 and an ADV7604 so it will be interesting.
> I will keep you informed.

Well, as they say: timing is everything :-)

Let me know how it goes. I'm sure you'll have questions, just ask me and CC
Mikhail (the author of the code).

Regards,

	Hans
