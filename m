Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52842 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab1H3QHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 12:07:54 -0400
Received: by ywf7 with SMTP id 7so5701627ywf.19
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2011 09:07:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E5CFA0B.3010207@mlbassoc.com>
References: <4E56734A.3080001@mlbassoc.com>
	<4E5CEECC.6040804@mlbassoc.com>
	<4E5CF118.3050903@mlbassoc.com>
	<201108301620.09365.laurent.pinchart@ideasonboard.com>
	<4E5CFA0B.3010207@mlbassoc.com>
Date: Tue, 30 Aug 2011 18:07:39 +0200
Message-ID: <CA+2YH7sfhWz_ubLExnGKmyLKOVKGOXYOmH6a1Hoy8ssJeMQnWQ@mail.gmail.com>
Subject: Re: Getting started with OMAP3 ISP
From: Enrico <ebutera@users.berlios.de>
To: Gary Thomas <gary@mlbassoc.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 30, 2011 at 4:56 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> Yes, that helped a lot.  When I create the devices by hand, I can now see
> my driver starting to be accessed (right now it's very much an empty stub)

>From your logs it seems you are using a tvp5150, i've posted a patch
[1] for tvp5150 that makes it very close to work, it could be faster
to debug it instead of starting from scratch.

Enrico

[1] http://www.spinics.net/lists/linux-media/msg37116.html
