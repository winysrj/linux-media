Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.unsolicited.net ([173.255.193.191]:42895 "EHLO
	mx1.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbcEKTF0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 15:05:26 -0400
Subject: Re: Patch: V4L stable versions 4.5.3 and 4.5.4
To: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <57337E39.40105@unsolicited.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	gregkh@linuxfoundation.org
From: David R <david@unsolicited.net>
Message-ID: <57338272.4080908@unsolicited.net>
Date: Wed, 11 May 2016 20:05:22 +0100
MIME-Version: 1.0
In-Reply-To: <57337E39.40105@unsolicited.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/05/16 19:47, David R wrote:
> Hi
> 
> Please consider applying the attached patch (or something like it) to
> V4L2, and whatever is appropriate to the mainstream kernel. Without this
> my media server crashes and burns at boot.
> 
> See https://lkml.org/lkml/2016/5/7/88 for more details
> 
> Thanks
> David
> 
I see the offending patch was reverted earlier today. My box is fine
with my (more simple) alternative, but your call.

David
