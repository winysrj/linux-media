Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21903 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933186AbbFIQZh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2015 12:25:37 -0400
Date: Tue, 9 Jun 2015 19:25:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ksenija =?utf-8?Q?Stanojevi=C4=87?= <ksenija.stanojevic@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
	Arnd Bergmann <arnd@arndb.de>, mchehab@osg.samsung.com,
	y2038@lists.linaro.org, jarod@wilsonet.com,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [Y2038] [PATCH] Staging: media: lirc: Replace timeval with
 ktime_t
Message-ID: <20150609162515.GY28762@mwanda>
References: <1432310322-3745-1-git-send-email-ksenija.stanojevic@gmail.com>
 <3768175.5Bdztn7jIp@wuerfel>
 <CAL7P5j+YfuysVeCyFQZ9DwN872Ke=PyE5fakBjdR-9h4VqN1pQ@mail.gmail.com>
 <20150608201239.GA16736@kroah.com>
 <CAL7P5j+ALaL62ymkr312PbOSPVPtgg3SzMgdrO=HQrc_T4+ugg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL7P5j+ALaL62ymkr312PbOSPVPtgg3SzMgdrO=HQrc_T4+ugg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 09, 2015 at 06:15:50PM +0200, Ksenija Stanojević wrote:
> On Mon, Jun 8, 2015 at 10:12 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Jun 08, 2015 at 09:37:24PM +0200, Ksenija Stanojević wrote:
> >> Hi Greg,
> >>
> >> It's been over two weeks that I've sent this patch.  Have you missed it?
> >
> > Not at all, please look at the output of
> >         $ ./scripts/get_maintainer.pl --file drivers/staging/media/lirc/lirc_sir.c
> >
> 
> Ok. I used:
>  ./scripts/get_maintainer.pl --nokeywords --nogit --nogit-fallback
> --norolestats --file

That command works fine.

> 
> I'll use instead ./scripts/get_maintainer.pl --file and send a v2.

No need.  You sent it to linux-media@vger.kernel.org and Mauro the first
time.  Just be patient.

regards,
dan carpenter

