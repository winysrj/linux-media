Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43874 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754577AbeFTTZ2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Jun 2018 15:25:28 -0400
Message-ID: <b9c48830959dc9d89c803d39d1eb707523d96cec.camel@collabora.com>
Subject: Re: [RFC 0/2] Memory-to-memory media controller topology
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        kernel@collabora.com
Date: Wed, 20 Jun 2018 16:25:19 -0300
In-Reply-To: <eb07f5fa149bc56775a2e7bc3695f581ac2c0135.camel@collabora.com>
References: <20180612104827.11565-1-ezequiel@collabora.com>
                         <46417cb4adca9289841287c8590b0ce92059298f.camel@collabora.com>
                 <d2d1d0938384a54bf1c268c83a2684c618bc4af9.camel@collabora.com>
         <eb07f5fa149bc56775a2e7bc3695f581ac2c0135.camel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2018-06-16 at 20:31 -0400, Nicolas Dufresne wrote:
> Le vendredi 15 juin 2018 à 17:05 -0300, Ezequiel Garcia a écrit :
> > > Will the end result have "device node name /dev/..." on both
> > > entity
> > > 1
> > > and 6 ? 
> > 
> > No. There is just one devnode /dev/videoX, which is accepts
> > both CAPTURE and OUTPUT directions.
> 
> My question is more ifthe dev node path will be provided somehow,
> because it's not displayed in this topologyé
> 

AFAIU, the device node associated to each media interface object
can be discovered via the G_TOPOLOGY[1] ioctl.

User gets the major:minor tuple, which can be used to get
the node path.

[1] https://linuxtv.org/downloads/v4l-dvb-apis/uapi/mediactl/media-ioc-
g-topology.html
