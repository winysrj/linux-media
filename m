Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40369 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbbBYRht (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 12:37:49 -0500
Received: by pdev10 with SMTP id v10so6325114pde.7
        for <linux-media@vger.kernel.org>; Wed, 25 Feb 2015 09:37:49 -0800 (PST)
Message-ID: <54EE086B.9020904@gmail.com>
Date: Wed, 25 Feb 2015 09:37:47 -0800
From: Steve Longerbeam <slongerbeam@gmail.com>
MIME-Version: 1.0
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: i.MX6 Video combiner
References: <CAL8zT=g2uUDQYgfNW5017YCKjfxBz7Oj+9FSvdo4PXZgiOAKWQ@mail.gmail.com>
In-Reply-To: <CAL8zT=g2uUDQYgfNW5017YCKjfxBz7Oj+9FSvdo4PXZgiOAKWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/25/2015 02:57 AM, Jean-Michel Hautbois wrote:
> Hi all,
>
> I read in the i.MX6 TRM that it can do combining or deinterlacing with VDIC.
> Has it been tested by anyone ?
> Could it be a driver, which would allow to do some simple compositing
> of souces ?
>
> Thanks,
> JM

I've added VDIC support (deinterlace with motion compensation) to the
capture driver, it's in the my media tree clone:

git@github.com:slongerbeam/mediatree.git, mx6-media-staging

Steve
