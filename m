Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36011 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbbLNMzt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 07:55:49 -0500
MIME-Version: 1.0
In-Reply-To: <566E9ADC.1030608@xs4all.nl>
References: <1449849893-14865-1-git-send-email-ulrich.hecht+renesas@gmail.com>
	<566AF904.9050102@xs4all.nl>
	<566E9ADC.1030608@xs4all.nl>
Date: Mon, 14 Dec 2015 13:55:47 +0100
Message-ID: <CAO3366zrZsrsZWt1aC94+qDBUKkD4r_x1W2O59jZJHWCCbF1Uw@mail.gmail.com>
Subject: Re: [PATCH 0/3] adv7604: .g_crop and .cropcap support
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, SH-Linux <linux-sh@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent <laurent.pinchart@ideasonboard.com>,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, William Towle <william.towle@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 14, 2015 at 11:33 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> OK, my http://git.linuxtv.org/hverkuil/media_tree.git/log/?h=rmcrop branch now has a
> rebased patch to remove g/s_crop. Only compile-tested. It's just the one patch that you
> need.

Thank you, that works perfectly with rcar_vin and adv7604; I'll send a
revised series.

CU
Uli
