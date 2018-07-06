Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49398 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753638AbeGFPYU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2018 11:24:20 -0400
Message-ID: <b6e1c77c1efeb6aaf40d17fc2e6d04f30dace47a.camel@collabora.com>
Subject: Re: [PATCH v4 03/17] omap4iss: Add vb2_queue lock
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        sakari.ailus@iki.fi
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com
Date: Fri, 06 Jul 2018 12:24:12 -0300
In-Reply-To: <73b3a8aa-90c9-9bba-92df-b243a394f6bb@xs4all.nl>
References: <20180615190737.24139-1-ezequiel@collabora.com>
         <20180615190737.24139-4-ezequiel@collabora.com>
         <73b3a8aa-90c9-9bba-92df-b243a394f6bb@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-07-02 at 10:28 +0200, Hans Verkuil wrote:
> On 15/06/18 21:07, Ezequiel Garcia wrote:
> > vb2_queue lock is now mandatory. Add it, remove driver ad-hoc
> > locks, and implement wait_{prepare, finish}.
> 
> I don't see any wait_prepare/finish implementation?!
> 
> 

Oops, seems it felt through the cracks.

Anyway, we need to solve the omap3 issues before going forward with
this series.

Thanks,
Eze
