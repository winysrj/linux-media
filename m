Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.matrix-vision.com ([78.47.19.71]:58923 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab2GXGsv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 02:48:51 -0400
Message-ID: <500E43C0.1010007@matrix-vision.de>
Date: Tue, 24 Jul 2012 08:42:08 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] Documentation: DocBook DRM framework documentation
References: <1342137623-7628-1-git-send-email-laurent.pinchart@ideasonboard.com> <500D69EB.6000008@matrix-vision.de> <70690010.zp9nLr8Ar9@avalon>
In-Reply-To: <70690010.zp9nLr8Ar9@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

> I've used "behavior" when copying sections from the existing documentation.
> I'll unify that. Does kernel documentation favour one of the spellings ?
>

Looking at v3.5, the American spelling is more common, but looking at 
how you spell favour, I think I know which one you favor :)

linux-git$ grep -ri behaviour Documentation/ | wc -l
150
linux-git$ grep -ri behavior Documentation/ | wc -l
269

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
