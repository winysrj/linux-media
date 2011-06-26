Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:29137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab1FZSzN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2011 14:55:13 -0400
Message-ID: <4E07808C.9060105@redhat.com>
Date: Sun, 26 Jun 2011 15:55:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/14] Remove linux/version.h from most drivers/media
References: <20110626130620.4b5ed679@pedra> <20110626201420.018490cd@tele>
In-Reply-To: <20110626201420.018490cd@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 26-06-2011 15:14, Jean-Francois Moine escreveu:
> On Sun, 26 Jun 2011 13:06:20 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
>> drivers/media/video/gspca/gspca.c                  |   12 +++-------
> 
> Hi Mauro,
> 
> I could not find the gspca.c changes in your patch set.

It was fold at the wrong changeset. it is at: 

    [media] et61x251: Use LINUX_VERSION_CODE for VIDIOC_QUERYCAP
    
    et61x251 doesn't use vidioc_ioctl2. As the API is changing to use
    a common version for all drivers, we need to expliticly fix this
    driver.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

I'll move it to the right changeset at the version 2 of this series.

Mauro
