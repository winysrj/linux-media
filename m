Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37908 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933213Ab1JYNFg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Oct 2011 09:05:36 -0400
Received: by iaby12 with SMTP id y12so526886iab.19
        for <linux-media@vger.kernel.org>; Tue, 25 Oct 2011 06:05:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAMvbhF0GJDxePwhRBmMRQaCH-EN7Cv1AKhgLO99sjdnba+v7A@mail.gmail.com>
References: <CAAMvbhF0GJDxePwhRBmMRQaCH-EN7Cv1AKhgLO99sjdnba+v7A@mail.gmail.com>
Date: Tue, 25 Oct 2011 09:05:36 -0400
Message-ID: <CADnq5_OD8M7tBJ-q7pf_2RS+VATzsy780W6Epd9ojisaczxuYA@mail.gmail.com>
Subject: Re: Display hotplug
From: Alex Deucher <alexdeucher@gmail.com>
To: James Courtier-Dutton <james.dutton@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 25, 2011 at 5:09 AM, James Courtier-Dutton
<james.dutton@gmail.com> wrote:
> Hi,
>
> Does anyone know when X will support display hotplug?
> I have a PC connected via HDMI to a TV.
> Unless I turn the TV on first, I have to reboot the PC before it
> displays anything on the HDMI TV.

It's be supported on all modern KMS drivers (radeon, intel, nouveau)
assuming you have a recent enough userspace to deal with the hotplug
uevents.

Alex
