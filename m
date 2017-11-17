Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:40397 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932554AbdKQF4K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 00:56:10 -0500
Received: by mail-pg0-f51.google.com with SMTP id u3so1188449pgn.7
        for <linux-media@vger.kernel.org>; Thu, 16 Nov 2017 21:56:10 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        <linux-kernel@vger.kernel.org>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [RFC v5 03/11] [media] vb2: add =?iso-8859-1?Q?'ordered=5Fin=5Fdriver'_property_to_queues?=
Date: Fri, 17 Nov 2017 14:56:05 +0900
MIME-Version: 1.0
Message-ID: <42409bb3-a6b6-43e7-a915-7e8e5f1f2198@chromium.org>
In-Reply-To: <20171115171057.17340-4-gustavo@padovan.org>
References: <20171115171057.17340-1-gustavo@padovan.org>
 <20171115171057.17340-4-gustavo@padovan.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, November 16, 2017 2:10:49 AM JST, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
>
> We use ordered_in_driver property to optimize for the case where
> the driver can deliver the buffers in an ordered fashion. When it
> is ordered we can use the same fence context for all fences, but
> when it is not we need to a new context for each out-fence.

"we need to a new context" looks like it is missing a word.
