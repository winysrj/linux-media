Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:48410 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbaIBQVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Sep 2014 12:21:08 -0400
Received: by mail-lb0-f177.google.com with SMTP id z11so7959294lbi.36
        for <linux-media@vger.kernel.org>; Tue, 02 Sep 2014 09:21:06 -0700 (PDT)
Message-ID: <5405EECA.6060801@googlemail.com>
Date: Tue, 02 Sep 2014 18:22:34 +0200
From: =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Lorenzo Marcantonio <l.marcantonio@logossrl.com>
CC: linux-media@vger.kernel.org
Subject: Re: strange empia device
References: <20140825190109.GB3372@aika.discordia.loc> <5403358C.4070504@googlemail.com> <1409615932.1819.16.camel@palomino.walls.org> <20140902062822.GA2805@aika.logos.lan>
In-Reply-To: <20140902062822.GA2805@aika.logos.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 02.09.2014 um 08:28 schrieb Lorenzo Marcantonio:
> On Mon, Sep 01, 2014 at 07:58:52PM -0400, Andy Walls wrote:
>> A Merlin firmware of 16 kB strongly suggests that this chip has an
>> integarted Conexant CX25843 (Merlin Audio + Thresher Video = Mako)
>> Broadtcast A/V decoder core.  The chip might only have a Merlin
>> integrated, but so far I've never encountered that.  It will be easy
>> enough to tell, if the Thresher registers don't respond or only respond
>> with junk.
> However I strongly suspect that these drivers are for a whole *family*
> of empia device. The oem ini by roxio talks about three different
> parts... probably they give one sys file for everyone and the oem
> customizes the ini.
>
> In short the merlin fw may not be actually used for *this* part but only
> for other empia devices/configurations.
>
> Otherwise I wonder *why* a fscking 1.5MB of sys driver for a mostly dumb
> capture device...
Right. There is also no firmware upload in the USB-log I have checked.

Regards,
Frank
