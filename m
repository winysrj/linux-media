Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:36130 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728AbbLNNCV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 08:02:21 -0500
Subject: Re: [PATCH 0/3] adv7604: .g_crop and .cropcap support
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
References: <1449849893-14865-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <566AF904.9050102@xs4all.nl> <566E9ADC.1030608@xs4all.nl>
 <CAO3366zrZsrsZWt1aC94+qDBUKkD4r_x1W2O59jZJHWCCbF1Uw@mail.gmail.com>
Cc: linux-media@vger.kernel.org, SH-Linux <linux-sh@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent <laurent.pinchart@ideasonboard.com>,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, William Towle <william.towle@codethink.co.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <566EBDD7.7010006@xs4all.nl>
Date: Mon, 14 Dec 2015 14:02:15 +0100
MIME-Version: 1.0
In-Reply-To: <CAO3366zrZsrsZWt1aC94+qDBUKkD4r_x1W2O59jZJHWCCbF1Uw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/14/2015 01:55 PM, Ulrich Hecht wrote:
> On Mon, Dec 14, 2015 at 11:33 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> OK, my http://git.linuxtv.org/hverkuil/media_tree.git/log/?h=rmcrop branch now has a
>> rebased patch to remove g/s_crop. Only compile-tested. It's just the one patch that you
>> need.
> 
> Thank you, that works perfectly with rcar_vin and adv7604; I'll send a
> revised series.

Just making sure: you have actually tested cropping with my patch?

It would also be interesting to see if you can run v4l2-compliance for rcar. See what it says.

Running with the -f option would be the ultimate test, but I think that's too much to ask.

Regards,

	Hans

