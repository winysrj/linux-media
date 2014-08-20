Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:46065 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaHTXZu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 19:25:50 -0400
Received: by mail-wg0-f47.google.com with SMTP id b13so8380185wgh.18
        for <linux-media@vger.kernel.org>; Wed, 20 Aug 2014 16:25:49 -0700 (PDT)
From: James Hogan <james.hogan@imgtec.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 01/29] img-ir: fix sparse warnings
Date: Thu, 21 Aug 2014 00:25:45 +0100
Message-ID: <29366498.0jAlad3L7u@radagast>
In-Reply-To: <1408575568-20562-2-git-send-email-hverkuil@xs4all.nl>
References: <1408575568-20562-1-git-send-email-hverkuil@xs4all.nl> <1408575568-20562-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 21 August 2014 00:59:00 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> drivers/media/rc/img-ir/img-ir-nec.c:111:23: warning: symbol 'img_ir_nec'
> was not declared. Should it be static?
> drivers/media/rc/img-ir/img-ir-jvc.c:54:23: warning: symbol 'img_ir_jvc'
> was not declared. Should it be static?
> drivers/media/rc/img-ir/img-ir-sony.c:120:23: warning: symbol 'img_ir_sony'
> was not declared. Should it be static?
> drivers/media/rc/img-ir/img-ir-sharp.c:75:23: warning: symbol
> 'img_ir_sharp' was not declared. Should it be static?
> drivers/media/rc/img-ir/img-ir-sanyo.c:82:23: warning: symbol
> 'img_ir_sanyo' was not declared. Should it be static?
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: James Hogan <james.hogan@imgtec.com>

Thanks
James
