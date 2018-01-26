Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:41547 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbeAZVoi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 16:44:38 -0500
Received: by mail-qt0-f173.google.com with SMTP id i1so4858486qtj.8
        for <linux-media@vger.kernel.org>; Fri, 26 Jan 2018 13:44:38 -0800 (PST)
Message-ID: <1517003075.32074.29.camel@ndufresne.ca>
Subject: Re: [RFC PATCH 6/8] v4l2: document the request API interface
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Randy Dunlap <rdunlap@infradead.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 26 Jan 2018 16:44:35 -0500
In-Reply-To: <98ccb2f3-156e-2f4e-4630-9d16d157d65b@infradead.org>
References: <20180126060216.147918-1-acourbot@chromium.org>
         <20180126060216.147918-7-acourbot@chromium.org>
         <98ccb2f3-156e-2f4e-4630-9d16d157d65b@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le vendredi 26 janvier 2018 à 12:40 -0800, Randy Dunlap a écrit :
> > +Request API
> > +===========
> > +
> > +The Request API has been designed to allow V4L2 to deal with
> > requirements of
> > +modern IPs (stateless codecs, MIPI cameras, ...) and APIs (Android
> > Codec v2).
> 
> Hi,
> Just a quick question:  What are IPs?
> 
> Not Internet Protocols. Hopefully not Intellectual Properties.
> Maybe Intelligent Processors?

Stands for "Intellectual Property". Used like this, I believe it's a
bit of a slang. It's also slightly pejorative as we often assume that
self contained "IP Cores" are proprietary black box. But considering
all the security issues that was found in these black boxes firmwares,
it's kind of fair criticism.

Nicolas

p.s. I'd propose to rephrase this in later version
