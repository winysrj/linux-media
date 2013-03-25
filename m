Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4497 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab3CYKUF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 06:20:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH] media: move dvb-usb-v2/cypress_firmware.c to media/common.
Date: Mon, 25 Mar 2013 11:19:50 +0100
Cc: Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <64d364f6356c1b9c84ebfb15887f37ba822f3658.1364206645.git.hans.verkuil@cisco.com>
In-Reply-To: <64d364f6356c1b9c84ebfb15887f37ba822f3658.1364206645.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303251119.50355.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon March 25 2013 11:17:25 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Loading the cypress firmware is not dvb specific and should be common
> functionality. Move the source to media/common and make it a standalone
> module.
> 
> As a result we can remove the dependency on dvb-usb in go7007, which has
> nothing to do with dvb.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Sorry, I forgot to mention that this applies on top of the go7007 updates
I posted a few minutes earlier.

The git tree is here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/cypress-common

Regards,

	Hans
