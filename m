Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42452 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbeFHN0S (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2018 09:26:18 -0400
Message-ID: <fc4b8760c8f61fcee758b28574d25bd0143f90ce.camel@collabora.com>
Subject: Re: [PATCH v3 00/20] v4l2 core: push ioctl lock down to ioctl
 handler
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: kernel@collabora.com, Abylay Ospan <aospan@netup.ru>
Date: Fri, 08 Jun 2018 10:24:44 -0300
In-Reply-To: <bcb16fa2-e915-9329-de37-3bbdddd84f30@xs4all.nl>
References: <20180524203520.1598-1-ezequiel@collabora.com>
         <bcb16fa2-e915-9329-de37-3bbdddd84f30@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2018-06-08 at 14:11 +0200, Hans Verkuil wrote:
> Hi Ezequiel,
> 
> On 05/24/2018 10:35 PM, Ezequiel Garcia wrote:
> > Third spin of the series posted by Hans:
> > 
> > https://www.mail-archive.com/linux-media@vger.kernel.org/msg131363.html
> 
> Can you rebase this? Several patches have already been merged, so it would
> be nice to have a new clean v4. Can you also move patch 11/20 (dvb-core) to
> after patch 16/20? It makes it a bit easier for me to apply the patches before
> that since the dvb patch needs an Ack from Mauro at the very least.
> 
> But I can take the v4l patches, that should be no problem.
> 
> 

No problem.

Thanks,
Eze
