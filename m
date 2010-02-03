Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2581 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab0BCKlA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 05:41:00 -0500
Message-ID: <dd5e898cb64e7f76edfc36d263ba12aa.squirrel@webmail.xs4all.nl>
In-Reply-To: <4B6946A3.9080803@redhat.com>
References: <4B1E1974.6000207@jusst.de> <4B1E532C.9040903@redhat.com>
    <4B6946A3.9080803@redhat.com>
Date: Wed, 3 Feb 2010 11:40:42 +0100
Subject: Re: New DVB-Statistics API - please vote
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "Julian Scheel" <julian@jusst.de>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Mauro Carvalho Chehab wrote:
>
>>> after the last thread which asked about signal statistics details
>>> degenerated into a discussion about the technical possibilites for
>>> implementing an entirely new API, which lead to nothing so far, I
>>> wanted
>>> to open a new thread to bring this forward. Maybe some more people can
>>> give their votes for the different options
>
> Only me and Manu manifested with opinions on this thread. Not sure why
> nobody else gave their comments. Maybe all interested people just decided
> to take a long vacation and are not listening to their emails ;)
>
> Seriously, from what I understand, this is an API improvement and we need
> to take a decision on it. So, your opinions are important.
>
> ---
>
> Let me draw a summary of this subject, trying to be impartial.
>
> The original proposal were made by Manu. My proposal is derived from
> Manu's
> original one, both will equally provide the same features.
>
> The main difference is that Manu's proposal use a struct to get the
> statistics while my proposal uses DVBS2API.
>
> With both API proposals, all values are get at the same time by the
> driver.
> the DVBS2API adds a small delay to fill the fields, but the extra delay is
> insignificant, when compared with the I/O delays needed to retrieve the
> values from the hardware.
>
> Due to the usage of DVBS2API, it is possible to retrieve a subset of
> statistics.
> When obtaining a subset, the DVBS2API latency is considerable faster, as
> less
> data needed to be transfered from the hardware.
>
> The DVBS2API also offers the possibility of expanding the statistics
> group, since
> it is not rigid as an struct.
>
> One criteria that should be reminded is that, according with Linux Kernel
> rules,
> any userspace API is stable. This means that applications compiled against
> an
> older API version should keep running with the latest kernel. So, whatever
> decided,
> the statistics API should always maintain backward compatibility.
>
> ---
>
> During the end of the year, I did some work with an ISDB-T driver for
> Siano, and
> I realized that the usage of the proposed struct won't fit well for
> ISDB-T. The
> reason is that, on ISDB-T, the transmission uses up to 3 hierarchical
> layers.
> Each layer may have different OFDM parameters, so the devices (at least,
> this is the
> case for Siano) has a group of statistics per layer.
>
> I'm afraid that newer standards may also bring different ways to present
> statistics, and
> the current proposal won't fit well.
>
> So, in my opinion, if it is chosen any struct-based approach, we'll have a
> bad time to
> maintain it, as it won't fit into all cases, and we'll need to add some
> tricks to extend
> the struct.
>
> So, my vote is for the DVBS2API approach, where a new group of statistics
> can easily be added,
> on an elegant way, without needing of re-discussing the better API or to
> find a way to extend
> the size of an struct without breaking backward compatibility.

>From a purely technical standpoint the DVBS2API is by definition more
flexible and future-proof. The V4L API has taken the same approach with
controls (basically exactly the same mechanism). Should it be necessary in
the future to set multiple properties atomically, then the same technique
as V4L can be used (see VIDIOC_S_EXT_CTRLS).

The alternative is to make structs with lots of reserved fields. It
depends on how predictable the API is expected to be. Sometimes you can be
reasonably certain that there won't be too many additions in the future
and then using reserved fields is perfectly OK.

Just my 5 cents based on my V4L experience.

Regards,

          Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

